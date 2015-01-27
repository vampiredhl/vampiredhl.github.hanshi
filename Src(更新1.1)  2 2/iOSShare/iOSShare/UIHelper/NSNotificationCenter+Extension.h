//
//  NSNotificationCenter+Extension.h
//  iOSShare
//
//  Created by wujin on 13-11-13.
//  Copyright (c) 2013年 wujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Extension)
/**
 发送一个通知
 @param aName : 同postNotificationName:object:userInfo中的aName
 @param anObject : 同postNotificationName:object:userInfo中的anObject
 @param aUserInfo : 同postNotificationName:object:userInfo中的aUserInfo
 @param onMainThread : 是否在主线程上进行此操作，如果此值为YES，会在主线程上进行此发送操作
 */
-(void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo onMainThread:(BOOL)onMainThread;

/**
 发送一个通知
 @param aName : 同postNotificationName:object:userInfo中的aName
 @param anObject : 同postNotificationName:object:userInfo中的anObject
 @param onMainThread : 是否在主线程上进行此操作，如果此值为YES，会在主线程上进行此发送操作
 */
-(void)postNotificationName:(NSString *)aName object:(id)anObject onMainThread:(BOOL)onMainThread;
@end
