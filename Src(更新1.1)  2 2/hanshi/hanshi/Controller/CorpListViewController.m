//
//  CorpListViewController.m
//  hanshi
//
//  Created by wujin on 14/12/21.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "CorpListViewController.h"

typedef id(^CreateView)(NSInteger tag,CGRect frame);

@interface CorpListViewController (){
	NSMutableArray * arrayPp;
	UIControlState hasMore_pp;
	NSMutableArray * arrayCl;
	UIControlState hasMore_cl;
	NSMutableArray * arrayFw;
	UIControlState hasMore_Fw;
	NSMutableArray * arraySelected;
	
	NSMutableArray * arrayImages;
	
	__weak IBOutlet UIPageControl *pageControl;
	IBOutlet UIView *viewPop;
	__weak IBOutlet UIScrollView *scrollPop;
	__weak IBOutlet UIScrollView *scroll;
	NSMutableArray *arrayAllPp,*arrayAllCl,*arrayAllFw;
	__weak IBOutlet UIView *viewContainer;
	__weak IBOutlet UIView *viewImages;
	
	__weak IBOutlet UIView *viewPopContainer;
	NSMutableArray *filter_pp,*filter_cl,*filter_fw;
}
//@property (nonatomic,strong) CorpList *list;
@end

@implementation CorpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	arrayPp=[NSMutableArray array];
	arrayAllPp=[NSMutableArray array];
	hasMore_pp=UIControlStateNormal;
	arrayCl=[NSMutableArray array];
	arrayAllCl=[NSMutableArray array];
	hasMore_cl=UIControlStateNormal;
	arrayFw=[NSMutableArray array];
	arrayAllFw = [NSMutableArray array];
	hasMore_Fw=UIControlStateNormal;
	arraySelected=[NSMutableArray array];
	filter_pp=[NSMutableArray array];
	filter_fw=[NSMutableArray array];
	filter_cl=[NSMutableArray array];
	arrayImages=[NSMutableArray array];
	viewPopContainer.layer.masksToBounds=YES;
	viewPopContainer.layer.cornerRadius=4;
	[self loadArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	arrayImages=nil;
	filter_cl=nil;
	filter_fw=nil;
	filter_pp=nil;
	arrayPp=nil;
	arrayFw=nil;
	arrayCl=nil;
	arrayAllCl=nil;
	arrayAllFw=nil;
	arrayAllPp=nil;
	arraySelected=nil;
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
	CorpSearch *s=[CorpSearch protocolAutoRelease];
	[s requestWithSusessBlock:^(CorpList* lParam, id rParam) {
		[arrayAllPp addObjectsFromArray:lParam.array];
		[arrayPp addObjectsFromArray:[self subArray:arrayAllPp range:NSMakeRange(0, 5)]];
		MaterialNature *m=[MaterialNature protocolAutoRelease];
        
        
		[m requestWithSusessBlock:^(MaterialList* lParam, id rParam) {
			[arrayAllCl addObjectsFromArray:lParam.array];
			[arrayCl addObjectsFromArray:[self subArray:arrayAllCl range:NSMakeRange(0, 5)]];
			MaterialType *t=[MaterialType protocolAutoRelease];
            
            [t requestWithFlag:@"all" SusessBlock:^(MaterialList* lParam, id rParam) {
                [arrayAllFw addObjectsFromArray:lParam.array];
                
                [arrayFw addObjectsFromArray:[self subArray:arrayAllFw range:NSMakeRange(0, 5)]];
                
                [self updateHeaders];
                
            } FailBlock:^(id lParam, id rParam) {
                
                
                
            }];
            
            
//			[t requestWithSusessBlock:^(MaterialList* lParam, id rParam) {
//				[arrayAllFw addObjectsFromArray:lParam.array];
//				[arrayFw addObjectsFromArray:[self subArray:arrayAllFw range:NSMakeRange(0, 5)]];
//				[self updateHeaders];
//			} FailBlock:^(id lParam, id rParam) {
//				
//			}];

		} FailBlock:^(id lParam, id rParam) {
			
		}];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
	}

-(void)updateHeaders
{
    if(IS_IPAD() == NO)
    {
        [viewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //品牌部分
        //标题
        CGFloat yBegin=10;
        static int lbPpTag=9000;
        UIColor *lbColor=[UIColor blackColor];
        UIFont *lbFont=[UIFont systemFontOfSize:14];
        CreateView createLb=^(NSInteger tag,CGRect frame){
            UILabel *lb=[viewContainer viewWithTag2:tag];
            if (lb==nil) {
                lb=[[UILabel alloc] initWithFrame:frame];
                lb.textColor=lbColor;
                lb.font=lbFont;
                lb.backgroundColor=[UIColor clearColor];
                lb.tag=tag;
                [viewContainer addSubview:lb];
            }else{
                lb.frame=frame;
            }
            return lb;
        };
        CreateView createBt=^(NSInteger tag,CGRect frame){
            UIButton *btn=[viewContainer viewWithTag2:tag];
            if (btn==nil) {
                btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitleColor:lbColor forState:UIControlStateNormal];
                btn.frame=frame;
                btn.titleLabel.font=lbFont;
                btn.tag=tag;
                [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [btn addTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventTouchUpInside];
                [viewContainer addSubview:btn];
            }else{
                btn.frame=frame;
            }
            return btn;
        };
        
        //更新品牌关键词位置
        int counts=DeviceIsiPad()?5:3;float itemcount=0;int lineCount=0;
        CGFloat offset=IS_IPAD()?15:5;
        CGFloat lineHeight=20;//行高20
        if (arrayPp.count>0) {
            UILabel *lbPp=createLb(lbPpTag,CGRectMake(10, yBegin, 30, 15));
            //	lbPp.frame=);
            lbPp.text=@"品牌";
            itemcount=arrayPp.count;
            if (hasMore_pp!=UIControlStateDisabled) {
                itemcount+=1;
            }
            lineCount=ceilf(itemcount/counts);
            for (int i=0; i<lineCount; i++) {
                CGFloat xbegin=80;
                CGFloat width=(viewContainer.width-xbegin)/counts;
                for (int j=0; j<counts; j++) {
                    int index=i*counts+j;
                    if (index>arrayPp.count) {
                        break;
                    }
                    if (index==arrayPp.count&&hasMore_pp!=UIControlStateDisabled) {
                        UIButton *more=createBt(1100,CGRectMake(xbegin, yBegin, 60, 24));
                        [more setBackgroundColor:[UIColor lightGrayColor]];
                        [more setTitle:hasMore_pp==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
                        [more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                        [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
                        [more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
                        
                        more.layer.masksToBounds=YES;
                        more.layer.cornerRadius=2;
                        more.selected=hasMore_pp==UIControlStateSelected;
                    }else if(index<arrayPp.count){
                        NSInteger tag=1000+index;
                        //创建按钮
                        UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
                        Corp *c=arrayPp[index];
                        btn.associatedObject=c;
                        [btn setTitle:c.scorpname forState:UIControlStateNormal];
                    }
                    xbegin+=width;
                }
                yBegin+=lineHeight;
            }
            yBegin+=offset;
        }
        if (arrayCl.count>0) {
            //材料
            UILabel *lbCl=createLb(2200,CGRectMake(10, yBegin, 30, 15));
            lbCl.text=@"材料";
            itemcount=arrayCl.count;
            if (hasMore_cl!=UIControlStateDisabled) {
                itemcount+=1;
            }
            lineCount=ceilf(itemcount/counts);
            for (int i=0; i<lineCount; i++) {
                CGFloat xbegin=80;
                CGFloat width=(viewContainer.width-xbegin)/counts;
                for (int j=0; j<counts; j++) {
                    int index=i*counts+j;
                    if (index>arrayCl.count) {
                        break;
                    }
                    if (index==arrayCl.count&&hasMore_cl!=UIControlStateDisabled) {
                        UIButton *more=createBt(2100,CGRectMake(xbegin, yBegin, 60, 24));
                        [more setBackgroundColor:[UIColor lightGrayColor]];
                        [more setTitle:hasMore_cl==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
                        [more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                        [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];					[more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
                        [more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
                        more.selected=hasMore_cl==UIControlStateSelected;
                        more.layer.masksToBounds=YES;
                        more.layer.cornerRadius=2;
                    }else if(index<arrayCl.count){
                        NSInteger tag=2000+index;
                        //创建按钮
                        UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
                        //				btn.frame=;
                        Material *c=arrayCl[index];
                        btn.associatedObject=c;
                        [btn setTitle:c.mtname forState:UIControlStateNormal];
                    }
                    xbegin+=width;
                }
                yBegin+=lineHeight;
            }
            yBegin+=offset;
        }
        if(arrayFw.count>0){
            //范围
            UILabel *lbfw=createLb(3200,CGRectMake(10, yBegin, 30, 15));
            lbfw.text=@"范围";
            itemcount=arrayFw.count;
            if (hasMore_Fw!=UIControlStateDisabled) {
                itemcount+=1;
            }
            lineCount=ceilf(itemcount/counts);
            for (int i=0; i<lineCount; i++) {
                CGFloat xbegin=80;
                CGFloat width=(viewContainer.width-xbegin)/counts;
                for (int j=0; j<counts; j++) {
                    int index=i*counts+j;
                    if (index>arrayFw.count) {
                        break;
                    }
                    if (index==arrayFw.count&&hasMore_Fw!=UIControlStateDisabled) {
                        UIButton *more=createBt(3100,CGRectMake(xbegin, yBegin, 60, 24));
                        [more setBackgroundColor:[UIColor lightGrayColor]];
                        [more setTitle:hasMore_Fw==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
                        [more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                        [more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];					[more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
                        [more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
                        more.selected=hasMore_Fw==UIControlStateSelected;
                        more.layer.masksToBounds=YES;
                        more.layer.cornerRadius=2;
                    }else if(index<arrayFw.count){
                        NSInteger tag=3000+index;
                        //创建按钮
                        UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
                        Material *c=arrayFw[index];
                        btn.associatedObject=c;
                        [btn setTitle:c.mtname forState:UIControlStateNormal];
                    }
                    xbegin+=width;
                }
                yBegin+=lineHeight;
            }
        }
        if (arraySelected.count>0) {
            counts=2;
            //条件
            UILabel *lbtj=createLb(4200,CGRectMake(10, yBegin, 30, 15));
            lbtj.text=@"条件";
            itemcount=arraySelected.count;
            lineCount=ceilf(itemcount/counts);
            for (int i=0; i<lineCount; i++) {
                CGFloat xbegin=80;
                CGFloat width=(viewContainer.width-xbegin)/counts;
                for (int j=0; j<counts; j++) {
                    int index=i*counts+j;
                    if (index>=arraySelected.count) {
                        break;
                    }
                    
                    NSInteger tag=4000+index;
                    //创建按钮
                    UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
                    NSString *str=[arraySelected objectAtIndex:index];
                    NSMutableAttributedString *attstr=[[NSMutableAttributedString alloc] initWithString:str];
                    NSRange mindex=[str rangeOfString:@":"];
                    [attstr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(mindex.location+1, str.length-mindex.location-1)];
                    [btn setAttributedTitle:attstr forState:UIControlStateNormal];
                    [btn removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
                    [btn addTarget:self action:@selector(btnRemoveTap:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundImage:IMG(@"btn_sc_bg.jpg") forState:UIControlStateNormal];
                    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                    btn.layer.shadowColor=[UIColor blackColor].CGColor;
                    btn.layer.shadowOffset=CGSizeMake(0.5, 0.5);
                    btn.layer.shadowOpacity=0.5;
                    btn.associatedObjectRetain=str;
                    btn.associatedObject=str.associatedObject;
                    btn.width=[btn.titleLabel textRectForBounds:btn.bounds limitedToNumberOfLines:1].size.width+4;
                    xbegin+=width;
                }
                yBegin+=lineHeight;
            }
        }
        viewContainer.height=yBegin+20;
        viewImages.originY=viewContainer.height+viewContainer.originY;
        [self loadImages];
        return;
    }
	[viewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	//品牌部分
	//标题
	CGFloat yBegin=10;
	static int lbPpTag=9000;
	UIColor *lbColor=[UIColor blackColor];
	UIFont *lbFont=[UIFont systemFontOfSize:14];
	CreateView createLb=^(NSInteger tag,CGRect frame){
		UILabel *lb=[viewContainer viewWithTag2:tag];
		if (lb==nil) {
			lb=[[UILabel alloc] initWithFrame:frame];
			lb.textColor=lbColor;
			lb.font=lbFont;
			lb.backgroundColor=[UIColor clearColor];
			lb.tag=tag;
			[viewContainer addSubview:lb];
		}else{
			lb.frame=frame;
		}
		return lb;
	};
	CreateView createBt=^(NSInteger tag,CGRect frame){
		UIButton *btn=[viewContainer viewWithTag2:tag];
		if (btn==nil) {
			btn=[UIButton buttonWithType:UIButtonTypeCustom];
			[btn setTitleColor:lbColor forState:UIControlStateNormal];
			btn.frame=frame;
			btn.titleLabel.font=lbFont;
			btn.tag=tag;
			[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
			[btn addTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventTouchUpInside];
			[viewContainer addSubview:btn];
		}else{
			btn.frame=frame;
		}
		return btn;
	};
	
	//更新品牌关键词位置
	int counts=DeviceIsiPad()?6:3;float itemcount=0;int lineCount=0;
	CGFloat offset=IS_IPAD()?15:5;
	CGFloat lineHeight=20;//行高20
	if (arrayPp.count>0) {
		UILabel *lbPp=createLb(lbPpTag,CGRectMake(10, yBegin, 30, 15));
		//	lbPp.frame=);
		lbPp.text=@"品牌";
		itemcount=arrayPp.count;
		if (hasMore_pp!=UIControlStateDisabled) {
			itemcount+=1;
		}
		lineCount=ceilf(itemcount/counts);
		for (int i=0; i<lineCount; i++) {
			CGFloat xbegin=80;
			CGFloat width=(viewContainer.width-xbegin)/counts;
			for (int j=0; j<counts; j++) {
				int index=i*counts+j;
				if (index>arrayPp.count) {
					break;
				}
				if (index==arrayPp.count&&hasMore_pp!=UIControlStateDisabled) {
					UIButton *more=createBt(1100,CGRectMake(xbegin, yBegin, 60, 24));
					[more setBackgroundColor:[UIColor lightGrayColor]];
					[more setTitle:hasMore_pp==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
					[more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
					[more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					[more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
					[more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
					more.selected=hasMore_pp==UIControlStateSelected;
                    more.layer.masksToBounds=YES;
                    more.layer.cornerRadius=2;
				}else if(index<arrayPp.count){
					NSInteger tag=1000+index;
					//创建按钮
					UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
					Corp *c=arrayPp[index];
					btn.associatedObject=c;
					[btn setTitle:c.scorpname forState:UIControlStateNormal];
				}
				xbegin+=width;
			}
			yBegin+=lineHeight;
		}
		yBegin+=offset;
	}
	if (arrayCl.count>0) {
		//材料
		UILabel *lbCl=createLb(2200,CGRectMake(10, yBegin, 30, 15));
		lbCl.text=@"材料";
		itemcount=arrayCl.count;
		if (hasMore_cl!=UIControlStateDisabled) {
			itemcount+=1;
		}
		lineCount=ceilf(itemcount/counts);
		for (int i=0; i<lineCount; i++) {
			CGFloat xbegin=80;
			CGFloat width=(viewContainer.width-xbegin)/counts;
			for (int j=0; j<counts; j++) {
				int index=i*counts+j;
				if (index>arrayCl.count) {
					break;
				}
				if (index==arrayCl.count&&hasMore_cl!=UIControlStateDisabled) {
					UIButton *more=createBt(2100,CGRectMake(xbegin, yBegin, 60, 24));
					[more setBackgroundColor:[UIColor lightGrayColor]];
					[more setTitle:hasMore_cl==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
					[more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
					[more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];					[more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
					[more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
					more.selected=hasMore_cl==UIControlStateSelected;
                    more.layer.masksToBounds=YES;
                    more.layer.cornerRadius=2;
				}else if(index<arrayCl.count){
					NSInteger tag=2000+index;
					//创建按钮
					UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
					//				btn.frame=;
					Material *c=arrayCl[index];
					btn.associatedObject=c;
					[btn setTitle:c.mtname forState:UIControlStateNormal];
				}
				xbegin+=width;
			}
			yBegin+=lineHeight;
		}
		yBegin+=offset;
	}
	if(arrayFw.count>0){
		//范围
		UILabel *lbfw=createLb(3200,CGRectMake(10, yBegin, 30, 15));
		lbfw.text=@"范围";
		itemcount=arrayFw.count;
		if (hasMore_Fw!=UIControlStateDisabled) {
			itemcount+=1;
		}
		lineCount=ceilf(itemcount/counts);
		for (int i=0; i<lineCount; i++) {
			CGFloat xbegin=80;
			CGFloat width=(viewContainer.width-xbegin)/counts;
			for (int j=0; j<counts; j++) {
				int index=i*counts+j;
				if (index>arrayFw.count) {
					break;
				}
				if (index==arrayFw.count&&hasMore_Fw!=UIControlStateDisabled) {
					UIButton *more=createBt(3100,CGRectMake(xbegin, yBegin, 60, 24));
					[more setBackgroundColor:[UIColor lightGrayColor]];
					[more setTitle:hasMore_Fw==UIControlStateNormal?@"+ 更多":@"- 收起" forState:UIControlStateNormal];
					[more setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
					[more setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];					[more removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
                    more.layer.masksToBounds=YES;
                    more.layer.cornerRadius=2;
					[more addTarget:self action:@selector(btnMoreTap:) forControlEvents:UIControlEventTouchUpInside];
					more.selected=hasMore_Fw==UIControlStateSelected;
				}else if(index<arrayFw.count){
					NSInteger tag=3000+index;
					//创建按钮
					UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
					Material *c=arrayFw[index];
					btn.associatedObject=c;
					[btn setTitle:c.mtname forState:UIControlStateNormal];
				}
				xbegin+=width;
			}
			yBegin+=lineHeight;
		}
	}
	if (arraySelected.count>0) {
		counts=2;
		//条件
		UILabel *lbtj=createLb(4200,CGRectMake(10, yBegin, 30, 15));
		lbtj.text=@"条件";
		itemcount=arraySelected.count;
		lineCount=ceilf(itemcount/counts);
		for (int i=0; i<lineCount; i++) {
			CGFloat xbegin=80;
			CGFloat width=(viewContainer.width-xbegin)/counts;
			for (int j=0; j<counts; j++) {
				int index=i*counts+j;
				if (index>=arraySelected.count) {
					break;
				}
				
				NSInteger tag=4000+index;
				//创建按钮
				UIButton *btn=createBt(tag,CGRectMake(xbegin, yBegin, width, lineHeight));
				NSString *str=[arraySelected objectAtIndex:index];
				NSMutableAttributedString *attstr=[[NSMutableAttributedString alloc] initWithString:str];
				NSRange mindex=[str rangeOfString:@":"];
				[attstr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(mindex.location+1, str.length-mindex.location-1)];
				[btn setAttributedTitle:attstr forState:UIControlStateNormal];
				[btn removeTarget:self action:@selector(btnFilterTap:) forControlEvents:UIControlEventAllEvents];
				[btn addTarget:self action:@selector(btnRemoveTap:) forControlEvents:UIControlEventTouchUpInside];
				[btn setBackgroundImage:IMG(@"btn_sc_bg.jpg") forState:UIControlStateNormal];
				[btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
				btn.layer.shadowColor=[UIColor blackColor].CGColor;
				btn.layer.shadowOffset=CGSizeMake(0.5, 0.5);
				btn.layer.shadowOpacity=0.5;
				btn.associatedObjectRetain=str;
				btn.associatedObject=str.associatedObject;
				btn.width=[btn.titleLabel textRectForBounds:btn.bounds limitedToNumberOfLines:1].size.width+4;
				xbegin+=width;
			}
			yBegin+=lineHeight;
		}
	}
	viewContainer.height=yBegin+20;
	viewImages.originY=viewContainer.height+viewContainer.originY;
	[self loadImages];
//	[UIView commitAnimations];
}
-(IBAction)btnFilterTap:(UIButton*)sender{
	NSString * title=[sender titleForState:UIControlStateNormal];
	for (NSString * s in arraySelected) {
		if ([s containsString:title]) {
			return;
		}
	}
	if (sender.tag/1000==1) {
		Corp * c=sender.associatedObject;
		title=_S(@"品牌:%@ x",title);
		[filter_pp addObject:c.corpid];
	}else if (sender.tag/1000==2){
		[filter_cl addObject:title];
		title=_S(@"材料:%@ x",title);
	}else{
		[filter_fw addObject:title];
		title=_S(@"范围:%@ x",title);
	}
	title.associatedObject=sender.associatedObject;
	[arraySelected addObject:title];
	[self updateHeaders];
}
-(IBAction)btnRemoveTap:(UIButton*)sender{
	NSString * title=sender.associatedObjectRetain;
	if ([title hasPrefix:@"品牌"]) {
		[filter_pp removeObject:[sender.associatedObject corpid]];
	}else if ([title hasPrefix:@"材料"]){
		[filter_cl removeObject:[sender.associatedObject mtname]];
	}else{
		[filter_fw removeObject:[sender.associatedObject mtname]];
	}

	[arraySelected removeObject:[sender associatedObjectRetain]];
	[self updateHeaders];
}
-(IBAction)btnMoreTap:(UIButton*)sender{
	if (sender.tag/1000==1) {
		if(sender.selected==NO){
			[arrayPp addObjectsFromArray:[self subArray:arrayAllPp range:NSMakeRange(arrayPp.count, 5)]];
		}else{
			[arrayPp removeAllObjects];
			[arrayPp addObjectsFromArray:[self subArray:arrayAllPp range:NSMakeRange(0, 5)]];
		}
		if (arrayPp.count==arrayAllPp.count) {
			hasMore_pp=UIControlStateSelected;
		}else{
			hasMore_pp=UIControlStateNormal;
		}
	}else if (sender.tag/1000==2){
		if(sender.selected==NO){
			[arrayCl addObjectsFromArray:[self subArray:arrayAllCl range:NSMakeRange(arrayCl.count, 5)]];
		}else{
			[arrayCl removeAllObjects];
			[arrayCl addObjectsFromArray:[self subArray:arrayAllCl range:NSMakeRange(0, 5)]];
		}
		if (arrayCl.count==arrayAllCl.count) {
			hasMore_cl=UIControlStateSelected;
		}else{
			hasMore_cl=UIControlStateNormal;
		}
	}else{
		if(sender.selected==NO){
			[arrayFw addObjectsFromArray:[self subArray:arrayAllFw range:NSMakeRange(arrayFw.count, 5)]];
		}else{
			[arrayFw removeAllObjects];
			[arrayFw addObjectsFromArray:[self subArray:arrayAllFw range:NSMakeRange(0, 5)]];
		}
		if (arrayFw.count==arrayAllFw.count) {
			hasMore_Fw=UIControlStateSelected;
		}else{
			hasMore_Fw=UIControlStateNormal;
		}
	}
	[self updateHeaders];
}


-(void)loadImages
{
	MaterialSearch *s=[MaterialSearch protocolAutoRelease];
	[s requestWithCorpId:filter_pp Scope:filter_fw Mater:filter_cl SusessBlock:^(MaterialList* lParam, id rParam) {
		[arrayImages removeAllObjects];
		[arrayImages addObjectsFromArray:lParam.array];
		[self _loadImages];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}

-(void)_loadImages
{
	scroll.contentInset=UIEdgeInsetsZero;
	NSMutableArray *remove=[NSMutableArray array];
	for (UIView *v in viewImages.subviews) {
		if (v.tag<111111) {
			[remove addObject:v];
		}
	}
	[remove makeObjectsPerformSelector:@selector(removeFromSuperview)];
	CGSize elemenSize=CGSizeMake(scroll.width/3, IS_IPAD()?240:110);
	CGFloat yoffset=30;
	//计算行数
	NSUInteger rows=ceilf(arrayImages.count/3.0);
	for (int i=0; i<rows; i++) {
		for (int j=0; j<3; j++) {
			int index=i*3+j;
			if (arrayImages.count<=index) {
				break;
			}
			Material *c=[arrayImages objectAtIndex:index];
			UIView *container=[[UIView alloc] initWithFrame:CGRectMake(elemenSize.width*j, elemenSize.height*i+yoffset, elemenSize.width, elemenSize.height)];
			if (IS_IPAD()) {
				container.originX=242*j+42;
				container.width=200;
			}
			container.backgroundColor=[UIColor clearColor];
			CGFloat w=IS_IPAD()?200:90;
			UIButton *img=[[UIButton alloc] initWithFrame:CGRectMake(0,0,w,w)];
			[img sd_setBackgroundImageWithURL:URL(c.mpic_small) forState:UIControlStateNormal];
			img.associatedObjectRetain=c;
			img.layer.cornerRadius=4;
			img.layer.masksToBounds=YES;
			[img addTarget:self action:@selector(btnItemTap:) forControlEvents:UIControlEventTouchUpInside];
			UIView *imgc=[[UIView alloc] initWithFrame:CGRectMake((container.width-w)/2, 10,w,w)];
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
			[viewImages addSubview:container];
		}
	}
	viewImages.height=rows*elemenSize.height+20;
	[scroll setContentSize:CGSizeMake(scroll.width, viewImages.originY+viewImages.height)];
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
		UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*scrollPop.width, 0, w,w)];
		img.contentMode=UIViewContentModeScaleAspectFill;
		img.clipsToBounds=YES;
		[img sd_setImageWithURL:URL(mat.mpic) placeholderImage:IMG(@"wu.jpg")];
		
		//UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(0, w+5, w, scrollPop.height-w-15)];
        UITextView *lb=[[UITextView alloc] initWithFrame:CGRectMake(i*scrollPop.width, w+5, w, scrollPop.height-w-15)];
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
