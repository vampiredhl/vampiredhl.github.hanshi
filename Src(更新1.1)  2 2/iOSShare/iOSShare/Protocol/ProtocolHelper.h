//
//  ProtocolHelper.h
//  Cloud
//  协议请求的基类
//  每个协议请求类都应该继承此类后进行一些自己的添加请求数据和解析数据的操作
//  Created by wujin on 12-9-27.
//  Copyright (c) 2012年 wujin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extension.h"

@class ASINetworkQueue,Reachability;

//block块的两个参数
#define BlockParam Susess:(RequestBlock)susess Fail:(RequestBlock)fail

#define BlockParamWith (RequestBlock)susess Fail:(RequestBlock)fail

//改变url请求
#define AppendUrl(str) self.requestUrl=[kServerHosts stringByAppendingString:str]

//附加给url一个参数
#define AppendParam(key,value) self.requestUrl=[self.requestUrl stringByAppendingFormat:@"%@=%@",key,value];

//有此宏定义表示协议为调试状态，将打印报文
#define _Protocol_DEBUG

//实现一个单例的协议对象
#define IMP_SHAREINSTANCE static id shareInstance_p;\
                            +(id)shareProtocol\
                            {\
                                if(shareInstance_p==nil)\
                                {\
                                    shareInstance_p=[[[self class] alloc] init];\
                                }\
                                return shareInstance_p;\
                            }\
/**
 用于标识一次请求的一个块语句
 */
typedef void(^RequestBlock)(id lParam,id rParam);

/**
 错误的Domain
 */
UIKIT_EXTERN NSString * const kProtocolHelperErrorDomain;

/**
 空的返回值
 */
UIKIT_EXTERN int const kProtocolHelperErrorCodeEmptyResponseCode ;

/**
 返回结果不为JSON字符串
 */
UIKIT_EXTERN int const kProtocolHelperErrorCodeResponseNotJsonStringCode;

UIKIT_EXTERN int const kProtocolHelperErrorCodeNoConnectionCode;

/**
 取消了此次网络请求
 */
UIKIT_EXTERN int const kProtocolHelperErrorCodeUserCancel;

/**
 内部程序处理逻辑错误
 */
UIKIT_EXTERN int const kProtocolHelperErrorCodeInternalErrorCode;

@interface ProtocolHelper : NSObject{
    ASIFormDataRequest *asiRequest;
    
    NSMutableDictionary *postDictionary;///用于发送参数的dictionary;
    NSMutableDictionary *headerDictionary;///用于发送Header的dictionary;
    NSMutableDictionary *fileDictionary;///要发送的文件
	NSMutableDictionary *queryDictionary;///用于发送get参数的dictionary;

    id cacheLParam;///缓存的lParam  如果两个参数中有一个不为nil，将调用成功方法
    id cacheRParam;///缓存的rParam  如果两个参数中有一个不为nil，将调用成功方法   请在dataFromCache方法中给这两个参数赋值
    
    NSMutableString *str_response;
	
	NSMutableDictionary *internalErrorUserInfo;///如果返回错误的时候出现内部逻辑错误，此值用于放置用户数据
}
///用于请求的对象
@property (nonatomic,readonly) ASIFormDataRequest *asiRequest;

@property (nonatomic,retain) NSString *requestMethod;///请求方式

/**
 标记请求协议的url
 如果不设置此值，些值默认为kServerUrl常量所定义的值
 如果需要更改此值，请在init方法中调用[super init]后更改
 */
@property (nonatomic,retain) NSString *requestUrl;

/**
 标记超时时间
 如果此时间后服务器还没有返回
 将标识为调用失败
 */
@property (nonatomic,assign) int timeOut;

/**
 是否手动开始此请求
 默认为NO
 当此值设置为YES时，需要调用startRequest才会开始请求
 */
@property (nonatomic,assign) BOOL startManual;

/**
 是否为异步加载，默认为YES
 */
@property (nonatomic,assign) BOOL async;

/**
 是否从缓存加载数据，默认为YES
 */
@property (nonatomic,assign) BOOL useCache;

/**
 成功后调用的block
 此block会在调用成功或者失败后释放
 */
@property (nonatomic,copy) RequestBlock finishBlock;

/**
 失败后调用的block
 此block会在调用成功或者失败后释放
 */
@property (nonatomic,copy) RequestBlock failBlock;


/**
 服务器的返回状态码，一般情况下，200表示成功
 */
@property (nonatomic,assign) int resultCode;

/**
 此次请求过程中的额外参数
 此参数请求协议不会使用，仅用来标识一些需要在susess中进行处理的全局变量
 */
@property (nonatomic,retain) id ext_args;

/**
 设置此参数后会在RequestStart时retain自己，在requestDidFinish和requestDidFail的时候release自己
 默认为NO
 */
@property (nonatomic,assign) BOOL autoRetainRelease;

/**
 是否在后台静默处理调用handleSusess和handleFail方法
 默认为YES
 如果此属性为YES，handleSusess和handleFail会在dispatch_async队列中调用
 */
@property (nonatomic,assign) BOOL invokeHandleSusessAndFailOnDispatch;


/**
 使用此方法初始化的对象
 在block内请注意变量捕获
 block捕获的变量只有在协议释放的时候才会释放，所以请最好 使用__block方式去捕获变量
 */
-(id)init;

#pragma mark -
#pragma mark - request 
/**
 调用此方法后会开始请求
 如果需要对asiRequest做出额外的处理，请在此方法中进行
 */
-(void)startRequest;

/**
 请求即将开始
 此时asi尚未创建
 */
-(void)requestWillBegin;

/**
 请求即将开始
 此时asi已经创建
 */
-(void)requestWillStart;

/**
 请求已经开始
 此时asi已经创建
 */
-(void)requestDidStart;

#pragma mark -
#pragma mark - resolve

/**
 解析返回成功报文的参数
 请将解析完成后的数据传回
 */
-(id)handleSusessParam:(NSString*)str Susess:(BOOL*)result;


/**
 解析失败报文的参数
 请将解析完成后的数据传回
 */
-(id)handleFailParam:(NSString*)str;

#pragma mark -
#pragma mark -request


/**
 取消此次请求
 */
-(void)cancel;

/**
 从缓存读取数据
 子类应该重写此方法以用于从自己的缓存逻辑中读取数据
 */
-(void)dataFromCache;

/**
 开始请求报文
 */
-(void)requestWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock;

///调用处理方法
-(void)invokeHandleSusessOrFail:(dispatch_block_t)block;

///调用handleBlock
-(void)invokeRequestBlock:(dispatch_block_t)block;

/**
 调用成功处理逻辑
 */
-(void)susessWithlParam:(id)lParam RParam:(id)rParam;

/**
 调用失败处理逻辑
 */
-(void)failWithParam:(id)lParam RParam:(id)rParam;

///返回当前的网络连接状态
-(BOOL)reachablityToInternet;

/**
 返回用默认方法进行协议缓存的文件夹
 
 位于  <appdir>/Documents/protocol_cache/
 */
+(NSString*)protocolCacheDir;

/**
 返回用默认方法进行协议缓存的文件名
 
 位于  <appdir>/Documents/protocol_cache/<协议名称>
 */
-(NSString*)protocolCacheFileName;

/**
 一个单例的协议对象
 */
+(id)shareProtocol;

/**
 返回一个工厂类创建的协议对象
 */
+(id)protocol;

/**
 返回一个工厂类创建的协议对象，
 但是此对象会自动retain和Relase(在协议请求开始的结束时）
 使用此方法初始化的对象可在对象的block内随意捕获变量
 */
+(id)protocolAutoRelease;

/**
 使用默认方法缓存一个协议
 实现方法为将所有的dataStr中的内容存进一个文件中
 @param dataStr : 从服务器返回的报文
 @param key : 用来保存的附加key
 */
- (void)cacheProtocol:(NSString *)dataStr withKey:(NSString *)key;
/**
 使用默认方法从缓存中读取一个协议的缓存 
 @param key : 保存的附加key
 */
- (NSString *)getProtocolCacheDataWithKey:(NSString *)key;
@end


@interface ProtocolHelperError : NSError

-(id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict description:(NSString*)description;

+(id)errorWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict description:(NSString*)description;

@end