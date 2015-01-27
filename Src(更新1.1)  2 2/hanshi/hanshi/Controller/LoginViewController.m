//
//  LoginMobileViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>{
	
	__weak IBOutlet UIScrollView *scroll;
	__weak IBOutlet UITextField *tfPasswrod;
	__weak IBOutlet UITextField *tfUserName;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHeightChanged:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHeightChanged:) name:UIKeyboardDidShowNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tfUserName resignFirstResponder];
    [tfPasswrod resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnGetValidateCode:(id)sender {
	if ([tfPasswrod.text isMatchedByRegex:NSStringRegexIsPhoneNumber]==NO) {
		AlertShowWithMessage(@"请输入正确的手机号码");
		return;
	}
	
}
- (IBAction)btnLoginTap:(id)sender {
	if (StringIsNullOrEmpty(tfUserName.text)) {
		AlertShowWithMessage(@"请输入用户名");
		return;
	}
	if (StringIsNullOrEmpty(tfPasswrod.text)) {
		AlertShowWithMessage(@"请输入密码");
		return;
	}
	UserLogin *l=[UserLogin protocolAutoRelease];
	[l requestWithUserName:tfUserName.text Pwd:tfPasswrod.text SusessBlock:^(User* lParam, id rParam) {
		User * u= lParam;
		if ([lParam.returnvalue isEqualToString:@"true"]) {
			UserInfo *info=[UserInfo protocolAutoRelease];
			[info requestWithUserName:tfUserName.text SusessBlock:^(User* lParam, id rParam) {
				lParam.loginname=tfUserName.text;
				lParam.ntype=u.ntype;
				//保存登录的用户
				[Config setLoginUser:lParam];
				id h=[HomeViewController homeController];
				//[self.navigationController popViewControllerAnimated:NO];
				[self.navigationController pushViewController:h animated:YES];
			} FailBlock:NULL];
		}else{
			AlertShowWithMessage(@"用户名或密码错误\n您可能未通过审核请联系\n400-820-2957");
		}
	} FailBlock:^(id lParam, id rParam) {
		AlertShowWithMessage(@"联网失败");
	}];
}
- (IBAction)btnRegistTap:(id)sender {
	UINavigationController *nav=self.navigationController;
	RegistViewController *reg=[[RegistViewController alloc] initWithNibName:nil bundle:nil];
	[nav pushViewController:reg animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)keyboardHeightChanged:(NSNotification*)note
{
    if ([note.name isEqualToString:UIKeyboardDidShowNotification])
    {
        CGRect f=[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
       
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            
           self.view.originY=f.origin.y-self.view.height+60;
            
        }];
    }else
    {
        CGRect f=[[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            
           self.view.originY=f.origin.y-self.view.height;
            
        }];
        
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	if ([string isEqual:@"\n"]) {
		[textField resignFirstResponder];
		return NO;
	}
	return YES;
}
@end
