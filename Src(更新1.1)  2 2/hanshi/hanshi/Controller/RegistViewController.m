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
#define FOUT_DOW                   (12.5)
#define FOUT_IPAD                   (12.5)
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
    _scrollView.contentSize=CGSizeMake(kDScreenWidth,kDScreenHeight+200);
    //水平锁定
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.bounces=YES;
    _scrollView.tag = 2000;
    
    [viewSm addSubview:_scrollView];
    
    [_scrollView addSubview:titleL];
    
    NSString *titleStr=@"提示：您的注册信息将经过后台与贵公司注册时的负责人进行核对，审核通过前您可以浏览APP的资讯信息，暂不能浏览标准手册。审核通过后，您可以阅读属于您所在企业的标准化手册。设计师和供应商需要查看手册，需要获得客户许可。\n增值服务需要与本APP签订服务协议的，请联系：400-820-2957";
    
    CGFloat h=[self getSizeOfText:titleStr withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP]+10;
    
    
    UILabel*titleLs=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleL.frame), kDScreenWidth-43, h)];
    titleLs.text=titleStr;
    titleLs.font=SysFont(IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP);
    titleLs.textColor=[UIColor whiteColor];
    titleLs.backgroundColor=[UIColor clearColor];
    
    titleLs.numberOfLines=10;
    titleLs.textAlignment=NSTextAlignmentLeft;
    [_scrollView addSubview:titleLs];
    
//    NSString *titleStr1=@"1. 不可抗力：《合同法》第117条规定，因不可抗力不能履行合同的，根据不可抗力的影响，部分或者全部免除责任，但法律另有规定的除外。当事人迟延履行后发生不可抗力的，不能免除责任。本法所称不可抗力，是指不能预见、不能避免并不能克服的客观情况。\n2. 货物本身的自然性质、货物的合理损耗：见《合同法》第311条。\n3. 债权人的过错：见《合同法》第311条、第370条。";
//    CGFloat h1=[self getSizeOfText:titleStr1 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW];
//    
//    
//    
//    UILabel*titleLs1=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs.frame), kDScreenWidth-43, h1+10)];
//    titleLs1.text=titleStr1;
//    titleLs1.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
//    titleLs1.textColor=[UIColor whiteColor];
//    titleLs1.backgroundColor=[UIColor clearColor];
//    
//    
//    
//    titleLs1.numberOfLines=10;
//    titleLs1.textAlignment=NSTextAlignmentLeft;
//    
//    [_scrollView addSubview:titleLs1];
    
    
    
    
    
    
//    NSString *titleStr2=@"（二）免责条款";
//    CGFloat h2=[self getSizeOfText:titleStr2 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP];
//    UILabel*titleLs2=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs1.frame)+5, kDScreenWidth-10, h2+5)];
//    titleLs2.text=titleStr2;
//    titleLs2.font=SysFont(IS_IPAD()?FOUT_UP+FOUT_IPAD:FOUT_UP);
//    titleLs2.textColor=[UIColor whiteColor];
//    titleLs2.backgroundColor=[UIColor clearColor];
//    
//    titleLs2.numberOfLines=10;
//    titleLs2.textAlignment=NSTextAlignmentLeft;
//    [_scrollView addSubview:titleLs2];
    
    
//    NSString *titleStr3=@"1. 免责条款的概念：免责条款，就是当事人以协议排除或限制其未来责任的合同条款。其一，免责条款是合同的组成部分，是一种合同条款；其二，免责条款的提出必须是明示的，不允许以默示方式作出，也不允许法官推定免责条款的存在。";
//    CGFloat h3=[self getSizeOfText:titleStr3 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW]+20;
//    UILabel*titleLs3=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs2.frame)+5, kDScreenWidth-43,h3)];
//    titleLs3.text=titleStr3;
//    titleLs3.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
//    titleLs3.textColor=[UIColor whiteColor];
//    titleLs3.backgroundColor=[UIColor clearColor];
//    titleLs3.numberOfLines=10;
//    titleLs3.textAlignment=NSTextAlignmentLeft;
//    [_scrollView addSubview:titleLs3];
    
    
    
    
//    NSString *titleStr4=@"2. 免责条款的有效与无效";
//    CGFloat h4=[self getSizeOfText:titleStr4 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW];
//    UILabel*titleLs4=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs3.frame)+5, kDScreenWidth-10, h4)];
//    titleLs4.text=titleStr4;
//    titleLs4.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
//    titleLs4.textColor=[UIColor whiteColor];
//    titleLs4.backgroundColor=[UIColor clearColor];
//    titleLs4.numberOfLines=10;
//    titleLs4.textAlignment=NSTextAlignmentLeft;
//    [_scrollView addSubview:titleLs4];
    
    
    
    
    
    
    
    NSString *titleStr5=@"1、一切移动客户端用户在下载并浏览本APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。\n2、本APP转载的内容并不代表该APP之意见及观点，也不意味着本公司赞同其观点或证实其内容的真实性。 \n3、本APP转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。该APP不提供任何保证，并不承担任何法律责任。\n4、本APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或注册企业负责人承担，本APP对此不承担责任。\n5、本APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由本APP实际控制的任何网页上的内容，本APP不承担任何责任。\n6、注册用户明确并同意其使用本APP网络服务所存在的风险将完全由其本人承担；因其使用本APP网络服务而产生的一切后果也由其本人承担，本APP对此不承担任何责任。\n7、除本APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，本APP概不负责，亦不承担任何法律责任。\n8、对于因不可抗力或因黑客攻击、通讯线路中断等本APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用本APP，本APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n10、本网站相关声明版权及其修改权、更新权和最终解释权均属本APP所有。";
    CGFloat h5=[self getSizeOfText:titleStr5 withWidth: kDScreenWidth-X_VOLE withFont:IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW]+(IS_IPAD()? 150: 250);
    
    UILabel*titleLs5=[[UILabel alloc]initWithFrame:CGRectMake(X_VOLE, CGRectGetMaxY(titleLs.frame), kDScreenWidth-43, h5)];
    titleLs5.text=titleStr5;
    titleLs5.font=SysFont(IS_IPAD()?FOUT_DOW+FOUT_IPAD:FOUT_DOW);
    titleLs5.textColor=[UIColor whiteColor];
    titleLs5.backgroundColor=[UIColor clearColor];
    titleLs5.numberOfLines=10000;
    titleLs5.textAlignment=NSTextAlignmentLeft;
    
    
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:titleStr5];
    NSMutableParagraphStyle *paragraphStyle5 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle5 setLineSpacing:4];//调整行间距
    
    [attributedString5 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle5 range:NSMakeRange(0, [titleStr5 length])];
    titleLs5.attributedText = attributedString5;
    
    [_scrollView addSubview:titleLs5];
    
    
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLs5.frame), 320, 60)];
    bgView.backgroundColor=[UIColor clearColor];
    bgView.center=CGPointMake(kDScreenWidth/2,IS_IPAD() ? CGRectGetMaxY(titleLs5.frame)+20 : CGRectGetMaxY(titleLs5.frame)+20);
    bgView.userInteractionEnabled=YES;
    [_scrollView addSubview:bgView];
    
    
    
    for (int i=0; i<2; i++) {
        
        
        NSArray *imageBnt=@[@"btn_agree.png",@"btn_quit.png"];
        for (int i=0; i<2; i++) {
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            double x=75;
            
            if (i==0) {
            
                button.frame=CGRectMake(IS_IPAD()?10 : x+10,15, IS_IPAD()? 120: 68,30);
            }else
            {
                button.frame=CGRectMake(IS_IPAD() ? 190: 157+10,15,IS_IPAD()? 120 :68,30);
            }
            
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[imageBnt objectAtIndex:i]] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont boldSystemFontOfSize:15];
            button.tag=100+i;
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            
        }
        
        
    }
    
     _scrollView.contentSize=CGSizeMake(kDScreenWidth,kDScreenHeight+400);
    
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
                    AlertShowWithMessage(@"注册成功\n请等待审核");
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
			AlertShowWithMessage(@"注册成功\n 请等待审核");
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