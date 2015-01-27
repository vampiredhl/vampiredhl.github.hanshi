//
//  UIImage+Extension.h
//  iTrends
//
//  Created by wujin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//取得指定名称的图片
#define IMG(name) [UIImage imageNamed:name]

//返回可以变形的图片
#define IMG_ST(name,x,y) [IMG(name) stretchableImageWithLeftCapWidth:x topCapHeight:y]


@interface UIImage (Extension)

/**
 格式为  imageName-{top, left, bottom, right}-{mode}
 最后一个mode参数可选
 */
+(UIImage*)resizableImageWithString:(NSString*)str;

//调整大小后的图像
-(UIImage*)sizedImage:(CGSize)size;
//旋转图片
+(UIImage *)rotateImage:(UIImage *)aImage;
//获取旋转后的图片
-(UIImage *)rotatedImage;

//指定图片的大小
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

-(UIImage *)scaleToSize:(CGSize)size;

/**
 *  按颜色和尺寸生成图片
 *
 *  @param color 颜色
 *  @param size  尺寸
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end

IB_DESIGNABLE
@interface UIImageView (Extension)

/**
 可以在xib中设置可变形图片的名称与变形参数
 格式为  imageName-{top, left, bottom, right}-{mode}
 最后一个mode参数可选
 */
@property (nonatomic,retain) IBInspectable NSString * imageScaleableName;

@end

IB_DESIGNABLE
@interface UIButton (Extension)

/**
 可以从xib设置的可变形图片--state normal
 */
@property (nonatomic,retain) IBInspectable NSString * normalBackgroundImageScaleableName;
/**
 可以从xib设置的可变形图片--state highlighted
 */
@property (nonatomic,retain) IBInspectable NSString * highlightedBackgroundImageScaleableName;
/**
 可以从xib设置的可变形图片--state Selected
 */
@property (nonatomic,retain) IBInspectable NSString * selectedBackgroundImageScaleableName;
/**
 可以从xib设置的可变形图片--state Disable
 */
@property (nonatomic,retain) IBInspectable NSString * disableBackgroundImageScaleableName;
@end

@interface UIView (Cornor)
@property (nonatomic,assign) IBInspectable CGFloat layerCornerRadius;
@end