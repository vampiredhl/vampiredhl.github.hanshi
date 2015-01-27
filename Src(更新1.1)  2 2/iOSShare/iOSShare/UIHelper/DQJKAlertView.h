//
//  DQJKAlertView.h
//  travel
//
//  Created by wujin on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//使用标题和消息显示一个AlertView
#define AlertShowWithTitleAndMessage(title,msg) [DQJKAlertView AlertShow:title message:msg]
//使用指定消息显示一个AlertView
#define AlertShowWithMessage(msg) [DQJKAlertView AlertShow:msg]

#define kMessageOkButtonTitle @"确认"

typedef     void (^ClickButtonAtIndex)(UIAlertView* alert,NSInteger index);

@interface DQJKAlertView : UIAlertView<UIAlertViewDelegate>
{
    __block NSInteger index;
}

@property (nonatomic,copy) ClickButtonAtIndex clickButtonAtIndex;
//使用块语句初始化一个alertView
-(id)initWithTitle:(NSString *)title message:(NSString *)message DelegateBlock:(void(^)(UIAlertView *alert,NSInteger index))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

+(void)AlertShow:(NSString*)title message:(NSString *)message DelegateBlock:(void(^)(UIAlertView *alert,NSInteger index))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

+(void)AlertShow:(NSString*)message;

+(void)AlertShow:(NSString*)title message:(NSString*)message;

+(void)AlertShow:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle;

+(void)AlertShow:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle;

@end
