//
//  CorpDetailViewController.h
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorpDetailViewController : UIViewController
-(instancetype)initWithCorp:(Corp *)corp;
-(instancetype)initNoHeaderWithCorp:(Corp *)corp;
@end
