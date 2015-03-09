//
//  CorpDetailViewController.m
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "CorpDetailViewController.h"
#import "CorpListViewController.h"

@interface CorpDetailViewController (){
	
	__weak IBOutlet UIPageControl *pageControl;
	__weak IBOutlet UILabel *lbDesc2;
	__weak IBOutlet UIScrollView *scrollPop;
	IBOutlet UIView *viewPop;
	__weak IBOutlet UIScrollView *scroll;
	__weak IBOutlet UITextView *lbDesc;
	__weak IBOutlet UILabel *lbName;
	__weak IBOutlet UIImageView *imgHead;
	__weak IBOutlet UIView *viewPopContainer;
	__weak IBOutlet UIView *viewShadow;
}
@property (nonatomic,strong) Corp *corp;
@end

@implementation CorpDetailViewController

-(id)initWithCorp:(Corp *)corp
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.corp=corp;
	}
	return self;
}
-(instancetype)initNoHeaderWithCorp:(Corp *)corp
{
	self = [super initWithNibName:@"CorpDetailViewController2" bundle:[NSBundle mainBundle]];
	if (self) {
		self.corp=corp;
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self loadInfo];
	viewPopContainer.layer.masksToBounds=YES;
	viewPopContainer.layer.cornerRadius=4;
	viewShadow.layer.shadowOffset=CGSizeMake(1, 1);
	viewShadow.layer.shadowOpacity=0.5;
	viewShadow.layer.shadowColor=[UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	self.corp=nil;
}

-(void)loadInfo
{
	CorpInfo *info=[CorpInfo protocolAutoRelease];
	[info requestWithId:self.corp.corpid SusessBlock:^(id lParam, id rParam) {
		[self _loadHead:lParam];
	} FailBlock:^(id lParam, id rParam) {
		lbDesc.text=@"";
	}];
	CorpMaterial *m=[CorpMaterial protocolAutoRelease];
	[m requestWithId:self.corp.corpid SusessBlock:^(id lParam, id rParam) {
		[self _loadMaterial:lParam];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
-(void)_loadHead:(Corp*)c{
	[imgHead sd_setImageWithURL:URL(c.cpic)];
	lbName.text=c.corpname;
	lbDesc.text=c.introduction;
}
-(void)_loadMaterial:(MaterialList *)list
{
	scroll.contentInset=UIEdgeInsetsZero;
	CGSize elemenSize=CGSizeMake(scroll.width/3, 110);
	if (IS_IPAD()) {
		elemenSize.height=210;
	}
	//计算行数
	float rows=ceilf(list.count/3.0);
	scroll.contentSize=CGSizeMake(scroll.width, elemenSize.height*rows);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<3; j++) {
			int index=i*3+j;
			if (list.count<=index) {
				break;
			}
			Material *c=[list objectAtIndex:index];
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(elemenSize.width*j, elemenSize.height*i, elemenSize.width, elemenSize.height)];
			container.backgroundColor=[UIColor clearColor];
			if (IS_IPAD()) {
				container.originX=242*j+42;
				container.width=200;
                
                container.originY=242*i+42;
                
			}
			CGFloat w=IS_IPAD()?200:90;
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0, w, w)];
			[img sd_setBackgroundImageWithURL:URL(c.mpic_small) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			img.layer.masksToBounds=YES;
			img.layer.cornerRadius=4;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake((container.width-w)/2, 10, w, w)];
			imgc.backgroundColor=[UIColor clearColor];
			imgc.layer.shadowOffset=CGSizeMake(1, 1);
			imgc.layer.shadowOpacity=0.5;
			imgc.layer.shadowColor=[UIColor blackColor].CGColor;
			[imgc addSubview:img];

			[container addSubview:imgc];
			UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10, imgc.height+imgc.originY-20, container.width-20, 20)];
			lb.backgroundColor=[UIColor clearColor];
			lb.textColor=[UIColor blackColor];
			lb.textAlignment=NSTextAlignmentCenter;
			lb.font=[UIFont systemFontOfSize:12];
			lb.text=c.mname;
			lb.shadowColor=[UIColor whiteColor];
			lb.shadowOffset=CGSizeMake(-1, -1);
			[container addSubview:lb];
			[scroll addSubview:container];
		}
	}
}

-(IBAction)btnItemTap:(UIButton*)sender{
	Material *m=sender.associatedObjectRetain;
	MaterialPic *req=[MaterialPic protocolAutoRelease];
	[req requestWithId:m.mtid SusessBlock:^(id lParam, id rParam) {
		[self loadPop:lParam];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
-(void)loadPop:(NSArray*)images
{
	[viewPop removeFromSuperview];
	viewPop.frame=self.view.bounds;
	[self.view addSubview:viewPop];
	[scrollPop.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	scrollPop.contentInset=UIEdgeInsetsZero;
	scrollPop.contentSize=CGSizeMake(scrollPop.width*images.count, scrollPop.height);
	pageControl.numberOfPages=images.count;
	for (int i=0; i<images.count; i++) {
		Material *mat=images[i];
		CGFloat w=IS_IPAD()?460:230;
		UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*scrollPop.width, 0, w, w)];
		img.contentMode=UIViewContentModeScaleAspectFill;
		img.clipsToBounds=YES;
		[img sd_setImageWithURL:URL(mat.mpic) placeholderImage:IMG(@"wu.jpg")];
		
		UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(i*scrollPop.width, img.height+5, img.width, scrollPop.height-w-15)];
		lb.backgroundColor=[UIColor clearColor];
		lb.textColor = [UIColor blackColor];
		lb.text=mat.explain;
		lb.editable=NO;
		lb.dataDetectorTypes=UIDataDetectorTypePhoneNumber;
		lb.font=[UIFont systemFontOfSize:12];
		[scrollPop addSubview:lb];
		[scrollPop addSubview:img];
	}
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	pageControl.currentPage=ceil(scrollPop.contentOffset.x/scrollPop.width);
}
- (IBAction)btnPopTap:(id)sender {
	[viewPop removeFromSuperview];
}
- (IBAction)btnListTap:(id)sender {
	CorpListViewController *l=[[CorpListViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:l animated:YES];
}
@end
