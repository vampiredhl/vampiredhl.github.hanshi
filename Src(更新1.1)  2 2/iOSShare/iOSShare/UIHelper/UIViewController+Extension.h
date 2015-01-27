//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//


@interface UIViewController (Extension)

/**
 用于推出视图的导航
 */
-(IBAction)btBack_PopNav:(id)sender;
/**
 用于消除模态视图的导航
 */
-(IBAction)btBack_DisModal:(id)sender;

@end