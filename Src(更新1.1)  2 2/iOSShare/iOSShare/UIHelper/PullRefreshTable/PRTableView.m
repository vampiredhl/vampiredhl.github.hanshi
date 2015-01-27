#import <QuartzCore/QuartzCore.h>
#import "PRTableView.h"
#import "Extension.h"

/**
 此常量用来定义当表格距底部还有多远的时候开始加载更多
 */
static CGFloat kPRTableViewLoadMoreBottomOffset = 80;


NSString * const kPRTableViewWillBeginLoadingMoreNotification=@"kPRTableViewWillBeginLoadingMoreNotification";

NSString * const kPRTableViewDidEndLoadingMoreNotification=@"kPRTableViewDidEndLoadingMoreNotification";


#define REFRESH_HEADER_HEIGHT 52.0f

@interface PRTableView (){
	BOOL isMore,isRefresh;///是否能够加载更多和刷新
}
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;

@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, copy) NSString  *textisLoading;
@property (nonatomic, copy) NSString  *textisLoadingMore;
@property (nonatomic, retain) NSString *textMore;


@property (nonatomic, retain) UIView *moreFooterView;
@property (nonatomic, retain) UILabel *moreLabel;
@property (nonatomic, retain) UIImageView *moreArrow;
@property (nonatomic, retain) UIActivityIndicatorView *moreSpinner;
@end

@implementation PRTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self=[super initWithFrame:frame style:style];
    if (self) {
        [self loadTable];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadTable];
}

- (void)loadTable
{
	//监听contentSize改变，当contentSize改变时改变moreFooterView的位置
	[self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
	[self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];

	
    self.textPull = [[[NSString alloc] initWithString:@"下拉刷新"] autorelease];
    self.textRelease = [[[NSString alloc] initWithString:@"松开刷新"] autorelease];
    self.textLoading = [[[NSString alloc] initWithString:@"获取数据"] autorelease];
    self.textMore = [[[NSString alloc] initWithString:@"获取更多"] autorelease];
    self.textisLoading=[[[NSString alloc] initWithString:@"正在刷新"] autorelease];
    self.textisLoadingMore=[[[NSString alloc] initWithString:@"获取更多"] autorelease];
	
    self.pageID=1;

    [self addPullToRefreshHeader];
    [self addPullToMoreFooter];
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"contentSize"];
	[self removeObserver:self forKeyPath:@"contentOffset"];
	
    self.refreshArrow=nil;
	self.refreshHeaderView=nil;
	self.refreshLabel=nil;
	self.refreshSpinner=nil;
	
	self.moreArrow=nil;
	self.moreFooterView=nil;
	self.moreLabel=nil;
	self.moreSpinner=nil;
	
	self.textisLoading=nil;
	self.textisLoadingMore=nil;
	self.textLoading=nil;
	self.textMore=nil;
	self.textPull=nil;
	self.textRelease=nil;
	
    self.viewEmptyData=nil;
    
    self.tableID=nil;
    
    [super dealloc];
}


- (void)addPullToRefreshHeader
{
    self.refreshHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, [UIDevice screenWidth], REFRESH_HEADER_HEIGHT)] autorelease];
    self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    self.refreshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIDevice screenWidth], REFRESH_HEADER_HEIGHT)] autorelease];
    self.refreshLabel.backgroundColor = [UIColor clearColor];
    self.refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.refreshLabel.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.text = _textPull;
    self.refreshLabel.numberOfLines=2;
    
    self.refreshArrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_common_droparrow.png"]] autorelease];
    self.refreshArrow.frame = CGRectMake(110,
                                    (REFRESH_HEADER_HEIGHT - 50) / 2+13,
                                    25, 25);
    self.refreshSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    _refreshSpinner.frame = CGRectMake(110, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    [_refreshSpinner stopAnimating];
    _refreshSpinner.hidesWhenStopped = YES;
    
    [_refreshHeaderView addSubview:_refreshLabel];
    [_refreshHeaderView addSubview:_refreshArrow];
    [_refreshHeaderView addSubview:_refreshSpinner];
    [self addSubview:_refreshHeaderView];
	
	[self hiddenRefresh];
}

- (void)addPullToMoreFooter
{
    self.moreFooterView = [[[UIView alloc] init] autorelease];
    self.moreFooterView.backgroundColor = [UIColor clearColor];
    
    self.moreLabel = [[[UILabel alloc] initWithFrame:CGRectMake(85,0,150,REFRESH_HEADER_HEIGHT)] autorelease];
    _moreLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    _moreLabel.backgroundColor = [UIColor clearColor];
    _moreLabel.textAlignment = NSTextAlignmentCenter;
    _moreLabel.textColor=[UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    
    self.moreSpinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    _moreSpinner.frame = CGRectMake(110 , (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    _moreSpinner.hidesWhenStopped = YES;
    
    self.moreArrow=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_common_droparrow2.png"]] autorelease];
    _moreArrow.frame=CGRectMake(110,(REFRESH_HEADER_HEIGHT - 20) / 2,20, 20);
    
    [_moreFooterView addSubview:_moreLabel];
    [_moreFooterView addSubview:_moreSpinner];
    [_moreFooterView addSubview:_moreArrow];
    
    [self addSubview:_moreFooterView];
    //默认第一次不显示更多，在进行一次reload data后再显示更多
	[self hiddenMore];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading)
		return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
			_refreshLabel.text = self.textRelease;
            [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header

            self.refreshLabel.text = self.textPull;
            
            [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading)
		return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        if (isRefresh)
            [self startLoading];
    }
    else if(scrollView.contentOffset.y >= (scrollView.contentSize.height  - self.frame.size.height))
    {
        if(isMore&&decelerate==NO)
        {
            [self startLoading_More];
        }
    }
}

- (void)startLoading
{
	if (isLoading==YES) {
		return;
	}
    isLoading = YES;
	_refreshHeaderView.hidden=!self.isRefresh;

    //更新时间
    if (self.tableID!=nil) {
        NSUserDefaults *info=[NSUserDefaults standardUserDefaults];
        [info setObject:[NSDate date] forKey:[NSString stringWithFormat:@"refreshTime_%@",self.tableID]];
    }
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    _refreshLabel.text = self.textisLoading;
    _refreshArrow.hidden = YES;
    _refreshSpinner.hidden=NO;
    [_refreshSpinner startAnimating];
    [UIView commitAnimations];

    if (self.prDelegate&&[self.prDelegate respondsToSelector:@selector(prTableViewTriggerRefresh)])
        [self.prDelegate prTableViewTriggerRefresh];
}

- (void)stopLoading
{
    isLoading = NO;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    _refreshArrow.hidden = NO;
    _refreshSpinner.hidden=YES;
    self.contentInset = UIEdgeInsetsZero;
    [_refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    
    [_refreshSpinner stopAnimating];
    _refreshSpinner.hidden = YES;
    _refreshLabel.text = self.textPull;
    // Hide the header
    self.contentInset = UIEdgeInsetsZero;
    
    //检查行数和section数，如果都为0，添加emptyview
    NSInteger sectioncount=1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectioncount=[self.dataSource numberOfSectionsInTableView:self];
    }
    int rowcount=0;
    for (int i=0; i<sectioncount; i++) {
        if([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
            rowcount+=[self.dataSource tableView:self numberOfRowsInSection:i];
        }
    }
    
    if (!self.viewEmptyData) {
        return;
    }
    if (rowcount==0) {
        self.viewEmptyData.frame=self.frame;
		if(self.viewEmptyData.superview==nil){
			[self.superview insertSubview:self.viewEmptyData aboveSubview:self];
		}
        else{
            [self.viewEmptyData.superview bringSubviewToFront:self.viewEmptyData];
        }
    }else{
        [self.viewEmptyData removeFromSuperview];
    }
}

- (void)setViewEmptyData:(UIView *)viewEmptyData
{
    if (_viewEmptyData != viewEmptyData) {
        if (_viewEmptyData.superview) {
            [_viewEmptyData removeFromSuperview];
        }
        [_viewEmptyData release];
        
        _viewEmptyData = [viewEmptyData retain];
    }
}

- (void)startLoading_More
{
	if (isLoading==YES) {
		return;
	}
    isLoading = YES;
    
    // Show the header

    //self.contentInset = UIEdgeInsetsMake(0, 0, REFRESH_HEADER_HEIGHT, 0);
    [_moreSpinner startAnimating];
    _moreArrow.hidden=YES;
    _moreSpinner.hidden=NO;
    _moreLabel.text=self.textisLoadingMore;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPRTableViewWillBeginLoadingMoreNotification object:self onMainThread:YES];
    if (self.prDelegate&&[self.prDelegate respondsToSelector:@selector(prTableViewTriggerMore)])
        [self.prDelegate prTableViewTriggerMore];
}

- (void)stopLoading_More
{
    _moreLabel.text=self.textMore;
    _moreSpinner.hidden = YES;
    _moreArrow.hidden=NO;
    [_moreSpinner stopAnimating];
    self.contentInset = UIEdgeInsetsZero;
	isLoading = NO;
}

-(void)stopLoading_MoreWithNotification:(NSDictionary *)userInfo
{
	[self stopLoading_More];
	[[NSNotificationCenter defaultCenter] postNotificationName:kPRTableViewDidEndLoadingMoreNotification object:self userInfo:userInfo onMainThread:YES];
}

- (void)setMoreFooterViewOriginYWithTableViewHeight:(CGFloat)_height
{
    [self bringSubviewToFront:_moreFooterView];
    if (isnan(_height)) {
        return;
    }
    _moreFooterView.frame = CGRectMake(0,_height, [UIDevice screenWidth], REFRESH_HEADER_HEIGHT);
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    _refreshLabel.text = self.textPull;
    _refreshArrow.hidden = NO;
    _refreshSpinner.hidden=YES;
    [_refreshSpinner stopAnimating];
}

- (void)hiddenRefresh
{
    self.refreshHeaderView.hidden = YES;
}

-(void)hiddenMore
{
    self.moreFooterView.hidden = YES;
}

-(int)pageID
{
    return pageID;
}
-(void)setPageID:(int)pageid
{
    pageID=pageid;
}

-(BOOL)isMore
{
	return isMore;
}
-(void)setIsMore:(BOOL)_isMore
{
	isMore=_isMore;
	self.moreFooterView.hidden=!isMore;
	if (isMore==NO) {
		[self hiddenMore];
	}
}

-(BOOL)isRefresh
{
	return isRefresh;
}

-(void)setIsRefresh:(BOOL)_isRefresh
{
	isRefresh = _isRefresh;
	self.refreshHeaderView.hidden = !isRefresh;
	if (isRefresh == NO) {
		[self hiddenRefresh];
	}
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"contentSize"]) {
		[self setMoreFooterViewOriginYWithTableViewHeight:self.contentSize.height];
	}else if ([keyPath isEqualToString:@"contentOffset"]){
		if (self.contentOffset.y>( self.contentSize.height  - self.frame.size.height- kPRTableViewLoadMoreBottomOffset)) {
			if (isMore&&isLoading==NO) {
				[self startLoading_More];
			}
		}
	}else{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

-(BOOL)isLoading
{
	return isLoading;
}

@end


