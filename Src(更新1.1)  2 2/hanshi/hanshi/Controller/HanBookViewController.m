//
//  HanBookViewController.m
//  hanshi
//
//  Created by wujin on 14/12/26.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "HanBookViewController.h"
#import "HandBookDetailViewController.h"
@interface HanBookViewController (){
	
    __weak IBOutlet UIImageView *bgImage;
	__weak IBOutlet UILabel *lbName;
    __weak IBOutlet UIImageView *leftBgImage;
	__weak IBOutlet UILabel *lbTitle;
	__weak IBOutlet UIScrollView *scrollContent;
	__weak IBOutlet UIScrollView *scrollDir;
    
    int jilu_Dir_index;
    int testID;
    UILabel*titleLs;
}
@property (nonatomic, strong) NSMutableArray *logoArr;
@end
@interface ProgressView : UIView{
	UILabel *title;
	UIView *prgress;
	CGFloat _progress;
}
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,retain) NSString *hbid;
@property (nonatomic,copy) EventHandler downloadCompleted;
@end

@implementation HanBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self loadDir];
	lbTitle.text=[Config getLoginUser].scorpname;
	lbTitle.hidden=![[Config getLoginUser].ntype isEqualToString:@"3"];
	lbName.text=[Config getLoginUser].xingming;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDir
{
    
    scrollDir.frame=CGRectMake(0, 50, 65, kDScreenHeight);
    scrollContent.frame=CGRectMake(CGRectGetMaxX(scrollDir.frame), 50, kDScreenWidth-CGRectGetMaxX(scrollDir.frame), kDScreenHeight-50-49);
    bgImage.frame=scrollContent.frame;
 
    
    
	Loglist *l=[Loglist protocolAutoRelease];
	[l requestWithUserName:[Config getLoginUser].loginname SusessBlock:^(CorpList* lParam, id rParam) {
		[self _loadDir:lParam.array];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
	
}
-(void)_loadDir:(NSArray*)data
{
    [scrollDir.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.logoArr = [NSMutableArray arrayWithArray:data];
    //左边按钮
    if (data.count==0) {
        
        
        testID=1;
        
        
    }else
    {
        
        testID=0;
        
        for (int i=0;i<data.count;i++) {
            Corp *c=data[i];
            
            
            
            UIView *container=[[UIView alloc] initWithFrame:CGRectMake(0, i*65, 65, 65)];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(btnDirTap:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame= CGRectMake(0,0, 65, 65);
//            if (IS_IPAD()==NO) {
                btn.frame=CGRectCenter(btn.frame, CGSizeMake(45, 45));
//            }
            btn.associatedObjectRetain=c;
            btn.tag = i+100;
            [btn sd_setBackgroundImageWithURL:URL(c.cpic) forState:UIControlStateNormal];
            [container addSubview:btn];
            UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, container.height-1, container.width, 1)];
            line.backgroundColor=[UIColor lightGrayColor];
            [container addSubview:line];
            [scrollDir addSubview:container];
            if (i==0) {
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        [scrollDir setContentSize:CGSizeMake(65, data.count*65)];
        
    }
    
}

-(IBAction)btnDirTap:(UIButton*)sender
{
    jilu_Dir_index = (int)sender.tag-100;
	Corp *c=sender.associatedObjectRetain;
	[self loadContent:c.corpid];
}
-(void)loadContent:(NSString*)corpid
{
	HanbookHbList *l=[HanbookHbList protocolAutoRelease];
	[l requestWithCorpId:corpid userName:[Config getLoginUser].loginname SusessBlock:^(HanBookList* lParam, id rParam) {
		[self _loadContent:lParam];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
-(void)_loadContent:(HanBookList*)images
{
    //右边按钮
    [scrollContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    
    float count=IS_IPAD()?2:1;
    NSUInteger lineCount=ceilf( images.count/count);
    CGFloat xoffset=IS_IPAD()?40: 20;
    CGSize size=CGSizeMake(IS_IPAD()?(scrollContent.width-xoffset*2)/2:200,IS_IPAD()? 384: 400);
    scrollContent.contentSize=CGSizeMake(scrollContent.width, size.height*lineCount*1.0);

    if (images.count==0 || scrollDir.subviews.count == 0) {
        if (scrollDir.subviews.count == 1)
        {
            [scrollDir.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }else
        {
            if (jilu_Dir_index == 0 && self.logoArr.count > 0)
            {
                [self.logoArr removeObject:self.logoArr[0]];
                [self _loadDir:self.logoArr];
                return;
            }
        }
            if (!titleLs) {
                
                titleLs  =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, scrollContent.frame.size.width,30)];
                titleLs.center = scrollContent.center;
            }
       
        titleLs.text=@"您没有可浏览的手册...";
        titleLs.center=CGPointMake(scrollContent.frame.size.width/2, scrollContent.frame.size.height/2);
        titleLs.font=SysFont(17);
        titleLs.textColor=[UIColor colorWithHexString:@"#6b6b6b"];
        titleLs.backgroundColor=[UIColor clearColor];
        titleLs.textAlignment=NSTextAlignmentCenter;
        [scrollContent addSubview:titleLs];

        
        UILabel *titleLs2  =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, scrollContent.frame.size.width,30)];
        titleLs2.text=@"请联系：400-820-2957";
        titleLs2.center=CGPointMake(scrollContent.frame.size.width/2, scrollContent.frame.size.height/2+20);
        titleLs2.font=SysFont(17);
        titleLs2.textColor=[UIColor colorWithHexString:@"#6b6b6b"];
        titleLs2.backgroundColor=[UIColor clearColor];
        titleLs2.textAlignment=NSTextAlignmentCenter;
        [scrollContent addSubview:titleLs2];

        scrollContent.scrollEnabled = NO;
    }else
    {
        scrollContent.scrollEnabled = YES;
        
        for (int i=0; i<lineCount; i++) {
            for (int j=0; j<count; j++) {
                int index=i*count+j;
                if (index>=images.count) {
                    return;
                }
                HanBook *hb=[images objectAtIndex:index];
                CGFloat x=j*size.width+xoffset+((IS_IPAD()&&j==1)?30:8);
                UIView *container=[[UIView alloc] initWithFrame:CGRectMake(x, size.height*i, size.width, size.height)];
                
                
                
                if (IS_IPAD()) {
                    container.originX=(105+187)*j+105;
                }
                UIImageView *bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 10,IS_IPAD()?187: 200,IS_IPAD()?265 : 283)];
                [bg sd_setImageWithURL:URL(hb.hbpic)];
                [container addSubview:bg];
                
                ProgressView *p=[[ProgressView alloc] initWithFrame:bg.frame];
                [container addSubview:p];
                p.hbid=hb.hbid;
                
                //name
                UILabel *lbname=[[UILabel alloc] initWithFrame:CGRectMake(0, bg.originBottomLeft.y+5, 190, 15)];
                lbname.textColor=RGBColor(89, 87, 87);
                lbname.font=[UIFont systemFontOfSize:14];
                lbname.backgroundColor=[UIColor clearColor];
                lbname.text=hb.hbname;
                [container addSubview:lbname];
                //publishtime
                UILabel *lbpb=[[UILabel alloc] initWithFrame:CGRectMake(0, lbname.originBottomLeft.y+5, 190, 15)];
                lbpb.backgroundColor=[UIColor clearColor];
                lbpb.textColor=RGBColor(89, 87, 87);
                lbpb.font=[UIFont systemFontOfSize:12];
                lbpb.text=_S(@"发布日期: %@",hb.fbdate);
                [container addSubview:lbpb];
                //updatetime
                UILabel *lbup=[[UILabel alloc] initWithFrame:CGRectMake(0, lbpb.originBottomLeft.y+5, 190, 15)];
                lbup.font=[UIFont systemFontOfSize:12];
                lbup.text=_S(@"更新日期: %@",hb.gxdate);
                lbup.backgroundColor=[UIColor clearColor];
                lbup.textColor=RGBColor(89, 87, 87);
                [container addSubview:lbup];
                
                //在线阅读
                UIButton *btnOnlie=[UIButton buttonWithType:UIButtonTypeCustom];
                btnOnlie.frame=CGRectMake(20, lbup.originBottomLeft.y+5, 160, 24);
                btnOnlie.associatedObjectRetain=hb;
                btnOnlie.layerCornerRadius=2;
                [btnOnlie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btnOnlie setBackgroundImage:IMG(@"整块深灰色") forState:UIControlStateNormal];
                [btnOnlie setTitle:@"阅读" forState:UIControlStateNormal];
                [container addSubview:btnOnlie];
                btnOnlie.titleLabel.font=[UIFont systemFontOfSize:12];
                [btnOnlie addTarget:self action:@selector(btnDownTap2:) forControlEvents:UIControlEventTouchUpInside];
                
                HandBookMgr *mg=[[HandBookMgr alloc] initWithHandBook:hb];
                if(mg.state==HandBookMgrTypeNone||mg.state==HandBookMgrTypeNeedNew){
                    btnOnlie.width=80;
                    [btnOnlie setBackgroundImage:IMG(@"左侧深灰色") forState:UIControlStateNormal];
                    //更新按钮
                    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame=CGRectMake(btnOnlie.originTopRight.x-1, btnOnlie.originY, 80, 24);
                    btn.associatedObjectRetain=hb;
                    btn.layerCornerRadius=2;
                    btn.titleLabel.font=[UIFont systemFontOfSize:12];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [container addSubview:btn];
                    [btn addTarget:self action:@selector(btnDownTap:) forControlEvents:UIControlEventTouchUpInside];
                    [btn setBackgroundImage:IMG(@"右侧浅灰") forState:UIControlStateNormal];
                    //更新状态
                    if (mg.state==HandBookMgrTypeNeedNew) {
                        [btn setTitle:@"更新" forState:UIControlStateNormal];
                    }else if(mg.state==HandBookMgrTypeNone){
                        [btn setTitle:@"下载" forState:UIControlStateNormal];
                    }
                    p.downloadCompleted=^(id sender){
                        [btn setHidden:YES];
                        btnOnlie.originX=20;
                        [btnOnlie setBackgroundImage:IMG(@"整块深灰色") forState:UIControlStateNormal];
                        [btnOnlie setWidth:160];
                    };
                }
                [scrollContent addSubview:container];
            }
        }
        
        
        
        
        
    }
}
- (IBAction)btnLogoutTap:(UIButton *)sender {
	[DQJKAlertView AlertShow:@"退出" message:@"确认退出吗？" DelegateBlock:^(UIAlertView *alert, NSInteger index) {
		if (index!=alert.cancelButtonIndex) {
			[Config setLoginUser:nil];
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	} cancelButtonTitle:@"取消" otherButtonTitles:@"确认"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)btnDownTap:(UIButton*)sender
{
	HandBookMgr *mgr=[[HandBookMgr alloc] initWithHandBook:sender.associatedObjectRetain];
	dispatch_block_t download=^(){
		HanBookAll *all=[HanBookAll protocolAutoRelease];
		[all requestWithId:mgr.book.hbid SusessBlock:^(id lParam, id rParam) {
			[sender setTitle:@"下载中..." forState:UIControlStateNormal];
			[mgr downloadWithList:lParam];
		} FailBlock:^(id lParam, id rParam) {
			
		}];
	};
	if ([sender.currentTitle isEqualToString:@"阅读"]) {
		HandBookDetailViewController *d=[[HandBookDetailViewController alloc] initWithHandOneBookList:mgr.list hb:mgr hbId:mgr.book.hbid];
		[self.navigationController pushViewController:d animated:YES];
	}else if ([sender.currentTitle isEqualToString:@"更新"]){
		download();
	}else if ([sender.currentTitle isEqualToString:@"下载"]){
		download();
	}else{
		return;
	}
}

-(IBAction)btnDownTap2:(UIButton*)sender
{
	HanBook *hb=sender.associatedObjectRetain;
	HandBookMgr *mgr=[[HandBookMgr alloc] initWithHandBook:hb];
	HanBookAll *all=[HanBookAll protocolAutoRelease];
	[all requestWithId:mgr.book.hbid SusessBlock:^(id lParam, id rParam) {
		HandBookDetailViewController *d=[[HandBookDetailViewController alloc] initWithHandOneBookList:lParam hb:mgr.state==HandBookMgrTypeNew?mgr:nil hbId:hb.hbid];
		[self.navigationController pushViewController:d animated:YES];
	} FailBlock:^(id lParam, id rParam) {
		
	}];

}
@end

@implementation ProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
	self =[super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor clearColor]];
		title=[[UILabel alloc] initWithFrame:self.bounds];
		title.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		title.textAlignment=NSTextAlignmentCenter;
		title.font=[UIFont systemFontOfSize:14];
		title.textColor=[UIColor whiteColor];
		prgress=[[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, 0, 0)];
		prgress.backgroundColor=RGBAColor(0, 0, 0, 0.4);
		[self addSubview:prgress];
		[self addSubview:title];
		self.hidden=YES;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressChanged:) name:kHandBookMgrDownloadProgressChangedNotification object:nil];
	}
	return self;
}
- (void)dealloc
{
	self.downloadCompleted=nil;
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	prgress=nil;
	title=nil;
	self.hbid=nil;
}
-(void)progressChanged:(NSNotification*)note
{
	HandBookMgr *mgr=note.object;
	NSNumber *num=[note.userInfo objectForKey:@"p"];
	if ([self.hbid isEqualToString:mgr.book.hbid]) {
		[self setProgress:num.floatValue];
	}
}
-(CGFloat)progress
{
	return _progress;
}
-(void)setProgress:(CGFloat)progress
{
	if (progress>1) {
		DDLogError(@"progress can't bigger than 1");
	}
	if (progress==1) {
		self.hidden=YES;
		BlockCallWithOneArg(self.downloadCompleted, self);
		return;
	}
	self.hidden=!(progress>0&&progress!=1);
	_progress=progress;
	CGFloat y=self.height*(1-progress);
	CGFloat h=self.height*progress;
	title.text=_S(@"%.0f%%",progress*100);
	[UIView animateWithDuration:0.1 animations:^{
		prgress.frame=CGRectMake(0, y, self.width, h);
	}];
}
@end
