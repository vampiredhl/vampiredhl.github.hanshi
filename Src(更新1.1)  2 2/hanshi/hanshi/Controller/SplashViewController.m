//
//  SplashViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "SplashViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WelcomeViewController.h"
//UIButton+WebCache"
//#import "UIImageView+WebCache"

@interface SplashViewController ()<UIScrollViewDelegate>{
	
	__weak IBOutlet UIPageControl *pageImages;
	__weak IBOutlet UIScrollView *scrollImages;
}

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//	[self loadImages];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self loadImages];
}
-(void)loadImages
{
	//加载图片
	NSArray *images=[Config getSplash];
	scrollImages.contentInset=UIEdgeInsetsZero;
	scrollImages.contentSize=CGSizeMake(scrollImages.width*images.count, scrollImages.height);
	scrollImages.pagingEnabled=YES;
	[scrollImages.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	pageImages.numberOfPages=images.count;
	for (int i=0; i<images.count; i++) {
		HSImageView *img=[[HSImageView alloc] initWithFrame:CGRectMake(scrollImages.width*i, 0, scrollImages.width, scrollImages.height)];
		NSString * name=images[i];
		[img setImageWithString:name placeholderImage:nil];
		[scrollImages addSubview:img];
	}
	[self.view sendSubviewToBack:scrollImages];
	if(images.count==1){
		[self performSelector:@selector(btnSkipTap:) withObject:nil afterDelay:2];
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	pageImages.currentPage=ceil(scrollImages.contentOffset.x/scrollImages.width);
}

- (IBAction)btnSkipTap:(UIButton *)sender
{
	UINavigationController *nav=self.navigationController;
	WelcomeViewController *l=[[WelcomeViewController alloc] initWithNibName:nil bundle:nil];
	[nav pushViewController:l animated:YES];
}

@end
