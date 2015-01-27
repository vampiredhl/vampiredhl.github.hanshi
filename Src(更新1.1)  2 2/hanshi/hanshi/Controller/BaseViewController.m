//
//  BaseViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (StringIsNullOrEmpty(nibNameOrNil)) {
		nibNameOrNil=NSStringFromClass([self class]);
	}
	if (nibBundleOrNil==nil) {
		nibBundleOrNil=[NSBundle mainBundle];
	}
	return  [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
-(void)viewDidLoad
{
	[super viewDidLoad];
	self.edgesForExtendedLayout=UIRectEdgeNone;
}
- (void)dealloc
{
	DDLogInfo(@"%@ dealloc susess",self);
}
@end
