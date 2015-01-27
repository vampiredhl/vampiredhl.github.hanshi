//
//  HomeViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "HomeViewController.h"
#import "ImageViewController.h"
#import "JASidePanelController.h"
#import "UserInfoViewController.h"
#import "CorpViewController.h"
#import "RegistViewController.h"
#import "HanBookViewController.h"

@interface HomeViewController ()<UIScrollViewDelegate>{
	
	__weak IBOutlet UIView *viewManul;
	__weak IBOutlet UIScrollView *scrollImages;
	__weak IBOutlet UIButton *btnUserInfo;
	__weak IBOutlet UIPageControl *pageControl;
}

@end

@implementation HomeViewController

+(UIViewController*)homeController
{
	JASidePanelController *j=[[JASidePanelController alloc] init];
	j.centerPanel=[[HomeViewController alloc] initWithNibName:nil bundle:nil];
	j.centerPanel.associatedObject=j;
	if(IS_IPAD()){
		j.rightFixedWidth=255;
	}
	if ([Config getLoginUser]!=nil) {
        UserInfoViewController *userinfor =[[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
        userinfor.j = j;
		j.rightPanel=userinfor;
	}
	return j;
}
- (void)dealloc
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self loadImages];
	viewManul.hidden=[Config getLoginUser]==nil;
	[btnUserInfo setTitle:viewManul.hidden?@"注册":@"个人信息" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadImages
{
	SysPublishpic *p=[SysPublishpic protocolAutoRelease];
	[p requestWithPage:@"1" SusessBlock:^(NSDictionary* lParam, id rParam) {
		[self _loadImages:lParam[@"list"]];
	} FailBlock:^(id lParam, id rParam) {
//		self.edgesForExtendedLayout
	}];
}
-(void)_loadImages:(NSArray*)images
{
	scrollImages.contentInset=UIEdgeInsetsZero;
	scrollImages.contentSize=CGSizeMake(scrollImages.width*images.count, scrollImages.height);
	pageControl.numberOfPages=images.count;
	for (int i=0; i<images.count; i++) {
		HSImageView *img=[[HSImageView alloc] initWithFrame:CGRectMake(i*scrollImages.width, 0, scrollImages.width, scrollImages.height)];
		img.contentMode=UIViewContentModeScaleAspectFill;
		img.clipsToBounds=YES;
		[img setImageWithString:images[i] placeholderImage:IMG(@"wu.jpg")];
		[scrollImages addSubview:img];
	}
	[self performSelector:@selector(autoScroll) withObject:nil afterDelay:3];
}
-(void)autoScroll
{
	NSInteger next=(pageControl.currentPage+1);
	if (next>=pageControl.numberOfPages) {
		next=0;
	}
	[scrollImages setContentOffset:CGPointMake(scrollImages.width*next, 0) animated:YES];
	[self performSelector:@selector(autoScroll) withObject:nil afterDelay:3];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	pageControl.currentPage=ceil(scrollImages.contentOffset.x/scrollImages.width);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnGysTap:(id)sender {
	CorpViewController *c=[[CorpViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:c animated:YES];
}
- (IBAction)btnHssdTap:(id)sender {
	SysPreview *s=[SysPreview protocolAutoRelease];
	[s requestWithSusessBlock:^(NSDictionary* lParam, id rParam) {
		NSArray *array=lParam[@"list"];
		ImageViewController *i=[[ImageViewController alloc] initWithImages:array];
		[self presentViewController:i animated:YES completion:NULL];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
- (IBAction)btnHsjjTap:(id)sender {
	SysIntroduction *s=[SysIntroduction protocolAutoRelease];
	[s requestWithSusessBlock:^(NSDictionary* lParam, id rParam) {
		NSArray *array=lParam[@"list"];
		ImageViewController *i=[[ImageViewController alloc] initWithImages:array];
		[self presentViewController:i animated:YES completion:NULL];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
- (IBAction)btnBzscTap:(id)sender {
	HanBookViewController * h =[[HanBookViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:h animated:YES];
}
- (IBAction)btnUserInfoTap:(UIButton*)sender {
    
    
	if([sender.currentTitle isEqualToString:@"个人信息"]){
	JASidePanelController *j=self.associatedObject;
	[j showRightPanelAnimated:YES];
	}else{
		RegistViewController *reg=[[RegistViewController alloc] initWithNibName:nil bundle:nil];
		[self.navigationController pushViewController:reg animated:YES];
	}
}
- (IBAction)btnVersionTap:(id)sender {
	[[SysCheckUpdate protocolAutoRelease] requestWithSusessBlock:^(id lParam, id rParam) {
		AlertShowWithTitleAndMessage(@"版本信息", lParam);
	} FailBlock:NULL];
	
}

@end
