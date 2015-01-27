//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UILabel+Extension.h"
#import "UIColor+Extension.h"
#import "UIImage+Extension.h"
#import "UIFont+Extension.h"
#import "UIView+Extension.h"
#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

/**
 用于推出视图的导航
 */
-(IBAction)btBack_PopNav:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 用于消除模态视图的导航
 */
-(IBAction)btBack_DisModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
