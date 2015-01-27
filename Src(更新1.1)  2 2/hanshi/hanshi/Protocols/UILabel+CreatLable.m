//
//  UILabel+CreatLable.m
//  sinonetwork
//
//  Created by sinonetwork mac on 14-7-30.
//  Copyright (c) 2014年 sinonetwork. All rights reserved.
//

#import "UILabel+CreatLable.h"

@implementation UILabel (CreatLable)
+ (UILabel *)creatLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font andTextColor:(UIColor *)textColor bgColor:(UIColor *)bgColor;
{
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.text=title;
    label.font=font;
    label.textColor=textColor;
    label.backgroundColor=bgColor;
    
    return label;
    
}
@end
