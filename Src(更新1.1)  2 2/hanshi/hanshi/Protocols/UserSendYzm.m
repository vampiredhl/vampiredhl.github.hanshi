//
//  UserSendYzm.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "UserSendYzm.h"

@implementation UserSendYzm

@end
@implementation UserLogin

-(void)requestWithUserName:(NSString *)userName Pwd:(NSString *)pwd SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"user/login/");
	[queryDictionary setObject:userName forKey:@"uname"];
	[queryDictionary setObject:pwd forKey:@"upass"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	
	return [[User alloc] initWithDictionary:dic];
}

@end

@implementation UserUploaduserpic

-(void)requestWithUserId:(NSString *)userId pic:(NSString *)picPath SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"user/uploaduserpic/");
	self.requestMethod=@"POST";
	[queryDictionary setObject:userId forKey:@"uname"];
	[fileDictionary setObject:picPath forKey:@"file"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	return [dic objectForKey:@"returnvalue"];
}
@end

@implementation UserRegist
//http://localhost:1002/api/user/regist/?uname=四道风&upass=111111&xingming=张三&post=zhiwu&email=11@qq.com&mobile=13344444444&ntype=1&corpid=5

-(void)requestWithName:(NSString *)uname Pwd:(NSString *)upass XingMing:(NSString *)xingming Post:(NSString *)post Email:(NSString *)email Mobile:(NSString *)mobile Type:(NSString *)ntype CorpId:(NSString *)corpid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"user/regist/");
	[queryDictionary setObject:uname forKey:@"uname"];
	[queryDictionary setObject:upass forKey:@"upass"];
	[queryDictionary setObject:xingming forKey:@"xingming"];
	[queryDictionary setObject:post forKey:@"post"];
	[queryDictionary setObject:email forKey:@"email"];
	[queryDictionary setObject:mobile forKey:@"mobile"];
	[queryDictionary setObject:corpid forKey:@"corpid"];
	[queryDictionary setObject:ntype forKey:@"ntype"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	
	return [dic objectForKey:@"returnvalue"];
}
@end

@implementation UserCheckUName

-(void)requestWithName:(NSString *)name SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	//http://localhost:1002/api/user/checkuname/?uname
	
	AppendUrl(@"user/checkuname/");
	[queryDictionary setObject:name forKey:@"uname"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	return  [dic objectForKey:@"returnvalue"];
}
@end

@implementation UserInfo

-(void)requestWithUserName:(NSString *)userName SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"user/userinfo/");
	[queryDictionary setObject:userName forKey:@"uname"];
	
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	
	return [[User alloc] initWithDictionary:dic];
}
@end

@implementation UserInfoupd

-(void)requestWithName:(NSString *)uname Mobile:(NSString *)mobile SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
	AppendUrl(@"user/userinfoupd/");
	[queryDictionary setObject:uname forKey:@"uname"];
	[queryDictionary setObject:mobile forKey:@"mobile"];
	[super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}
-(void)requestWithName:(NSString *)uname Email:(NSString *)email SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock
{
    AppendUrl(@"user/userinfoupd/");
    [queryDictionary setObject:uname forKey:@"uname"];
    [queryDictionary setObject:email forKey:@"email"];
    [super requestWithSusessBlock:susessBlock FailBlock:failBlock];
}

-(id)handleSusessParam:(NSString *)str Susess:(BOOL *)result
{
	NSDictionary *dic=[super handleSusessParam:str Susess:result];
	return [dic objectForKey:@"returnvalue"];
}
@end