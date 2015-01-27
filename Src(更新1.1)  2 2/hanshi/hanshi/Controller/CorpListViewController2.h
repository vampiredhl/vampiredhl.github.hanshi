//
//  CorpListViewController.h
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "BaseViewController.h"

@interface CorpListViewController2 : BaseViewController
/**
 等于all表示获取所有适用范围
 否则获取除了家具以外的所有适用范围
 */
-(instancetype)initWithFlag:(NSString*)flag HbId:(NSString*)hbid;
@end
