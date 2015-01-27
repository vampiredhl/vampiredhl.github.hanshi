//
//  ProtocolHelper.m
//  Cloud
//
//  Created by wujin on 12-9-27.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import "ProtocolHelper.h"
#import "Reachability.h"
#import "Extension.h"
#import "iOSShare.h"
#import "Statement.h"
#import "ASINetworkQueue.h"

/**
 错误的Domain
 */
NSString * const kProtocolHelperErrorDomain = @"iOS-ProtocolHelper";

NSString * const kProtocolHelperLocalizedDescription = @"请检查网络连接是否正常";

/**
 空的返回值
 */
int const kProtocolHelperErrorCodeEmptyResponseCode = -1;

NSString * const kProtocolHelperErrorCodeEmptyResponseDescription=@"网络连接失败，请稍后重试";

/**
 返回结果不为JSON字符串
 */
int const kProtocolHelperErrorCodeResponseNotJsonStringCode = -2;

NSString * const kProtocolHelperErrorCodeResponseNotJsonStringDescription=@"网络连接失败，请稍后重试";

/*
 内部处理错误
 */
int const kProtocolHelperErrorCodeInternalErrorCode = -3;
NSString * const kProtocolHelperErrorCodeInternalErrorDescription=@"网络连接失败，请稍后重试";

/**
 没有网络联接
 */
int const kProtocolHelperErrorCodeNoConnectionCode = -4;

NSString * const kProtocolHelperErrorCodeNoConnectionDescription = @"请检查网络连接是否正常";


int const kProtocolHelperErrorCodeUserCancel = -5;

@implementation ProtocolHelper

-(id)init
{
    self=[super init];
    if (self) {
        self.requestMethod = @"POST";//默认为POST请求
        postDictionary=[[NSMutableDictionary alloc] init];
        headerDictionary=[[NSMutableDictionary alloc] init];
        fileDictionary=[[NSMutableDictionary alloc] init];
		queryDictionary=[[NSMutableDictionary alloc] init];
        
        self.async=YES;
        self.useCache=NO;
        self.timeOut=10;
		self.invokeHandleSusessAndFailOnDispatch=YES;
        str_response=[[NSMutableString alloc] init];
		//在程序退出到后台或者即将结束的时候取消请求
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
#ifdef _Protocol_DEBUG
	DDLogInfo(@"Protocol %@ dealloc susess\r\n",self.description);
#endif
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.finishBlock) {
        self.finishBlock=nil;
    }
    if (self.failBlock) {
        self.failBlock=nil;
    }
    self.requestUrl=nil;
    self.requestMethod=nil;
    self.ext_args=nil;
	
    [postDictionary release];
    [headerDictionary release];
    [fileDictionary release];
	[queryDictionary release];
    
    
    [asiRequest clearDelegatesAndCancel];
    [asiRequest release];
    self.ext_args=nil;
    [str_response release];
    
    [super dealloc];
}


-(ASIHTTPRequest*)asiRequest
{
    return asiRequest;
}

#pragma mark -
#pragma mark -request
-(void)requestWithSusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
    self.finishBlock=susessBlock;
    self.failBlock=failBlock;
    
    if (self.useCache) {
        //先返回缓存读取到的数据
        [self dataFromCache];
        if (cacheLParam!=nil||cacheRParam!=nil) {
            [self cacheSusessWithlParam:cacheLParam RParam:cacheRParam];
        }
        
        //如果断网状态下，如果缓存读取失败，调用失败方法
        else if (![self reachablityToInternet]) {
            [self failWithParam:[ProtocolHelperError errorWithDomain:kProtocolHelperErrorDomain code:kProtocolHelperErrorCodeNoConnectionCode userInfo:nil description:kProtocolHelperErrorCodeNoConnectionDescription] RParam:self];
        }
        cacheLParam=nil;
        cacheRParam=nil;
    }
    
    if (asiRequest!=nil) {
        [asiRequest clearDelegatesAndCancel];
        [asiRequest release];
		asiRequest=nil;
    }
    
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    
    
    
    //URL不为空并且能够联网的情况下再请求
    if (StringNotNullAndEmpty(self.requestUrl)&&[reach currentReachabilityStatus]!=kNotReachable)
    {
		//拼接get参数
		if (queryDictionary.allKeys.count>0) {
			NSString *url=self.requestUrl;
			if ([url componentsSeparatedByString:@"?"].count==0) {
				url=[url stringByAppendingString:@"&"];
			}else{
				url=[url stringByAppendingString:@"?"];
			}
			for (NSString *key in queryDictionary.allKeys) {
				NSString *format=[NSString stringWithFormat:@"%@",[queryDictionary valueForKey:key]];
				
				format = NSMakeCollectable([(NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)format, NULL,CFSTR("!():/?#[]@$&'+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8) autorelease]);
				
				format=_S(@"%@=%@&",key,format);
				
				url=[url stringByAppendingString:format];
				
			}
			//移除最后一个&
			if ([url hasSuffix:@"&"]) {
				url=[url stringByPaddingToLength:url.length-1 withString:@"" startingAtIndex:url.length-2];
			}
			self.requestUrl=url;
		}
		[self requestWillBegin];
		
        asiRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:self.requestUrl]];
        
        
        
        for (int i=0; i<headerDictionary.allKeys.count; i++) {
            [asiRequest addRequestHeader:headerDictionary.allKeys[i] value:headerDictionary.allValues[i]];
        }
        
        for (int i=0; i<fileDictionary.allKeys.count; i++) {
            [asiRequest addFile:fileDictionary.allValues[i] forKey:fileDictionary.allKeys[i]];
        }
        
        asiRequest.requestMethod=self.requestMethod;
        asiRequest.shouldRedirect = NO;///disable asi redirect
        asiRequest.delegate=self;
        asiRequest.useCookiePersistence=NO;
        asiRequest.timeOutSeconds=self.timeOut;//默认10S超时
        [asiRequest setPersistentConnectionTimeoutSeconds:60*10];//默认保持连接10分钟
        [asiRequest setShouldAttemptPersistentConnection:YES];//默认启用keep alive
        
        [asiRequest addRequestHeader:@"Accept" value:@"application/json"];
        [asiRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [asiRequest setDidFailSelector:@selector(requestFailed:)];
        [asiRequest setDidFinishSelector:@selector(requestFinished:)];
        [asiRequest setDidStartSelector:@selector(requestStarted:)];
		///默认禁用后台加载
//		[asiRequest setShouldContinueWhenAppEntersBackground:NO];
        
        for (NSString *key in postDictionary.allKeys) {
            [asiRequest setPostValue:[postDictionary objectForKey:key] forKey:key];
        }
        //        NSData* data = [postDictionary.JSONString dataUsingEncoding:NSUTF8StringEncoding];
        //        [asiRequest setPostBody:[NSMutableData dataWithData:data]];
        ///如果自动开始请求，则开始请求
        if(self.startManual==NO)
        {
            [self startRequest];
        }
        
    }else{//如果不使用缓存，调用失败
        if (!self.useCache) {
            [self failWithParam:[ProtocolHelperError errorWithDomain:kProtocolHelperErrorDomain code:kProtocolHelperErrorCodeNoConnectionCode userInfo:nil description:kProtocolHelperErrorCodeNoConnectionDescription] RParam:self];
        }
    }
}

-(void)startRequest
{
    [self requestWillStart];
    if (self.async==YES) {
        [asiRequest startAsynchronous];
    }else{
        [asiRequest startSynchronous];
    }
    [self requestDidStart];
    
    if (self.autoRetainRelease) {
        [self retain];
    }
}

-(void)requestWillBegin
{
	
}
-(void)requestDidStart
{
	
}
-(void)requestWillStart
{
	
}

/*
 调用成功处理逻辑
 */
-(void)susessWithlParam:(id)lParam RParam:(id)rParam
{
#ifdef _Protocol_DEBUG
    
    [str_response appendFormat:@"%@-<%p> response %d -%@",[[self class] description],self,asiRequest.responseStatusCode,self.requestUrl];
    
    [str_response appendString:@"\r\n*********************************************\r\n"];
    [str_response appendFormat:@"response:\r\n%@\r\n",asiRequest.responseString];
    if (asiRequest.responseCookies.count>1) {
        [str_response appendFormat:@"cookies:%@\r\n",asiRequest.responseCookies.description];
    }
    [str_response appendString:@"\r\n*********************************************\r\n"];
    
    DDLogInfo(@"%@",str_response);
#endif
    __block ProtocolHelper *block_self=self;
    [self invokeRequestBlock: ^{
        if(block_self.finishBlock!=nil){
            //主线程回调
			@autoreleasepool {
				block_self.finishBlock(lParam,rParam);
			}
			block_self.finishBlock=nil;
			block_self.failBlock=nil;
            
        }
    }];
}
/*
 调用成功处理逻辑
 */
-(void)cacheSusessWithlParam:(id)lParam RParam:(id)rParam
{
#ifdef _Protocol_DEBUG
    DDLogInfo(@"\r\n%@:cache-%@<%p> \r\nparam:\r\n*********************************************\r\n%@\r\n*********************************************\r\n",[[self class ]description],self.requestUrl,lParam,lParam);
#endif
    __block ProtocolHelper *block_self=self;
    [self invokeRequestBlock:^{
        if(block_self.finishBlock!=nil){
            //主线程回调
            
			
			@autoreleasepool {
				block_self.finishBlock(lParam,rParam);
			}
            
            
        }
    }];
}

/*
 调用失败处理逻辑
 */
-(void)failWithParam:(id)lParam RParam:(id)rParam
{
#ifdef _Protocol_DEBUG
    DDLogInfo(@"%@:fail-%@<%p> \r\nparam:\r\n*********************************************\r\n%@\r\n%@\r\n*********************************************\r\n",[[self class ]description],self.requestUrl,self,asiRequest.responseString,lParam);
#endif
    __block ProtocolHelper *block_self=self;
    
    [self invokeRequestBlock:^{
        
        if (block_self.failBlock!=nil) {
            //主线程回调
            
            
			@autoreleasepool {
                block_self.failBlock(lParam,rParam);
			}
			block_self.finishBlock=nil;
			block_self.failBlock=nil;
            
            
        }
    }];
}

-(void)invokeHandleSusessOrFail:(dispatch_block_t)block
{
	if (self.invokeHandleSusessAndFailOnDispatch==YES) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
	}else{
		block();
	}
}

-(void)invokeRequestBlock:(dispatch_block_t)block
{
	if (self.invokeHandleSusessAndFailOnDispatch==YES) {
		dispatch_async(dispatch_get_main_queue(), block);
	}else{
		block();
	}
}

/*
 从缓存读取数据
 */
-(void)dataFromCache
{
    cacheLParam=nil;
    cacheRParam=nil;
}

#pragma mark -
#pragma mark -add param and resolve
/*
 解析返回成功报文的参数
 请将解析完成后的数据传回
 */
-(id)handleSusessParam:(NSString*)str Susess:(BOOL*)result
{
    *result=YES;
    id dic= [str objectFromJSONString];
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
		
        NSNumber *retcode=[dic objectForKey:@"StatusCode"];
        
        if (![retcode isKindOfClass:[NSNumber class]]) {
            *result=NO;
            return nil;
        }
        
        self.resultCode=[retcode intValue];
		
        if (self.resultCode!=200) {//不等于200，结果错误
            *result=NO;
			
            NSString *code=_S(@"%d",self.resultCode);
            DDLogError(@"\r\nprotocol return resultcode-%@\r\n",code);
            dic=nil;
        }
    }
    
    return dic;
}


/*
 解析失败报文的参数
 请将解析完成后的数据传回
 */
-(id)handleFailParam:(NSString*)str
{
    id result= [str objectFromJSONString];
    int code=kProtocolHelperErrorCodeResponseNotJsonStringCode;
	NSString *descrip=kProtocolHelperErrorCodeResponseNotJsonStringDescription;
    if (result==nil) {
        //从asi中取的错误信息
        NSError *error=asiRequest.error;
        if (error.code==4) {
            code=kProtocolHelperErrorCodeUserCancel;
			descrip=kProtocolHelperErrorCodeInternalErrorDescription;
        }
    }
    return [ProtocolHelperError errorWithDomain:kProtocolHelperErrorDomain code:code userInfo:result description:descrip];
}

#pragma mark-
#pragma mark asihttprequest delegate
- (void)requestStarted:(ASIHTTPRequest *)nrequest
{
    
#ifdef _Protocol_DEBUG
    //[NSMutableString stringWithFormat:@"%p %@:request-%@\n param:\n*********************************************\n%@\n \ncookie:%@ method:%@"
    NSMutableString *str=[NSMutableString stringWithFormat:@"\r\n%@ <%p>: request start-%@",[[self class] description],self,self.requestUrl];
    [str appendFormat:@"\r\n*********************************************\r\n"];
    if(postDictionary.allKeys.count>0)
    {
        [str appendFormat:@"\r\nrequest-param:{%@}",postDictionary.description];
    }
    if (nrequest.requestCookies.count) {
        [str appendFormat:@"\r\nrequest-cookie:{%@}",nrequest.requestCookies.description];
    }
    
    [str appendFormat:@"\r\nrequest-method:%@",self.requestMethod];
    
    if (headerDictionary.allKeys.count>0) {
        [str appendString:_S (@"\r\nrequest-header:{\r\n%@}",headerDictionary.description)];
    }
    if (fileDictionary.allKeys.count>0) {
        [str appendString:_S(@"\r\nrequest-file:{\r\n%@}",fileDictionary.description)];
    }
    [str appendFormat:@"\r\n*********************************************\r\n"];
    DDLogInfo(@"%@",str);
    
#endif
}

- (void)requestFinished:(ASIHTTPRequest *)nrequest
{
    __block ProtocolHelper *block_self=self;
    //防止模型层产生过多的对象，加入自动回收池
    @autoreleasepool {
        if (nrequest.responseStatusCode > 0) {
            if (StringIsNullOrEmpty(nrequest.responseString)) {
                DDLogInfo(@"\r\n%@: respone empty data",[[block_self class] description]);
				[self invokeHandleSusessOrFail:^{
					[self failWithParam:[ProtocolHelperError errorWithDomain:kProtocolHelperErrorDomain code:kProtocolHelperErrorCodeEmptyResponseCode userInfo:nil description:kProtocolHelperErrorCodeEmptyResponseDescription] RParam:block_self];
				}];
            }else if ([nrequest.responseString objectFromJSONString]==nil){
                DDLogInfo(@"\r\n%@: response not json object",[[block_self class]description]);
				[self invokeHandleSusessOrFail:^{
                    
                    //结果不为json对象
					[self failWithParam:[ProtocolHelperError errorWithDomain:kProtocolHelperErrorDomain code:kProtocolHelperErrorCodeResponseNotJsonStringCode userInfo:nil description:kProtocolHelperErrorCodeResponseNotJsonStringDescription] RParam:block_self];
				}];
            }else{
				//handleSusessParam可能会耗时，所以此处将其放到后台线程
				[self invokeHandleSusessOrFail:^{
                    
					BOOL susess=NO;
					
					id result=[self handleSusessParam:nrequest.responseString Susess:&susess];
					
					if (susess) {
						[block_self susessWithlParam:result RParam:block_self];
					}else{
						[block_self failWithParam:[self handleFailParam:nrequest.responseString] RParam:block_self];
					}
				}];
            }
        }else{
            [block_self failWithParam:[self handleFailParam:nrequest.responseString] RParam:block_self];
        }
    }
    if (self.autoRetainRelease) {
        [self release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)nrequest
{
    //如果是取消,不进行回调处理
    if (nrequest.error.code!=ASIRequestCancelledErrorType) {
        [self failWithParam:[self handleFailParam:nrequest.responseString] RParam:self];
    }
    if (self.autoRetainRelease) {
        [self release];
    }
}

-(BOOL)reachablityToInternet
{
    Reachability *reach=[Reachability reachabilityForInternetConnection];
    return [reach currentReachabilityStatus]!=kNotReachable;
}

///程序即将退出
-(void)applicationWillResignActive:(NSNotification*)note
{
	[self cancel];
	DDLogInfo(@"protocol %@ cancel for application resignactive",self);
}

-(void)applicationWillTerminate:(NSNotification*)note
{

//	self.finishBlock=nil;
//	self.failBlock=nil;
    [self setFailBlock:nil];
    [self setFinishBlock:nil];
    
    if ([self asiRequest]) {
        [[self asiRequest] clearDelegatesAndCancel];
    }
	DDLogInfo(@"protocol %@ cancel for application terminate",self);
}

/*
 取消此次请求
 */
-(void)cancel
{
    if (self.asiRequest&&asiRequest.isCancelled==NO) {
        [asiRequest cancel];
    }
}

/*
 返回用默认方法进行协议缓存的文件夹
 
 位于  <appdir>/Documents/protocol_cache/
 */
+(NSString*)protocolCacheDir
{
    NSString *dir=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"protocol_cache"];
    BOOL isDir=NO;
    if (([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]&&isDir)==NO) {//文件夹不存在，创建
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}
/*
 返回用默认方法进行协议缓存的文件名
 
 位于  <appdir>/Documents/protocol_cache/<协议名称>
 */
-(NSString*)protocolCacheFileName
{
    return [[ProtocolHelper protocolCacheDir] stringByAppendingPathComponent:_S(@"%s",object_getClassName(self))];
}
+(id)shareProtocol
{
    DDLogInfo(@"\r\nplease impletion +(id)shareProtocol method and then invoke this method");
    return nil;
}

+(id)protocol
{
    return [[[[self class] alloc] init] autorelease];
}

+(id)protocolAutoRelease
{
    id obj= [[[[self class] alloc] init] autorelease];
    [obj setAutoRetainRelease:YES];
    return obj;
}

+(ASINetworkQueue*)shareNetworkQueue
{
    static ASINetworkQueue *_shareNetworkQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareNetworkQueue=[[ASINetworkQueue alloc] init];
        _shareNetworkQueue.maxConcurrentOperationCount=4;
    });
    return _shareNetworkQueue;
}

#pragma mark - cache
//在NSKeyedArchiver 中缓存一个协议报文
//#define CacheProtocol(key)
- (void)cacheProtocol:(NSString *)dataStr withKey:(NSString *)key
{
    if(dataStr.length == 0)
        return;
    NSMutableData *data=[NSMutableData data];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dataStr forKey:key];
    [archiver finishEncoding];
    NSString *fileName=[self protocolCacheFileName];
    fileName = _S(@"%@-%@",fileName,key);
    [data writeToFile:fileName atomically:YES];
    [archiver release];
}
//从NSKeyedArchiver 中读取一个协议报文的key
- (NSString *)getProtocolCacheDataWithKey:(NSString *)key
{
    NSString *fileName=[self protocolCacheFileName];
    fileName = _S(@"%@-%@",fileName,key);
    NSData *data=[NSData dataWithContentsOfFile:fileName];
    if(!data)
        return @"";
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSString *str=[unarchiver decodeObjectForKey:key];
    [unarchiver release];
    return str;
}
@end

@interface ProtocolHelperError ()

@property (nonatomic,retain) NSString *_localizedDescription;

@end

@implementation ProtocolHelperError

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict description:(NSString *)description
{
	self=[super initWithDomain:domain code:code userInfo:dict];
	if (self) {
		self._localizedDescription=description;
	}
	return self;
}

- (void)dealloc
{
    self._localizedDescription=nil;
	[super dealloc];
}

+(id)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict description:(NSString *)description
{
	return [[[ProtocolHelperError alloc] initWithDomain:domain code:code userInfo:dict description:description] autorelease];
}

-(NSString*)localizedDescription
{
	return self._localizedDescription;
}
@end
