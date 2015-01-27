//
//  CorpViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "CorpViewController.h"
#import "CorpDetailViewController.h"
#import "CorpListViewController.h"

@interface CorpViewController (){
	__weak IBOutlet UIScrollView *scrollImages;
	__weak IBOutlet UIPageControl *pageControl;

	__weak IBOutlet UIScrollView *scrollItems;
}

@property (nonatomic,strong) CorpList *list;



@end

@implementation CorpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self loadImages];
	
//	UIButton *v=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//	v.layer.shadowOffset=CGSizeMake(3, 3);
//	v.layer.shadowColor=[UIColor blackColor].CGColor;
//	v.layer.shadowOpacity=0.5;
//	[v setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
//	v.backgroundColor=[UIColor redColor];
//	[self.view addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	self.list=nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];

}
-(void)loadImages
{
	SysPublishpic *p=[SysPublishpic protocolAutoRelease];
	[p requestWithPage:@"2" SusessBlock:^(NSDictionary* lParam, id rParam) {
		[self _loadImages:lParam[@"list"]];
	} FailBlock:^(id lParam, id rParam) {
		//		self.edgesForExtendedLayout
	}];
	CorpSearch *s=[CorpSearch protocolAutoRelease];
	[s requestWithSusessBlock:^(id lParam, id rParam) {
		[self _loadItems:lParam];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
-(void)_loadImages:(NSArray*)images
{
	scrollImages.contentSize=CGSizeMake(scrollImages.width*images.count, scrollImages.height);
	pageControl.numberOfPages=images.count;
	for (int i=0; i<images.count; i++) {
		UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*scrollImages.width, 0, scrollImages.width, scrollImages.height)];
		img.contentMode=UIViewContentModeScaleAspectFill;
		img.clipsToBounds=YES;
		[img sd_setImageWithURL:URL(images[i]) placeholderImage:IMG(@"wu.jpg")];
		[scrollImages addSubview:img];
	}
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
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



-(void)_loadItems:(CorpList*)list
{
	self.list=list;
	scrollItems.contentInset=UIEdgeInsetsZero;
	CGFloat h=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?250:130;
	CGSize elemenSize=CGSizeMake(scrollItems.width/3, h);
	//计算行数
	NSUInteger rows=ceilf(list.count/3.0);
	scrollItems.contentSize=CGSizeMake(scrollItems.width, elemenSize.height*rows);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<3; j++) {
			int index=i*3+j;
			if (list.count<=index) {
				break;
			}
			Corp *c=[list objectAtIndex:index];
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(elemenSize.width*j, elemenSize.height*i, elemenSize.width, elemenSize.height)];
			if (IS_IPAD()) {
				container.originX=242*j+42;
				container.width=200;
			}
			container.clipsToBounds=NO;
			container.backgroundColor=[UIColor clearColor];
			CGFloat s=UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?200:90;
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0, s, s)];
			[img sd_setBackgroundImageWithURL:URL(c.cpic) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			img.layer.cornerRadius=4;
			img.layer.masksToBounds=YES;
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake((container.width-s)/2, 10, s, s)];
			imgc.backgroundColor=[UIColor clearColor];
			imgc.layer.shadowOffset=CGSizeMake(1, 1);
			imgc.layer.shadowOpacity=0.5;
			imgc.layer.shadowColor=[UIColor blackColor].CGColor;
			[imgc addSubview:img];
			[container addSubview:imgc];
			UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, imgc.height+imgc.originY+(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad?10:4), container.width, 20)];
			lb.backgroundColor=[UIColor clearColor];
			lb.textColor=[UIColor blackColor];
			lb.textAlignment=NSTextAlignmentCenter;
			lb.font=[UIFont systemFontOfSize:14];
			lb.text=c.scorpname;
			[container addSubview:lb];
			[scrollItems addSubview:container];
		}
	}
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
-(IBAction)btnItemTap:(UIButton*)sender
{
	Corp *c=sender.associatedObjectRetain;
	CorpDetailViewController *d=[[CorpDetailViewController alloc] initWithCorp:c];
	[self.navigationController pushViewController:d animated:YES];
}
- (IBAction)btnListTap:(id)sender {
	CorpListViewController *l=[[CorpListViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:l animated:YES];
}

@end
