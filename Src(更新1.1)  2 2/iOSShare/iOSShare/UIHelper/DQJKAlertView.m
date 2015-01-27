//
//  DQJKAlertView.m
//  travel
//
//  Created by wujin on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DQJKAlertView.h"

@implementation DQJKAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)dealloc
{
    self.clickButtonAtIndex=nil;
    
    [super dealloc];
}
//使用块语句初始化一个AlertView
-(id)initWithTitle:(NSString *)title message:(NSString *)message DelegateBlock:(void (^)(UIAlertView *alert,NSInteger index))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    
    self.clickButtonAtIndex=block;
    if (otherButtonTitles!=nil&&![otherButtonTitles isEqualToString:@""]) {
        return [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    }else {
        return [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    }
}
+(void)AlertShow:(NSString*)title message:(NSString *)message DelegateBlock:(void(^)(UIAlertView *alert,NSInteger index))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
//    [[UIApplication sharedApplication] keyWindow].windowLevel=UIWindowLevelStatusBar;
    DQJKAlertView *alert=[[DQJKAlertView alloc] initWithTitle:title message:message DelegateBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [alert show];
    [alert release];
}

+(void)AlertShow:(NSString*)message
{
    [DQJKAlertView AlertShow:nil message:message DelegateBlock:^(UIAlertView *alert,NSInteger index){
        
    }cancelButtonTitle:kMessageOkButtonTitle otherButtonTitles:nil];
}

+(void)AlertShow:(NSString*)title message:(NSString*)message
{
    [DQJKAlertView AlertShow:title
                     message:message 
               DelegateBlock:^(UIAlertView *alert,NSInteger index){
        
    }
           cancelButtonTitle:kMessageOkButtonTitle 
           otherButtonTitles:nil];
}

+(void)AlertShow:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle
{
    [DQJKAlertView AlertShow:title message:message DelegateBlock:^(UIAlertView *alert,NSInteger index){
        
    }cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
}
+(void)AlertShow:(NSString *)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle
{
    [DQJKAlertView AlertShow:title
                     message:message 
               DelegateBlock:^(UIAlertView *alert,NSInteger index){
                   
               }
           cancelButtonTitle:cancelButtonTitle 
           otherButtonTitles:otherButtonTitle];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    index=buttonIndex;
    if (self.clickButtonAtIndex) {
        self.clickButtonAtIndex(self,index);
        self.clickButtonAtIndex=nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
