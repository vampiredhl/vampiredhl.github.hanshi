//
//  Config.h
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DECLARE_CONFIG_ITEM(name,type) \
+(type)get##name;\
\
+(void)set##name:(type)value;
@class User;
/**
 提供程序全局的配置相关
 */
@interface Config : NSObject
DECLARE_CONFIG_ITEM(Splash, NSArray*)

DECLARE_CONFIG_ITEM(LoginUser, User*)
@end
