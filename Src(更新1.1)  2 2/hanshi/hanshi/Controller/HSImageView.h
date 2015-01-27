//
//  HSImageView.h
//  hanshi
//
//  Created by wujin on 15/1/8.
//  Copyright (c) 2015年 dqjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSImageView : UIView

@property (nonatomic,strong) UIImage *image;
-(void)setImageWithString:(NSString*)imageUrl placeholderImage:(UIImage*)img;
@end
