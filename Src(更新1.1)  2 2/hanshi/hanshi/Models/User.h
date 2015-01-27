//
//  User.h
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

//#import <iOSShare/iOSShare.h>
#import <iOSShare/ModelList.h>

@interface User : ModelBase

@property (nonatomic,strong) NSString * returnvalue;
@property (nonatomic,strong) NSString * ntype;
@property (nonatomic,strong) NSString * xingming;
@property (nonatomic,strong) NSString * corpid;
@property (nonatomic,strong) NSString * corpname;
@property (nonatomic,strong) NSString * cpic;
@property (nonatomic,strong) NSString * upic;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * loginname;
@property (nonatomic,strong) NSString * scorpname;
@property (nonatomic,strong) NSString * email;
@end

@interface UserList : ModelList

@end

@interface Corp : ModelBase
@property (nonatomic,strong) NSString * corpname;
@property (nonatomic,strong) NSString * corpid;
@property (nonatomic,strong) NSString * cpic;
@property (nonatomic,strong) NSString * introduction;
@property (nonatomic,strong) NSString * scorpname;
@end

@interface CorpList : ModelList

@end

@interface Material : ModelBase
@property (nonatomic,strong) NSString * mtid;
@property (nonatomic,strong) NSString * mname;
@property (nonatomic,strong) NSString * mpic_small;
@property (nonatomic,strong) NSString * explain;
@property (nonatomic,strong) NSString * mpic;
@property (nonatomic,strong) NSString * mtname;
@end

@interface MaterialList : ModelList

@end

@interface HanBook : ModelBase
@property (nonatomic,strong) NSString * hbid;
@property (nonatomic,strong) NSString * hbname;
@property (nonatomic,strong) NSString * fbdate;
@property (nonatomic,strong) NSString * gxdate;
@property (nonatomic,strong) NSString * hbpic;
@end

@interface HanBookList : ModelList

@end

@interface HanBookOne : ModelBase
@property (nonatomic,strong) NSString * ctid;
@property (nonatomic,strong) NSString * cname;
@property (nonatomic,strong) NSString * cpic;
@end

@interface HanBookOneList : ModelList

@end