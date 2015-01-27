//
//  RegistViewController.m
//  hanshi
//
//  Created by wujin on 14/12/23.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "RegistViewController.h"
#import "UILabel+CreatLable.h"

#define FOUT_UP                    (12.5)
#define FOUT_DOW                   (11.5)
#define FOUT_IPAD                   (10.0)
#define X_VOLE                      (22)
@interface RegistViewController ()<UITableViewDataSource,UITableViewDelegate>{
	
    __weak IBOutlet UILabel *titleL;
	IBOutlet UIView *viewSm;
	__weak IBOutlet UIView *viewId;
	__weak IBOutlet UIScrollView *scroll;
	__weak IBOutlet UITextField *tfId;
	__weak IBOutlet UILabel *lbId;
	__weak IBOutlet UIView *view1;
	__weak IBOutlet UIView *viewEmail;
	__weak IBOutlet UILabel *lbEmail;
	__weak IBOutlet UITextField *tfPwd;
	__weak IBOutlet UIView *viewType;
	__weak IBOutlet UIView *viewName;
	__weak IBOutlet UITextField *tfEmail;
	__weak IBOutlet UITextField *tfUserName;
	__weak IBOutlet UIView *viewUserName;
	__weak IBOutlet UIView *viewJob;
	__weak IBOutlet UITextField *tfJob;
	__weak IBOutlet UITextField *tfPhone;
	__weak IBOutlet UIButton *btnNext;
	__weak IBOutlet UIView *viewPhone;
	__weak IBOutlet UIButton *btnSelectType;
	IBOutlet UIView *viewTypeSelect;
	__weak IBOutlet UIButton *btnCompName;
	NSMutableArray *companys;
	IBOutlet UITableView *tableCompanys;
      UIScrollView *_scrollView;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIControl *tap = [[UIControl alloc]initWithFrame:self.view.bounds ];
    [tap addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchDown];
    [scroll insertSubview:tap belowSubview:viewId];
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTap:)];
//    [scroll addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    scroll.contentSize=CGSizeMake(self.view.width,IS_IPAD()?1024: 668);
    companys=[NSMutableArray array];
    
    
 
    
    
    
}
-(void)bgTap:(UIControl *)tap
{
    [tfEmail resignFirstResponder];
    [tfId resignFirstResponder];
    [tfJob resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tfPwd resignFirstResponder];
    [tfUserName resignFirstResponder];
}

- (void)creatUI
{
    titleL.text=@"负责声明";
    
    if (IS_IPAD()) {
        
        
        titleL.font=SysFont(25);
        
    }else
    {
         titleL.font=SysFont(17);
    }
    //创建滚动试图
    _scrollView =[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize=CGSizeMake(kDScreenWidth,kDScreenHeight+10);
    //水平锁定
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.bounces=YES;
    _scrollView.tag = 2000;
    
    [viewSm addSubview:_scrollView];
    
    [_scrollView addSubview:titleL];
    
    NSString *titleStr=@"（一）免责条件：即法律明文规定的当事人对其不履行合同不承担违约责任的条件。我国法律规定的免责条件主要有：";
    
    CGFloat h=[self getSizeOfText:titleStr withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP]+10;
    
    
    UILabel*titleLs=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleL.frame), kDScreenWidth-43, h)];
    titleLs.text=titleStr;
    titleLs.font=SysFont(IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP);
    titleLs.textColor=[UIColor whiteColor];
    titleLs.backgroundColor=[UIColor clearColor];
    
    titleLs.numberOfLines=10;
    titleLs.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:titleLs];
    
    NSString *titleStr1=@"1. 不可抗力：《合同法》第117条规定，因不可抗力不能履行合同的，根据不可抗力的影响，部分或者全部免除责任，但法律另有规定的除外。当事人迟延履行后发生不可抗力的，不能免除责任。本法所称不可抗力，是指不能预见、不能避免并不能克服的客观情况。\n2. 货物本身的自然性质、货物的合理损耗：见《合同法》第311条。\n3. 债权人的过错：见《合同法》第311条、第370条。";
    CGFloat h1=[self getSizeOfText:titleStr1 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW];
    
    
    
    UILabel*titleLs1=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs.frame), kDScreenWidth-43, h1+10)];
    titleLs1.text=titleStr1;
    titleLs1.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
    titleLs1.textColor=[UIColor whiteColor];
    titleLs1.backgroundColor=[UIColor clearColor];
    
    
    
    titleLs1.numberOfLines=10;
    titleLs1.textAlignment=NSTextAlignmentLeft;
    
    [_scrollView addSubview:titleLs1];
    
    
    
    
    
    
    NSString *titleStr2=@"（二）免责条款";
    CGFloat h2=[self getSizeOfText:titleStr2 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP];
    UILabel*titleLs2=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs1.frame)+5, kDScreenWidth-10, h2+5)];
    titleLs2.text=titleStr2;
    titleLs2.font=SysFont(IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP);
    titleLs2.textColor=[UIColor whiteColor];
    titleLs2.backgroundColor=[UIColor clearColor];
    
    titleLs2.numberOfLines=10;
    titleLs2.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:titleLs2];
    
    
    NSString *titleStr3=@"1. 免责条款的概念：免责条款，就是当事人以协议排除或限制其未来责任的合同条款。其一，免责条款是合同的组成部分，是一种合同条款；其二，免责条款的提出必须是明示的，不允许以默示方式作出，也不允许法官推定免责条款的存在。";
    CGFloat h3=[self getSizeOfText:titleStr3 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW]+20;
    UILabel*titleLs3=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs2.frame)+5, kDScreenWidth-43,h3)];
    titleLs3.text=titleStr3;
    titleLs3.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
    titleLs3.textColor=[UIColor whiteColor];
    titleLs3.backgroundColor=[UIColor clearColor];
    titleLs3.numberOfLines=10;
    titleLs3.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:titleLs3];
    
    
    
    
    NSString *titleStr4=@"2. 免责条款的有效与无效";
    CGFloat h4=[self getSizeOfText:titleStr4 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW];
    UILabel*titleLs4=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs3.frame)+5, kDScreenWidth-10, h4)];
    titleLs4.text=titleStr4;
    titleLs4.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
    titleLs4.textColor=[UIColor whiteColor];
    titleLs4.backgroundColor=[UIColor clearColor];
    titleLs4.numberOfLines=10;
    titleLs4.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:titleLs4];
    
    
    
    
    
    
    
    NSString *titleStr5=@"（1）基于现行法的规定确定免责条款的有效或者无效。免责条款以意思表示为要素，以排除或限制当事人的未来责任为目的，因而属于一种民事行为，应受《合同法》第52条、第53条、第54条、第47条、第48条、第51条和第40条的规定调整 。\n（2）基于风险分配理论确定免责条款的有效或者无效 \n（3）根据过错程度确定免责条款的有效或者无效，《合同法》第40条、第53条。";
    CGFloat h5=[self getSizeOfText:titleStr5 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW]+50;
    
    UILabel*titleLs5=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs4.frame), kDScreenWidth-43, h5)];
    titleLs5.text=titleStr5;
    titleLs5.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
    titleLs5.textColor=[UIColor whiteColor];
    titleLs5.backgroundColor=[UIColor clearColor];
    titleLs5.numberOfLines=15;
    titleLs5.textAlignment=NSTextAlignmentLeft;
    
    
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:titleStr5];
    NSMutableParagraphStyle *paragraphStyle5 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle5 setLineSpacing:4];//调整行间距
    
    [attributedString5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle5 range:NSMakeRange(0, [titleStr5 length])];
    titleLs5.attributedText = attributedString5;
    
    [_scrollView addSubview:titleLs5];
    
    
    
    
    
    
    for (int i=0; i<2; i++) {
        
        
        NSArray *imageBnt=@[@"btn_agree.png",@"btn_quit.png"];
        for (int i=0; i<2; i++) {
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
           
            if (IS_IPAD()) {
                
                 button.frame=CGRectMake(CGRectGetMidX(titleL.frame)-250+350*i,kDScreenHeight- 100, 145,60);
            }else
            {
                 button.frame=CGRectMake(CGRectGetMidX(titleL.frame)-132+190*i,kDScreenHeight- 50, 145/2,60/2);
            }
            
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[imageBnt objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont boldSystemFontOfSize:15];
            button.tag=100+i;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
        }
        
        
    }
}

- (void)btnClick:(UIButton *)button
{
    int tag=(int)button.tag-100;
    switch (tag) {
        case 0:
        {
            UserRegist *reg=[UserRegist protocolAutoRelease];
            [reg requestWithName:tfId.text Pwd:tfPwd.text XingMing:tfUserName.text Post:tfJob.text Email:tfEmail.text Mobile:tfPhone.text Type:_S(@"%zd",btnSelectType.tag) CorpId:btnCompName.associatedObjectRetain SusessBlock:^(NSString* lParam, id rParam) {
                if ([lParam isEqualToString:@"true"]) {
                    AlertShowWithMessage(@"注册成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    AlertShowWithMessage(@"注册失败");
                }
                
            } FailBlock:^(id lParam, id rParam) {
                
            }];
        }
            break;
        case 1:
        {
             [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}


//适应高度
-(CGFloat)getSizeOfText:(NSString *)text withWidth:(CGFloat)width withFont:(int)font{
    
    UIFont * tfont = [UIFont systemFontOfSize:font];
    
    CGSize size =CGSizeMake(width,MAXFLOAT);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize  actualsize;
    
    if (IOS7) {
        
        actualsize =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
        
    }else
    {
        NSAttributedString *ser=[[NSAttributedString alloc]initWithString:text];
        actualsize = [ser boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
    
    return actualsize.height;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
	companys=nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
static int flag = 0;
-(void)keyboardChanged:(NSNotification*)note
{
    if ([tfJob isFirstResponder] || [tfPhone isFirstResponder] || [tfUserName isFirstResponder])
    {
        flag = 1;
        if ([note.name isEqualToString:UIKeyboardDidShowNotification])
        {
            [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                
                scroll.originY= 0;
                
            }];
        }else
        {
            CGRect f=[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            
            [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                
                scroll.originY=f.origin.y-scroll.height+80;
                
            }];
        }
    }else
    {
        if (flag == 1)
        {
            flag = 2;
            if ([note.name isEqualToString:UIKeyboardDidShowNotification])
            {
                [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                    
                    scroll.originY=0;
                    
                }];
            }else
            {                
                [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
                    
                    scroll.originY=0;
                    
                }];
            }
        }
    }
    
}
-(void)setAvaiable:(NSString*)str label:(UILabel*)lb
{
	if ([str isEqual:@"none"]) {
		NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"请填写"];
		[str setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, str.length)];
		[lb setAttributedText:str];
		btnNext.enabled=NO;
		return;
	}
	if ([str isEqualToString:@"noexists"]) {
		NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"可用"];
		[str setAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} range:NSMakeRange(0, str.length)];
		[lb setAttributedText:str];
		btnNext.enabled=YES;
	}else{
		NSMutableAttributedString *str=[[NSMutableAttributedString alloc] initWithString:@"已存在"];
		[str setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, str.length)];
		[lb setAttributedText:str];
		btnNext.enabled=NO;
	}
}
-(void)textFieldEndEditing:(NSNotification*)note
{
	if (note.object==tfId) {
		if (StringIsNullOrEmpty(tfId.text)) {
			[self setAvaiable:@"none" label:lbId];
			return;
		}
		//check id
		UserCheckUName *c=[UserCheckUName protocolAutoRelease];
		[c requestWithName:tfId.text SusessBlock:^(id lParam, id rParam) {
			[self setAvaiable:lParam label:lbId];
		} FailBlock:^(id lParam, id rParam) {
			
		}];
	}
}
-(void)textFieldChanged:(NSNotification *)note
{
	
}
- (IBAction)btnNext:(id)sender {
	if(StringIsNullOrEmpty(tfId.text)){
		AlertShowWithMessage(@"请输入用户ID");
		return;
	}
	if (StringIsNullOrEmpty(tfEmail.text)) {
		AlertShowWithMessage(@"请输入邮箱");
		return;
	}
	if (StringIsNullOrEmpty(btnSelectType.currentTitle)) {
		AlertShowWithMessage(@"请选择类型");
		return;
	}
	if (StringIsNullOrEmpty(btnCompName.currentTitle)) {
		AlertShowWithMessage(@"请选择公司");
		return;
	}
	if (StringIsNullOrEmpty(tfUserName.text)) {
		AlertShowWithMessage(@"请输入姓名");
		return;
	}
	if (StringIsNullOrEmpty(tfPhone.text)) {
		AlertShowWithMessage(@"请输入电话");
		return;
	}
	if (StringIsNullOrEmpty(tfJob.text)) {
		AlertShowWithMessage(@"请输入职位");
		return;
	}
	if (StringIsNullOrEmpty(tfPwd.text)) {
		AlertShowWithMessage(@"请输入密码");
		return;
	}
    
    
    [viewSm removeFromSuperview];
    viewSm.frame=self.view.bounds;
    
    
    [self creatUI];
    
    [self.view addSubview:viewSm];

    
    
	
}
- (IBAction)btnTypeTap:(UIButton*)sender {
	[viewTypeSelect removeFromSuperview];
	viewTypeSelect.originY=sender.superview.originY+20;
	viewTypeSelect.originX=sender.superview.originX;
	[scroll addSubview:viewTypeSelect];
	[self hiddenViews:4];
}
- (IBAction)btnNameTap:(UIButton*)sender {
	[tableCompanys removeFromSuperview];
	tableCompanys.originX=sender.superview.originX;
	tableCompanys.originY=sender.superview.originY+20;
	[scroll addSubview:tableCompanys];
}
- (IBAction)btnSelectTypeTap:(UIButton*)sender {
	btnSelectType.tag=sender.tag;
	[btnSelectType setTitle:sender.currentTitle forState:UIControlStateNormal];
	[viewTypeSelect removeFromSuperview];
	[self loadNames:sender.tag];
}
-(void)loadNames:(NSInteger)tag
{
	CorpCorpbyType *c=[CorpCorpbyType protocolAutoRelease];
	[c requestWithType:_S(@"%zd",tag) SusessBlock:^(id lParam, id rParam) {
		[companys removeAllObjects];
		[companys addObjectsFromArray:lParam];
		[tableCompanys reloadData];
		[self showViews:4 Other:NO];
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return companys.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * reuse=@"adadsfafd";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
	if (cell==nil) {
		cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
	}
	Corp *c=companys[indexPath.row];
	cell.textLabel.text=c.corpname;
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[tableView removeFromSuperview];
	Corp *c=companys[indexPath.row];
	btnCompName.associatedObjectRetain=c.corpid;
	[btnCompName setTitle:c.corpname forState:UIControlStateNormal];
}

-(void)showViews:(NSInteger)tag Other:(BOOL)other
{
	for (UIView *v in scroll.subviews) {
		if (v.tag==tag) {
			v.hidden=NO;
		}else if (v.tag>tag){
			v.hidden=other;
		}
	}
}
-(void)hiddenViews:(NSInteger)tag
{
	for (UIView *v in scroll.subviews) {
		if (v.tag>=tag){
			v.hidden=YES;
		}
	}
}
- (IBAction)btnRegTap:(id)sender {
	UserRegist *reg=[UserRegist protocolAutoRelease];
	[reg requestWithName:tfId.text Pwd:tfPwd.text XingMing:tfUserName.text Post:tfJob.text Email:tfEmail.text Mobile:tfPhone.text Type:_S(@"%zd",btnSelectType.tag) CorpId:btnCompName.associatedObjectRetain SusessBlock:^(NSString* lParam, id rParam) {
		if ([lParam isEqualToString:@"true"]) {
			AlertShowWithMessage(@"注册成功");
			[self.navigationController popViewControllerAnimated:YES];
		}else{
			AlertShowWithMessage(@"注册失败");
		}
		
	} FailBlock:^(id lParam, id rParam) {
		
	}];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if ([string isEqual:@"\n"]) {
		[textField resignFirstResponder];
		return NO;
	}
	return YES;
}
@end