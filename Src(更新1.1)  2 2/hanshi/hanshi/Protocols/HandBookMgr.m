//
//  HandBookMgr.m
//  hanshi
//
//  Created by wujin on 14/12/27.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "HandBookMgr.h"

NSString * const kHandBookMgrDownloadProgressChangedNotification=@"kHandBookMgrDownloadProgressChangedNotification";
NSString * const kHandBookMgrDownloadProgressOneCompleteNotification=@"kHandBookMgrDownloadProgressOneCompleteNotification";

@interface HandBookMgr(){
	NSString *dir;
	HanBook *hanbook;
	NSInteger total;
}
@property (assign) int current;
@end
@interface HandBookDownload : NSInvocationOperation{
	NSString *dir;
}
-(instancetype)initWithUrl:(NSString*)url dir:(NSString*)savedir;
@property (nonatomic,assign) NSObject *noteObj;
@end
@implementation HandBookMgr
-(instancetype)initWithHandBook:(HanBook *)book
{
	self=[super init];
	if (self) {
		dir=[NSString stringWithFormat:@"%@/Document/books/%@/",NSHomeDirectory(),book.hbid];
		[self checkDir:dir];
		hanbook=book;
		self.maxConcurrentOperationCount=1;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oneComplete:) name:kHandBookMgrDownloadProgressOneCompleteNotification object:self];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	dir=nil;
	hanbook=nil;
}
-(void)checkDir:(NSString*)directory
{
	NSFileManager* mgr=[NSFileManager defaultManager];
	BOOL isdir=NO;
	if([mgr fileExistsAtPath:directory isDirectory:&isdir]||isdir==NO){
		[mgr createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
	}
}
-(HandBookMgrType)state
{
	NSString *filename=[dir stringByAppendingString:@"all.json"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:filename]==NO) {
		return HandBookMgrTypeNone;
	}
	HanBook *noew=[[HanBook alloc] initWithJson:[NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL]];
	if ([noew.gxdate isEqualToString:hanbook.gxdate]) {//更新时间相同
		return HandBookMgrTypeNew;
	}
	//时间不同，需要更新
	return HandBookMgrTypeNeedNew;
}
-(void)downloadWithList:(HanBookOneList *)list
{
	self.current=0;
	[list.arrayString.JSONString writeToFile:[dir stringByAppendingString:@"list.json"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	[self cancelAllOperations];
	total=list.count;
	for (HanBookOne *one in list) {
		HandBookDownload *d=[[HandBookDownload alloc] initWithUrl:one.cpic dir:dir];
		d.noteObj=self;
		[self addOperation:d];
	}
}
-(void)oneComplete:(NSNotification*)note
{
	self.current++;
	[[NSNotificationCenter defaultCenter] postNotificationName:kHandBookMgrDownloadProgressChangedNotification object:self userInfo:@{@"p":[NSNumber numberWithFloat:self.current*1.0/total]} onMainThread:YES];
	if(self.current==total){
		[hanbook.dictionary.JSONString writeToFile:[dir stringByAppendingString:@"all.json"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	}
}
-(HanBookOneList*)list
{
	return  [[HanBookOneList alloc] initWithJson:[NSString stringWithContentsOfFile:[dir stringByAppendingString:@"list.json"] encoding:NSUTF8StringEncoding error:NULL]];
}
-(NSString*)imagePathForOne:(HanBookOne *)one
{
	return [dir stringByAppendingString:one.cpic.md5DecodingString];
}
-(HanBook*)book
{
	return hanbook;
}
@end
@implementation HandBookDownload

-(instancetype)initWithUrl:(NSString *)url dir:(NSString *)savedir
{
	self =[super initWithTarget:self selector:@selector(download:) object:url];
	if (self) {
		dir=savedir;
        [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:dir]];
	}
	return self;
}
- (void)dealloc
{
	dir=nil;
}
-(void)download:(NSString*)url
{
	NSURL *uri=[NSURL URLWithString:url];
	NSString *filename=[url md5DecodingString];
	NSString *path=[dir stringByAppendingPathComponent:filename];

	BOOL isdir=NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isdir]&&isdir==NO) {
	}else{
	NSData *data=[NSData dataWithContentsOfURL:uri];
    
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    
    [self addSkipBackupAttributeToItemAtURL:pathUrl];
        
//	[data writeToFile:path atomically:YES];
    [data writeToURL:pathUrl atomically:YES];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:kHandBookMgrDownloadProgressOneCompleteNotification object:self.noteObj];
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
//    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    
    if(version >=5.1f){
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    return NO;
}
//- (void)addSkipBackupAttributeToPath:(NSString*)path {
//    u_int8_t b = 1;
//    setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
//}
@end
