//
//  HandBookDetailViewController.m
//  hanshi
//
//  Created by wujin on 14/12/27.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "HandBookDetailViewController.h"
#import "PZPagingScrollView.h"
#import "PZPhotoView.h"
#import "CorpListViewController2.h"

@interface HandBookDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PZPagingScrollViewDelegate,PZPhotoViewDelegate>{
	HanBookOneList *_list;
	__weak IBOutlet UIButton *btnCl2;
	__weak IBOutlet UIScrollView *scrollPop;
	__weak IBOutlet UIButton *btnShow;
	__weak IBOutlet UIView *viewContainer;
	__weak IBOutlet UIPageControl *pageControl;
	__weak IBOutlet PZPagingScrollView *scrollImages;
	IBOutlet UIView *viewPop;
	__weak IBOutlet UIView *viewdir;
	__weak IBOutlet UIView *viewPopContainer;
	__weak IBOutlet UIScrollView *scrollcls;
	__weak IBOutlet UIView *viewPopOut;
	HandBookMgr *manger;
    __weak IBOutlet UIImageView *bgImage;
	NSMutableArray *arrayImages;
	NSString *_hbid;
    int ctib_index;
}
@property (nonatomic,strong) NSMutableArray *images;
@end

@implementation HandBookDetailViewController
-(instancetype)initWithHandOneBookList:(HanBookOneList *)list hb:(HandBookMgr *)hb hbId:(NSString *)hbid
{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		_list=list;
		_hbid=hbid;
		manger=hb;
	}
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.images=[NSMutableArray array];
	for (HanBookOne *one in _list) {
		[self.images addObject:manger==nil?one.cpic:[manger imagePathForOne:one]];
	}
	scrollImages.contentInset=UIEdgeInsetsZero;
	scrollImages.pagingViewDelegate=self;
	[scrollImages displayPagingViewAtIndex:0];
	arrayImages=[NSMutableArray array];
	//[btnCl2 sendActionsForControlEvents:UIControlEventTouchUpInside];
	[self loadPops];
	viewPopContainer.layer.masksToBounds=YES;
	viewPopContainer.layer.cornerRadius=4;
    bgImage.userInteractionEnabled=YES;
    viewdir.userInteractionEnabled=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	_hbid=nil;
	viewPop=nil;
	arrayImages = nil;
	_list=nil;
	self.images=nil;
	manger=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _list.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString * reuse=@"aaaa";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
	if (cell==nil) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
		cell.textLabel.highlightedTextColor=[UIColor whiteColor];
		UIView *bg=[[UIView alloc] initWithFrame:cell.bounds];
		bg.backgroundColor=RGBColor(182, 11, 53);
		cell.textLabel.textColor=RGBColor(93, 93, 93);
		cell.textLabel.font=[UIFont systemFontOfSize:14];
		cell.selectedBackgroundView=bg;
		cell.backgroundColor=[UIColor clearColor];
	}
	HanBookOne *one=[_list objectAtIndex:indexPath.row];
	cell.textLabel.text=[one.cname stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ctib_index = (int)indexPath.row;
	[scrollImages displayPagingViewAtIndex:indexPath.row];
	//[self btnCl2Tap:nil];
    [self btnShowTap:nil];
    
    
    
    
    
}
#pragma mark -==== 抽屉改动 ====-
- (IBAction)btnShowTap:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
        viewContainer.originX=0;
        viewdir.originX=IS_IPAD()?-260:-250;
    }];
    btnShow.hidden=YES;
    [self.view sendSubviewToBack:viewdir];
    //	[viewContainer sendSubviewToBack:btnShow];
}
- (IBAction)btnDirTap:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
        viewContainer.originX=IS_IPAD()?260: self.view.width-70;
        viewdir.originX=0;
    }];
    btnShow.hidden=NO;
    [viewContainer bringSubviewToFront:btnShow];
    [self.view bringSubviewToFront:viewdir];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    viewdir.originX=IS_IPAD()?-260:-250;
}


-(void)updateIndex
{
	pageControl.currentPage=ceil(scrollImages.contentOffset.x/scrollImages.width);
}

- (void)showMaximumSize:(id)sender {
	PZPhotoView *photoView = (PZPhotoView *)scrollImages.visiblePageView;
	[photoView updateZoomScale:photoView.maximumZoomScale];
}

- (void)showMediumSize:(id)sender {
	PZPhotoView *photoView  = (PZPhotoView *)scrollImages.visiblePageView;
	float newScale = (photoView.minimumZoomScale + photoView.maximumZoomScale) / 2.0;
	[photoView updateZoomScale:newScale];
}

- (void)showMinimumSize:(id)sender {
	PZPhotoView *photoView  = (PZPhotoView *)scrollImages.visiblePageView;
	[photoView updateZoomScale:photoView.minimumZoomScale];
}

- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index {
	// all page views are photo views
	return [PZPhotoView class];
}

- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView {
	[self updateIndex];
	return self.images.count;
}

- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index {
	PZPhotoView *photoView = [[PZPhotoView alloc] initWithFrame:scrollImages.bounds];
	photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	photoView.photoViewDelegate = self;
	
	return photoView;
}

- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index {
	assert([pageView isKindOfClass:[PZPhotoView class]]);
	assert(index < self.images.count);
	
	PZPhotoView *photoView = (PZPhotoView *)pageView;
	NSString *image = [self.images objectAtIndex:index];
	[photoView displayImage:image];
}

#pragma mark - PZPhotoViewDelegate
#pragma mark -
- (IBAction)btnJjTap:(id)sender {
	CorpListViewController2 *c=[[CorpListViewController2 alloc] initWithFlag:@"all" HbId:_hbid];
	[self.navigationController pushViewController:c animated:YES];
}
- (IBAction)btnClTap:(id)sender {
	CorpListViewController2 *c=[[CorpListViewController2 alloc] initWithFlag:@"5" HbId:_hbid];
	[self.navigationController pushViewController:c animated:YES];

}
-(IBAction)btnCl2Tap:(id)sender{
    
    
	__block CGFloat originy=self.view.height;
	if(viewPopOut.originY==originy){
		[self loadpop:^(){
			originy=self.view.height-viewPopOut.height-50;
			[UIView animateWithDuration:.3 animations:^{
				viewPopOut.originY=originy;
			}];
		}];
	}
	else{
		[UIView animateWithDuration:.3 animations:^{
			viewPopOut.originY=originy;
		}];
	}
}

- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
	//	[self toggleFullScreen];
}

- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView {
	// do nothing
}

- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView {
	// do nothing
}

- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView {
	
}

-(void)loadpop:(dispatch_block_t)complete{
    
	HandBookMaterial *m=[HandBookMaterial protocolAutoRelease];
	[m requestWithCtid:[[_list objectAtIndex:ctib_index] ctid] SusessBlock:^(MaterialList* lParam, id rParam) {
		[arrayImages removeAllObjects];
		[arrayImages addObjectsFromArray:lParam.array];
		if (arrayImages.count>0) {
			[self _loadpop];
			complete();
		}
	} FailBlock:NULL];
}
-(void)_loadpop{
	[scrollcls.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	scrollcls.contentInset=UIEdgeInsetsZero;
	CGSize elemenSize=CGSizeMake(IS_IPAD()?242 : scrollcls.width/3, IS_IPAD()?220:110);
	//计算行数
	double rows=ceil(arrayImages.count/3.0);
	scrollcls.contentSize=CGSizeMake(scrollcls.width, elemenSize.height*rows);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<3; j++) {
			int index=i*3+j;
			if (arrayImages.count<=index) {
				break;
			}
			Material *c=[arrayImages objectAtIndex:index];
			CGFloat w=IS_IPAD()?200:90;
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(elemenSize.width*j+(IS_IPAD()?42:0), elemenSize.height*i, elemenSize.width, elemenSize.height)];
			container.backgroundColor=[UIColor clearColor];
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0, w,w)];
			[img sd_setBackgroundImageWithURL:URL(c.mpic_small) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			img.layer.masksToBounds=YES;
			img.layer.cornerRadius=4;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake(IS_IPAD()?0: ((container.width-w)/2), 10, w,w)];
			imgc.backgroundColor=[UIColor clearColor];
			imgc.layer.shadowOffset=CGSizeMake(1, 1);
			imgc.layer.shadowOpacity=0.5;
			imgc.layer.shadowColor=[UIColor blackColor].CGColor;
			[imgc addSubview:img];
			
			[container addSubview:imgc];
			UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, imgc.height+imgc.originY-20, container.width, 20)];
			lb.backgroundColor=[UIColor clearColor];
			lb.textColor=[UIColor blackColor];
			lb.textAlignment=NSTextAlignmentCenter;
			lb.font=[UIFont systemFontOfSize:12];
			lb.text=c.mname;
			lb.shadowColor=[UIColor whiteColor];
			lb.shadowOffset=CGSizeMake(-1, -1);
			[container addSubview:lb];
			[scrollcls addSubview:container];
		}
	}
}
- (IBAction)btnPopTap:(id)sender {
	[viewPop removeFromSuperview];
}
-(IBAction)btnItemTap:(UIButton*)sender{
	Material *m=sender.associatedObjectRetain;
	MaterialPic *req=[MaterialPic protocolAutoRelease];
	[req requestWithId:m.mtid SusessBlock:^(id lParam, id rParam) {
		[self loadPop:lParam];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
-(void)loadPops
{
	HandBookMaterial *m=[HandBookMaterial protocolAutoRelease];
	HanBookOne *one=[_list objectAtIndex:pageControl.currentPage];
	[m requestWithCtid:one.ctid  SusessBlock:^(MaterialList* lParam, id rParam) {
		[self _loadMaterial:lParam];
	} FailBlock:NULL];
}
-(void)_loadMaterial:(MaterialList *)list
{
	scrollcls.contentInset=UIEdgeInsetsZero;
	CGSize elemenSize=CGSizeMake(scrollcls.width/3, 110);
	//计算行数
	NSUInteger rows=ceilf(list.count/3.0);
	scrollcls.contentSize=CGSizeMake(scrollcls.width, scrollcls.height*rows);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<3; j++) {
			int index=i*3+j;
			if (list.count<=index) {
				break;
			}
			CGFloat w=IS_IPAD()?460:230;

			Material *c=[list objectAtIndex:index];
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(elemenSize.width*j, elemenSize.height*i, elemenSize.width, elemenSize.height)];
			container.backgroundColor=[UIColor clearColor];
			if (IS_IPAD()) {
				container.width=200;
				container.originX=242*j+42;
			}
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0, w,w)];
			[img sd_setBackgroundImageWithURL:URL(c.mpic_small) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			img.layer.masksToBounds=YES;
			img.layer.cornerRadius=4;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake((container.width-w)/2, 10, w,w)];
			imgc.backgroundColor=[UIColor clearColor];
			imgc.layer.shadowOffset=CGSizeMake(1, 1);
			imgc.layer.shadowOpacity=0.5;
			imgc.layer.shadowColor=[UIColor blackColor].CGColor;
			[imgc addSubview:img];
			
			[container addSubview:imgc];
			UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(0, w+5, w, scrollPop.height-w-15)];
			lb.backgroundColor=[UIColor clearColor];
			lb.textColor=[UIColor blackColor];
			lb.textAlignment=NSTextAlignmentLeft;
			lb.font=[UIFont systemFontOfSize:12];
			lb.text=c.mname;
			[container addSubview:lb];
			[scrollcls addSubview:container];
		}
	}
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

		UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*scrollPop.width, 0, w,w)];
		img.contentMode=UIViewContentModeScaleAspectFill;
		img.clipsToBounds=YES;
		[img sd_setImageWithURL:URL(mat.mpic) placeholderImage:IMG(@"wu.jpg")];
		
		UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(0, img.height+5, img.width, scrollPop.height-w-15)];
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

@end
