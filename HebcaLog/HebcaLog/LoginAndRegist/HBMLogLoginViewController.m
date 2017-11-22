//
//  HBMLogLoginViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBMLogLoginViewController.h"
//#import "HBRegistViewController.h"

#import "HBHomepageViewController.h"
#import "HBCommonUtil.h"
#import "HBServerConnect.h"
#import "HBServerInterface.h"
#import "ToastUIView.h"

#import "QMUIKit.h"
#import "HBAttendInfoViewController.h"
//#import "HBLocationViewController.h"

@interface HBMLogLoginViewController()
@property (nonatomic, assign) bool loginSuccess;
@property (nonatomic, strong) HBUserConfig* user;

@end

@implementation HBMLogLoginViewController
{
    NSMutableArray *_popViewOptions;
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.user = [[HBUserConfig alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
}


#pragma mark - UITextFieldViewDelegate

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backGroundTouched:(id)sender {
    [self.loginNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (IBAction)registBtnPressed:(id)sender {
    HBAdminViewController *registViewControl = [[HBAdminViewController alloc] init];
    registViewControl.delegate = self;
    [self presentViewController:registViewControl animated:YES completion:nil];
}

-(void)handleRegist:(HBUserConfig *)user {
    self.user = user;
    [self.loginNameTF setText:user.userName];
    [self.passwordTF setText:user.password];
    [QMUITips showWithText:@"注册成功" inView:self.view hideAfterDelay:1];
}

- (IBAction)loginButtonPressed:(id)sender {
    //验证用户名
    if (self.loginNameTF.text == nil || 0 == [self.loginNameTF.text length])
    {
        [self.view makeToast:@"请输入用户名"];
        return;
    }
    //本地验证密码
    if (self.passwordTF.text == nil || 0 == [self.passwordTF.text length])
    {
        [self.view makeToast:@"请输入您的密码"];
        return;
    }
    //开始登陆
    self.user.userName = self.loginNameTF.text;
    self.user.password = self.passwordTF.text;
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    hud.labelText = @"正在登录";
    [self.user login:^(bool isOK, NSString *msg) {
        if (isOK) {
            self.loginSuccess = isOK;
            [hud hide:YES];
            [QMUITips showWithText:@"登录成功" inView:self.view hideAfterDelay:1];
            //登录
            HBHomepageViewController *homepageControl = [[HBHomepageViewController alloc] init];
            [self.navigationController pushViewController:homepageControl animated:YES];
            [UserDefaultTool recordPasswordToDefaults:self.passwordTF.text];
            [UserDefaultTool upDateUserLoginState:YES];
            [UserDefaultTool updateUserConfig:self.user];
        }else {
            self.loginSuccess = isOK;
            [hud hide:YES];
            [QMUITips showWithText:@"登录失败" inView:self.view hideAfterDelay:1];
        }
    }];
    
}

- (IBAction)resetButtonPressed:(id)sender {
    
}

- (NSString *)certLogin {//方法已删
    return nil;
}


@end
