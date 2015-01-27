//
//  UILabel+Extension.h
//  iTrends
//
//  Created by wujin on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/**
 将此文本标签垂直居中
 注意：此方法只有在设置 text属性后再调用才生效
 */
-(void)verticalAlignmentCerter;

/**
 将此文本标签垂直居上
 注意：此方法只有在设置 text属性后再调用才生效
 */
-(void)verticalAlignmentTop;

/**
 将此文本标签垂直居下
 注意：此方法只有在设置 text属性后再调用才生效
 */
-(void)verticalAlignmentBottom;
@end
