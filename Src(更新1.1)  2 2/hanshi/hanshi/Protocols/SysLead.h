//
//  SysLead.h
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ProtocolBase.h"

@interface SysLead : ProtocolBase
@end

@interface SysPublishpic : ProtocolBase
-(void)requestWithPage:(NSString*)page SusessBlock:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock;

@end

@interface SysIntroduction : ProtocolBase

@end

@interface SysPreview : ProtocolBase

@end

@interface SysCheckUpdate : ProtocolBase

@end