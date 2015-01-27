//
//  UserSendYzm.h
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ProtocolBase.h"

@interface UserSendYzm : ProtocolBase

@end


@interface UserLogin : ProtocolBase
-(void)requestWithUserName:(NSString*)userName Pwd:(NSString*)pwd SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface UserInfo : ProtocolBase
-(void)requestWithUserName:(NSString*)userName SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface UserUploaduserpic : ProtocolBase
-(void)requestWithUserId:(NSString*)userId pic:(NSString*)picPath SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end
//http://localhost:1002/api/user/regist/?uname=四道风&upass=111111&xingming=张三&post=zhiwu&email=11@qq.com&mobile=13344444444&ntype=1&corpid=5
@interface UserRegist : ProtocolBase
-(void)requestWithName:(NSString*)uname Pwd:(NSString*)upass XingMing:(NSString*)xingming Post:(NSString*)post Email:(NSString*)email Mobile:(NSString*)mobile Type:(NSString*)ntype CorpId:(NSString*)corpid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface UserCheckUName : ProtocolBase
-(void)requestWithName:(NSString*)name SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface UserInfoupd : ProtocolBase
-(void)requestWithName:(NSString*)uname Mobile:(NSString*)mobile SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
-(void)requestWithName:(NSString *)uname Email:(NSString *)email SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;

@end