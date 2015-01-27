//
//  UserInfoViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>{
	
	__weak IBOutlet UIButton *btnHead;
	__weak IBOutlet UILabel *labeComp;
	__weak IBOutlet UILabel *labelJob;
	__weak IBOutlet UILabel *labelName;
	__weak IBOutlet UITextField *labePhone;
	__weak IBOutlet UITextField *labelEmail;
	__weak IBOutlet UIView *viewShadow;
	__weak IBOutlet UIView *viewShadow2;

    __weak IBOutlet UIButton *changeBtn;

    __weak IBOutlet UIButton *goOutBtn;


}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    // Do any additional setup after loading the view from its nib.
	viewShadow.layer.shadowOffset=CGSizeMake(1, 1);
	viewShadow.layer.shadowOpacity=0.5;
	viewShadow.layer.shadowColor=[UIColor blackColor].CGColor;
	viewShadow2.layer.shadowOffset=CGSizeMake(1, 1);
	viewShadow2.layer.shadowOpacity=0.5;
	viewShadow2.layer.shadowColor=[UIColor blackColor].CGColor;
	[self loadUserInfo];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kebchanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    
    changeBtn.layer.masksToBounds=YES;
    changeBtn.layer.cornerRadius=2;

    goOutBtn.layer.masksToBounds=YES;
    goOutBtn.layer.cornerRadius=2;
    
    
    
}




- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)loadUserInfo
{
	User *u=[Config getLoginUser];
	[btnHead sd_setBackgroundImageWithURL:URL(u.upic) forState:UIControlStateNormal];
	labelName.text=_S(@"姓名： %@",u.xingming);
	NSString *str=u.ntype;
	//1：客户，2：设计师，3：供应商
	if (StringIsNullOrEmpty(str)) {
		str=@"暂无";
	}else if ([str isEqualToString:@"1"]){
		str=@"客户";
	}else if ([str isEqualToString:@"2"]){
		str=@"设计师";
	}else{
		str=@"供应商";
	}
    str = [self isNullString:str]?@"":str;
	labeComp.text=_S(@"职务： %@",str );
	labelJob.text=_S(@"公司： %@",u.corpname);
	labePhone.text=_S(@"%@",u.mobile);
	labelEmail.text=_S(@"%@",u.email);
}
#pragma mark =============判断一个字符串是否为空==================
-(BOOL)isNullString:(NSString *)tempString{
    if ((tempString == nil) || (tempString == NULL) || ([tempString isEqualToString:@""])||([tempString isEqualToString:@"<null>"])||([tempString isEqual:[NSNull null]])) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisAppear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.view endEditing:YES];
}

- (IBAction)btnHeadTap:(id)sender {
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.delegate=self;
	picker.allowsEditing=YES;
	[self presentViewController:picker animated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img=[info objectForKey:UIImagePickerControllerEditedImage];
	NSData *d = UIImageJPEGRepresentation(img, 0.7);
	NSString *fn=_S(@"%@head.jpg",NSTemporaryDirectory());
	[d writeToFile:fn atomically:YES];
	[btnHead setBackgroundImage:img forState:UIControlStateNormal];
	User *u=[Config getLoginUser];
	
    UserUploaduserpic *up=	[UserUploaduserpic protocolAutoRelease];
	[up requestWithUserId:[Config getLoginUser].loginname pic:fn SusessBlock:^(id lParam, id rParam) {
		u.upic=lParam;
		[Config setLoginUser:u];
	} FailBlock:^(id lParam, id rParam) {
		AlertShowWithMessage(@"联网失败");
	}];
	[picker dismissViewControllerAnimated:YES completion:NULL];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)kebchanged:(NSNotification*)note
{
    CGRect frame=[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        
       self.view.window.originY=-(self.view.height-frame.origin.y);
  
        
    }];
    

    
	
	
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([labePhone isFirstResponder])
        [labePhone resignFirstResponder];
    if ([labelEmail isFirstResponder])
        [labelEmail resignFirstResponder];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqual:@"\n"]) {
		[textField resignFirstResponder];
		return NO;
	}
	return YES;
}
- (IBAction)btnEditTap:(UIButton*)sender {
    if ([sender.currentTitle isEqualToString:@"退出登录"])
    {
        [self.j showCenterPanelAnimated:NO];
        UINavigationController *nav=self.j.centerPanel.navigationController;
        UITextField *name = [[nav.viewControllers[2] view] viewWithTag2:1001];
        name.text = nil;
        name = [[nav.viewControllers[2] view] viewWithTag2:1002];
        name.text = nil;
        [self.j.centerPanel.navigationController popViewControllerAnimated:YES];
        return;
    }
	if (sender.selected==NO) {
		labePhone.borderStyle=UITextBorderStyleRoundedRect;
		[labePhone becomeFirstResponder];
        labelEmail.borderStyle=UITextBorderStyleRoundedRect;
//        [labelEmail becomeFirstResponder];
	}else{
		[labePhone resignFirstResponder];
		labePhone.borderStyle=UITextBorderStyleNone;
        [labelEmail resignFirstResponder];
        labelEmail.borderStyle=UITextBorderStyleNone;
		UserInfoupd *up=[UserInfoupd protocolAutoRelease];
        
		[up requestWithName:[Config getLoginUser].loginname Mobile:labePhone.text SusessBlock:^(id lParam, id rParam) {
			
		} FailBlock:^(id lParam, id rParam) {
			
		}];
        [up requestWithName:[Config getLoginUser].loginname Email:labelEmail.text SusessBlock:^(id lParam, id rParam) {
            
        } FailBlock:^(id lParam, id rParam) {
            
        }];
	}
	sender.selected=!sender.selected;
}
@end
