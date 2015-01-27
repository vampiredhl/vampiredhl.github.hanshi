//
//  UILabel+CreatLable.h
//  sinonetwork
//
//  Created by sinonetwork mac on 14-7-30.
//  Copyright (c) 2014年 sinonetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CreatLable)
+(UILabel *)creatLabelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font andTextColor:(UIColor *)textColor bgColor:(UIColor *)bgColor;
@end
