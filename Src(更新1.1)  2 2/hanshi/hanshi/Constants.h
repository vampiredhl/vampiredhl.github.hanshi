//
//  Constants.h
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#ifndef hanshi_Constants_h
#define hanshi_Constants_h

/**
 服务器的地址
 */
static NSString * const kServerHosts = @"http://115.47.49.111:8082/api/";

/**
 判断设备是否为iPad
 */
UIKIT_STATIC_INLINE BOOL IS_IPAD(){return UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad;}
#endif

#define IOS7 [[UIDevice currentDevice] systemVersion].floatValue>=7


#define kApplicationWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kApplicationHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kDScreenWidth         ([UIScreen mainScreen].bounds).size.width //屏幕的宽度
#define kDScreenHeight        ([UIScreen mainScreen].bounds).size.height //屏幕的高度

#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define SysFont(f) [UIFont systemFontOfSize:f]
#define BoldFont(f) [UIFont boldSystemFontOfSize:f]