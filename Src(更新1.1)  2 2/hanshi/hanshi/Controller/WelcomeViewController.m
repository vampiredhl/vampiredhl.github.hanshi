//
//  LoginViewController.m
//  hanshi
//
//  Created by wujin on 14/12/20.
//  Copyright (c) 2014年 dqjk. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
}
-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
	//AlertShowWithMessage(self.view.subviews.description);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnGustTap:(id)sender {
	[Config setLoginUser:nil];
	UIViewController *h=[HomeViewController homeController] ;
	[self.navigationController pushViewController:h animated:YES];
}
- (IBAction)btnLoginTap:(id)sender {
	id l=[[LoginViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:l animated:YES];
}

@end
