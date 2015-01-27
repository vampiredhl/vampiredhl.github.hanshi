//
//  CopSearch.h
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ProtocolBase.h"

@interface CorpSearch : ProtocolBase

@end

@interface CorpInfo : ProtocolBase
-(void)requestWithId:(NSString*)corpId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end
//http://localhost:1002/api/corp/corpmaterial/?corpid=1&pagesize=10&pageno=1

@interface CorpMaterial : ProtocolBase
-(void)requestWithId:(NSString*)corpId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;

@end

////http://localhost:1002/api/material/materialpic/?mtid=1

@interface MaterialPic :ProtocolBase
-(void)requestWithId:(NSString*)mtId SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;

@end

///http://localhost:1002/api/material/materialsearch/?corpid=1,2,3&scope=天花,墙面&mater=天花,墙面&pagesize=10&pageno=1

@interface MaterialSearch : ProtocolBase
-(void)requestWithCorpId:(NSArray*)corpid Scope:(NSArray*)scrop Mater:(NSArray*)mater SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end
//http://115.47.49.111:1002//api/material/nature/
@interface  MaterialNature: ProtocolBase

@end
//http://115.47.49.111:1002/api2/material/materialtype/
@interface MaterialType : ProtocolBase
-(void)requestWithFlag:(NSString*)flag SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface MaterialByType : ProtocolBase
-(void)requestWithMtid:(NSString*)mtid Hbid:(NSString*)hbid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface CorpCorpbyType : ProtocolBase
-(void)requestWithType:(NSString*)ntype SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface HanbookHbList : ProtocolBase
-(void)requestWithCorpId:(NSString*)coprid userName:(NSString*)userName SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface HanBookAll : ProtocolBase
-(void)requestWithId:(NSString*)hbid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface HandBookMaterial : ProtocolBase
-(void)requestWithCtid:(NSString*)ctid SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end

@interface Loglist : ProtocolBase
-(void)requestWithUserName:(NSString*)username SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;
@end