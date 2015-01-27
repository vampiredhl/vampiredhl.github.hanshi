//
//  ImageViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "ImageViewController.h"
#import "PZPagingScrollView.h"
#import "PZPhotoView.h"

@interface ImageViewController ()<PZPagingScrollViewDelegate,PZPhotoViewDelegate>{
	
	__weak IBOutlet UIPageControl *pageControl;
	__weak IBOutlet PZPagingScrollView *scrollImages;
}

@property (nonatomic,strong) NSArray * images;
@end

@implementation ImageViewController
-(instancetype)initWithImages:(NSArray *)images{
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		self.images=images;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	scrollImages.contentInset=UIEdgeInsetsZero;
	scrollImages.pagingViewDelegate=self;
	pageControl.numberOfPages=self.images.count;
	//[self showMinimumSize:nil];
	//[self performSelector:@selector(autoScroll) withObject:nil afterDelay:3];
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[scrollImages displayPagingViewAtIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	self.images=nil;
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
	PZPhotoView *photoView = [[PZPhotoView alloc] initWithFrame:pagingScrollView.bounds];
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
@end
