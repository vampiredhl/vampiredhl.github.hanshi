//
//  CorpListViewController.m
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "CorpListViewController2.h"

typedef id(^CreateView)(NSInteger tag,CGRect frame);

@interface CorpListViewController2 (){
	NSMutableArray * arrayImages,*arrayCats;
	
	__weak IBOutlet UIScrollView *scrollCat;
	__weak IBOutlet UIPageControl *pageControl;
	IBOutlet UIView *viewPop;
	__weak IBOutlet UIScrollView *scrollPop;
	__weak IBOutlet UIScrollView *scroll;

	__weak IBOutlet UIView *viewContainer;
	__weak IBOutlet UIView *viewPopContainer;
	
	NSString *_flag,*_hbid;
}

@end

@implementation CorpListViewController2

-(id)initWithFlag:(NSString *)flag HbId:(NSString *)hbid
{
	self=[super initWithNibName:nil bundle:nil];
	if (self) {
		_flag=flag;
		_hbid=hbid;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	viewPopContainer.layer.masksToBounds=YES;
	viewPopContainer.layer.cornerRadius=4;
	arrayCats=[NSMutableArray array];
	arrayImages=[NSMutableArray array];
	[self loadArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	_flag=nil;
	arrayImages=nil;
	arrayCats=nil;
}

-(NSArray*)subArray:(NSArray*)array range:(NSRange)range
{
	if (array==nil) {
		return nil;
	}
	NSUInteger len=range.location+range.length;
	len=MIN(len, array.count-range.location);
	range.length=len;
	return [array subarrayWithRange:range];
}
-(void)loadArray
{
    MaterialType *mt=[MaterialType protocolAutoRelease];
    [mt requestWithFlag:_flag SusessBlock:^(MaterialList* lParam, id rParam) {
        [arrayCats removeAllObjects];
        if ([_flag isEqualToString:@"all"])
        {
            for (Material *mb in lParam.array)
            {
                int mtid = [mb.mtid intValue];
                if (mtid == 5 || mtid == 11 || mtid == 12 || mtid == 13)
                {
                    [arrayCats addObject:mb];
                }
            }
            if (arrayCats.count == 4)
            {
                [arrayCats exchangeObjectAtIndex:1 withObjectAtIndex:3];
            }
        }else
        {
            //            [arrayCats addObjectsFromArray:lParam.array];
            for (Material *mb in lParam.array)
            {
                int mtid = [mb.mtid intValue];
                if (mtid == 5 || mtid == 11 || mtid == 12 || mtid == 13)
                {
                }else
                {
                    [arrayCats addObject:mb];
                }
            }
        }
        [self updateHeaders];
    } FailBlock:NULL];
}
-(void)updateHeaders
{
	[scrollCat.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	CGSize itemsize=CGSizeMake(scrollCat.width, 75);
	scrollCat.contentSize=CGSizeMake(scrollCat.width,itemsize.height*arrayCats.count );
	for (int i=0; i<arrayCats.count; i++) {
		UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
		Material *m=arrayCats[i];
		NSString *t=m.mtname;
		
		[btn setTitle:t forState:UIControlStateNormal];
		btn.titleLabel.numberOfLines=0;
		btn.titleLabel.font=[UIFont systemFontOfSize:12];
		[btn setBackgroundImage:IMG(@"手册左边栏方块") forState:UIControlStateNormal];
		[btn setBackgroundImage:IMG(@"手册左边栏高亮") forState:UIControlStateSelected];
		[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		btn.frame=CGRectMake(0, i*itemsize.height, itemsize.width-2, itemsize.height);
		btn.associatedObject=m;
		[btn addTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventTouchUpInside];
		[scrollCat addSubview:btn];
		if (i==0) {
			[btn sendActionsForControlEvents:UIControlEventTouchUpInside];
		}
	}
}
-(IBAction)btnFilterTap:(UIButton*)sender
{
	Material *m=sender.associatedObject;
	for (UIView *v in sender.superview.subviews) {
		if ([v isKindOfClass:[UIButton class]]) {
			[(UIButton*)v setSelected:NO];
		}
	}
	sender.selected=YES;
	[self loadImages:m.mtid];
}
-(void)loadImages:(NSString*)mtid
{
	MaterialByType *s=[MaterialByType protocolAutoRelease];
	[s requestWithMtid:mtid Hbid:_hbid SusessBlock:^(MaterialList* lParam, id rParam) {
		[arrayImages removeAllObjects];
		[arrayImages addObjectsFromArray:lParam.array];
		[self _loadImages];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}

-(void)_loadImages
{
	[scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	float count=IS_IPAD()?3: 2;
	CGSize elemenSize=CGSizeMake(scroll.width/count, IS_IPAD()?210:110);
	//计算行数
    if (arrayImages.count == 0 || arrayCats.count == 0)
    {
        if(arrayCats.count == 1)
        {
            [scrollCat.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, scroll.height/2-30, scroll.width, 30)];
        label.textColor = [UIColor colorWithHexString:@"#6b6b6b"];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = SysFont(17);
        label.text = @"暂无数据";
        [scroll addSubview:label];
        scroll.scrollEnabled = NO;
        return;
    }
    scroll.scrollEnabled = YES;
	NSUInteger rows=ceilf(arrayImages.count/count);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<count; j++) {
			int index=i*count+j;
			if (arrayImages.count<=index) {
				break;
			}
			Material *c=[arrayImages objectAtIndex:index];
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(j*elemenSize.width+(j==0?5:0),i*elemenSize.width+20, elemenSize.width, elemenSize.height)];
			container.backgroundColor=[UIColor clearColor];
			if (IS_IPAD()) {
				container.width=200;
				container.originX=223*j+23;
			}
			CGFloat w=IS_IPAD()?200:90;
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0, w,w)];
			[img sd_setBackgroundImageWithURL:URL(c.mpic_small) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			img.layer.cornerRadius=4;
			img.layer.masksToBounds=YES;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake((container.width-w)/2, 10, img.width, img.height)];
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
			lb.font=[UIFont systemFontOfSize:14];
			lb.text=c.mname;
            
            
			lb.shadowColor=[UIColor whiteColor];
			lb.shadowOffset=CGSizeMake(-1, -1);
			[container addSubview:lb];
			[scroll addSubview:container];
		}
	}
	[scroll setContentSize:CGSizeMake(scroll.width, rows*elemenSize.height)];
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
		
		UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(0, img.height+5, img.width, scrollPop.height-img.height-10)];
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
- (IBAction)btnPopTap:(id)sender {
	[viewPop removeFromSuperview];
}
@end
