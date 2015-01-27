//
//  SysLead.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "SysLead.h"
#import "Constants.h"
@implementation SysLead
-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"sys/lead/");
	self.requestMethod=@"GET";
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary* dic=[super handleSusessParam:str Susess:result];
	[Config setSplash:[dic objectForKey:@"list"]];
	return dic;
}
@end

@implementation SysPublishpic
-(void)requestWithPage:(NSString*)page SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"sys/publishpic/");
	self.requestMethod=@"GET";
	[queryDictionary setObject:page forKey:@"show_page"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}


@end

@implementation SysIntroduction

-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"sys/introduction/");
	self.requestMethod=@"GET";
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

@end

@implementation SysPreview

-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"sys/pview/");
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

@end

@implementation SysCheckUpdate

-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"sys/checkupdate/");
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	return [dic objectForKey:@"ncontent"];
}

@end