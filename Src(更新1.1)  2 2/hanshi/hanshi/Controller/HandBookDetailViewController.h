//
//  HandBookDetailViewController.h
//  hanshi
//
//  Created by wujin on 14/12/27.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "BaseViewController.h"

@interface HandBookDetailViewController : BaseViewController
-(instancetype)initWithHandOneBookList:(HanBookOneList*)list hb:(HandBookMgr*)hb hbId:(NSString*)hbid;
@end
