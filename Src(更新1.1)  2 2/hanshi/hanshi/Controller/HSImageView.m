//
//  HSImageView.m
//  hanshi
//
//  Created by wujin on 15/1/8.
//  Copyright (c) 2015年 dqjk. All rights reserved.
//

#import "HSImageView.h"
#import "PZPhotoView.h"

@interface HSImageView(){
	UIImage *_image;
}

@end

@implementation HSImageView
- (instancetype)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}
-(void)setup
{
	self.backgroundColor=[UIColor whiteColor];
}

- (void)dealloc
{
	self.image=nil;
}
-(UIImage*)image
{
	return _image;
}
-(void)setImage:(UIImage *)image
{
	_image=image;
	[self setNeedsDisplay];
}
-(void)setImageWithString:(NSString *)imageUrl placeholderImage:(UIImage *)img
{
	if (StringIsNullOrEmpty(imageUrl)) {
		return;
	}
	if ([imageUrl hasPrefix:@"http://"]) {
		self.image=img;
		[[SDWebImageManager sharedManager] downloadImageWithURL:URL(imageUrl) options:0 progress:NULL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
			self.image=image;
		}];
	}else{
		if ([[NSFileManager defaultManager] fileExistsAtPath:imageUrl]==NO) {
			imageUrl=[[NSBundle mainBundle] pathForResource:imageUrl ofType:@"png"];
//			if (imageUrl==nil) {
//    imageUrl=[[NSBundle mainBundle] pathForResource:image ofType:<#(NSString *)#>]
//			}
		}
		self.image=[UIImage imageWithContentsOfFile:imageUrl];
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    for (UIView *d in self.subviews)
        
    {
        
        [d removeFromSuperview];
        
    }
    
    CGSize imgsize=self.image.size;
    
    float h = imgsize.height;
    
    float w = imgsize.width;
    
    float h_w = h/(float)(w?w:1);
    
    //    h_w = 1920/1080.0;
    
    UIImageView *temp = nil;
    
    if ([self.superview isKindOfClass:[PZPhotoView class]])
        
    {
        
        PZPhotoView *pz = (PZPhotoView *)self.superview;
        
        if ([pz.photoViewDelegate respondsToSelector:@selector(btnJjTap:)])
            
        {
            if(IS_IPAD())
            {
                temp = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - self.height/(float)(h_w?h_w:1))/2, 0, rect.size.height/(float)(h_w?h_w:1), rect.size.height)];
            }
            else
            {
                temp = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.height-self.width*h_w)/2, rect.size.width, rect.size.width*h_w)];
            }
        }else
            
        {
            
            temp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.width*h_w)];
            
        }
        
    }else
        
        temp = [[UIImageView alloc]initWithFrame:self.bounds];
    
    
    
    temp.image = self.image;
    
    [self addSubview:temp];
    
    //	//CGImageRef img=self.image.CGImage;
    
    //	CGSize framesize=self.size;
    
    //	if (self.image==nil) {
    
    //	return;
    
    //	}
    
    //	CGFloat scalex=framesize.width/imgsize.width;
    
    //	CGFloat drawheight=scalex*imgsize.height;
    
    //	[self.image drawInRect:CGRectMake(0, (framesize.height-drawheight)/2, framesize.width, drawheight)];
    
    
    
    
    
    
    
}
@end
