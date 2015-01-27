//
//  iOSShare.h
//  iOSShare

//  需要额外引用的系统框架

//  libcurses.dylib
//  libz.dylib
//  CoreImage.framework
//  MobileCoreServices.framework
//  SystemConfiguration.framework
//  QuartzCore.framework
//  libsqlite3.dylib
//  CFNetwork.framework

//	在build setting中的 header search path 中添加 "$(OBJROOT)/UninstalledProducts/include" 中路径
//	在build setting中的 linked libary with binary 中添加  iOSShare 工程

//  Created by wujin on 13-4-3.
//  Copyright (c) 2013年 wujin. All rights reserved.
//

#import "Extension.h"
#import "ModelBase.h"
#import "ProtocolHelper.h"
/**
 标识DDLog的日志级别
 如果要使用自已的标识，请注释此变量
 */
static int const ddLogLevel = 1111;

/**
 事件处理签名
 @param sender:事件的产生者
 */
typedef void(^EventHandler)(id sender);

/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithOneArg(block,arg)  if(block){block(arg);}
/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithTwoArg(block,arg1,arg2) if(block){block(arg1,arg2);}
/**
 调用一个block,会判断block不为空
 */
#define BlockCallWithThreeArg(block,arg1,arg2,arg3) if(block){block(arg1,arg2,arg3);}