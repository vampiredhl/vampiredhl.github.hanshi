//
//  UIImage+Extension.m
//  iTrends
//
//  Created by wujin on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extension.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"

@implementation UIImage (Extension)

+(UIImage*)resizableImageWithString:(NSString *)str
{
	NSString * imageScaleableName = str;
	NSArray *split=[imageScaleableName componentsSeparatedByString:@"-"];
	if (split.count<2) {
		NSLog(@"the imageScalebleName value [%@] fro instance [%p] is error,the example is  [imagename-{0,0,0,0}-{mode}]",imageScaleableName,self);
		return nil;
	}
	NSString *imgname=split[0];
	UIImage *img=IMG(imgname);
	if (img==nil) {
		NSLog(@"the ImageScalebleName splited image-can't find the image:[%@]",imgname);
		return nil;
	}
	UIEdgeInsets inset=UIEdgeInsetsFromString(split[1]);
	return [img resizableImageWithCapInsets:inset];
}

//调整大小后的图像
-(UIImage*)sizedImage:(CGSize)size
{
    return [UIImage scaleToSize:self size:size];
}
//旋转图片
+(UIImage *)rotateImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

-(UIImage *)rotatedImage
{
    return [UIImage rotateImage:self];
}
//指定图片大小
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
-(UIImage *)scaleToSize:(CGSize)size
{
    return [UIImage scaleToSize:self size:size];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIImage *img = nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end

#include <objc/runtime.h>
NSString * const kUIImageViewScaleableNameKey= @"kUIImageViewScaleableNameKey";
@implementation UIImageView(Extension)

-(NSString*)imageScaleableName
{
	return objc_getAssociatedObject(self, [kUIImageViewScaleableNameKey cStringUsingEncoding:NSUTF8StringEncoding]);
}
-(void)setImageScaleableName:(NSString *)imageScaleableName
{
	objc_setAssociatedObject(self, [kUIImageViewScaleableNameKey cStringUsingEncoding:NSUTF8StringEncoding], imageScaleableName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	UIImage * img=[UIImage resizableImageWithString:imageScaleableName];
	self.image=img;
}

@end

@implementation UIButton(Extension)

-(void)_setBackgroundImageWithString:(NSString*)str forState:(UIControlState)state
{
	[self setBackgroundImage:[UIImage resizableImageWithString:str] forState:state];
}
char * const kUIButtonBackgroundImageScaleableNameDisableKey="kUIButtonBackgroundImageScaleableNameDisableKey";
char * const kUIButtonBackgroundImageScaleableNameNormalKey="kUIButtonBackgroundImageScaleableNameNormalKey";
char * const kUIButtonBackgroundImageScaleableNameHighlightedKey="kUIButtonBackgroundImageScaleableNameHightedKey";
char * const kUIButtonBackgroundImageScaleableNameSelectedKey="kUIButtonBackgroundImageScaleableNameSelectedKey";
-(NSString*)disableBackgroundImageScaleableName
{
	return objc_getAssociatedObject(self, kUIButtonBackgroundImageScaleableNameDisableKey);
}
-(void)setDisableBackgroundImageScaleableName:(NSString *)backgroundImageScaleableName_Disable
{
	objc_setAssociatedObject(self, kUIButtonBackgroundImageScaleableNameDisableKey, backgroundImageScaleableName_Disable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self _setBackgroundImageWithString:backgroundImageScaleableName_Disable forState:UIControlStateDisabled];
}

-(NSString*)normalBackgroundImageScaleableName
{
	return objc_getAssociatedObject(self, kUIButtonBackgroundImageScaleableNameNormalKey);
}
-(void)setNormalBackgroundImageScaleableName:(NSString *)backgroundImageScaleableName_Normal
{
	objc_setAssociatedObject(self, kUIButtonBackgroundImageScaleableNameNormalKey, backgroundImageScaleableName_Normal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self _setBackgroundImageWithString:backgroundImageScaleableName_Normal forState:UIControlStateNormal];
}

-(NSString*)highlightedBackgroundImageScaleableName
{
	return objc_getAssociatedObject(self, kUIButtonBackgroundImageScaleableNameHighlightedKey);
}
-(void)setHighlightedBackgroundImageScaleableName:(NSString *)backgroundImageScaleableName_Normal
{
	objc_setAssociatedObject(self, kUIButtonBackgroundImageScaleableNameHighlightedKey, backgroundImageScaleableName_Normal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self _setBackgroundImageWithString:backgroundImageScaleableName_Normal forState:UIControlStateHighlighted];
}

-(NSString*)selectedBackgroundImageScaleableName
{
	return objc_getAssociatedObject(self, kUIButtonBackgroundImageScaleableNameSelectedKey);
}
-(void)setSelectedBackgroundImageScaleableName:(NSString *)backgroundImageScaleableName_Selected
{
	objc_setAssociatedObject(self, kUIButtonBackgroundImageScaleableNameSelectedKey, backgroundImageScaleableName_Selected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self _setBackgroundImageWithString:backgroundImageScaleableName_Selected forState:UIControlStateSelected];

}

@end

@implementation UIView(Cornor)

-(CGFloat)layerCornerRadius
{
	return self.layer.cornerRadius;
}
-(void)setLayerCornerRadius:(CGFloat)layerCornerRadius
{
	self.layer.masksToBounds=YES;
	self.layer.cornerRadius=layerCornerRadius;
}

@end