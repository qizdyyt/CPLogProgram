//
//  HBAdminViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBAdminViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HBCommonUtil.h"
#import "HBVerifyViewController.h"
#import "HBServerInterface.h"
#import "ToastUIView.h"
#import "HBOnlineBusiness.h"
#import "HBMiddleWare.h"
#import "HBMLogLoginViewController.h"

@interface HBAdminViewController ()

@end

@implementation HBAdminViewController
{
    UITextField *userNameTF;
    UITextField *passwordTF;
    UITextField *passwordReTF;
//    UITextField *userNameTF;
    UITextField *companyTF;
    UITextField *phoneNumTF;
    UITextField *verifyCodeTF;
    CGSize baseSize;
    CGFloat cellHeight;
    
    HBServerConnect *serverConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.baseView.layer.cornerRadius = 8.0;
    
    userNameTF =  [[UITextField alloc] init];
    userNameTF.textAlignment = NSTextAlignmentCenter;
    userNameTF.returnKeyType = UIReturnKeyNext;
    userNameTF.delegate = self;
    userNameTF.tag = 0;
    
    passwordTF =   [[UITextField alloc] init];
    passwordTF.textAlignment = NSTextAlignmentCenter;
    passwordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordTF.returnKeyType = UIReturnKeyNext;
    passwordTF.secureTextEntry = YES;
    passwordTF.delegate = self;
    passwordTF.tag = 1;
    
    passwordReTF = [[UITextField alloc] init];
    passwordReTF.textAlignment = NSTextAlignmentCenter;
    passwordReTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordReTF.returnKeyType = UIReturnKeyNext;
    passwordReTF.secureTextEntry = YES;
    passwordReTF.delegate = self;
    passwordReTF.tag = 2;
    
//    userNameTF =   [[UITextField alloc] init];
//    userNameTF.textAlignment = NSTextAlignmentCenter;
//    userNameTF.returnKeyType = UIReturnKeyNext;
//    userNameTF.delegate = self;
//    userNameTF.tag = 3;
    
    companyTF =    [[UITextField alloc] init];
    companyTF.textAlignment = NSTextAlignmentCenter;
    companyTF.returnKeyType = UIReturnKeyNext;
    companyTF.delegate = self;
    companyTF.tag = 3;
    
    phoneNumTF =   [[UITextField alloc] init];
    phoneNumTF.textAlignment = NSTextAlignmentCenter;
    phoneNumTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    phoneNumTF.returnKeyType = UIReturnKeyNext;
    phoneNumTF.delegate = self;
    phoneNumTF.tag = 4;
    
    verifyCodeTF = [[UITextField alloc] init];
    verifyCodeTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    verifyCodeTF.returnKeyType = UIReturnKeyDone;
    verifyCodeTF.delegate = self;
    verifyCodeTF.tag = 5;
    
    baseSize = self.baseView.frame.size;
    serverConnect = [[HBServerConnect alloc] init];
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize tableviewframe = self.tableview.frame.size;
    
    if (tableviewframe.height > 200) {
        self.tableview.scrollEnabled = NO;
        cellHeight = tableviewframe.height/5;
    } else {
        cellHeight = 40;
        self.tableview.scrollEnabled = YES;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CertIdentifier = [NSString stringWithFormat:@"CellIdentifier%ld", (long)[indexPath row]];
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CertIdentifier];
    }
    
    CGSize cellSize = CGSizeMake(baseSize.width - 4, cellHeight);
    CGRect textFrame = CGRectMake(8, 8, cellSize.width-16, cellSize.height-8);
    
    switch (indexPath.row) {
        case 0:{
            userNameTF.frame = textFrame;
            userNameTF.placeholder = @"输入用户名";
            [cell addSubview:userNameTF];
            break;
        }
            
        case 1:{
            passwordTF.frame = textFrame;
            passwordTF.placeholder = @"输入密码";
            [cell addSubview:passwordTF];
            break;
        }
            
        case 2:{
            passwordReTF.frame = textFrame;
            passwordReTF.placeholder = @"确认密码";
            [cell addSubview:passwordReTF];
            break;
        }
            
//        case 3:{
//            userNameTF.frame = textFrame;
//            userNameTF.placeholder = @"您的姓名";
//            [cell addSubview:userNameTF];
//            break;
//        }
            
        case 3:{
            companyTF.frame = textFrame;
            companyTF.placeholder = @"企业名称";
            [cell addSubview:companyTF];
            break;
        }
            
        case 4:{
            phoneNumTF.frame = textFrame;
            phoneNumTF.placeholder = @"手机号码";
            [cell addSubview:phoneNumTF];
            break;
        }
            
        case 5:{
            UIButton *sendMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, (cellHeight-30)/2, 100, 30)];
            [sendMsgBtn setImage:[UIImage imageNamed:@"btn_send_msg_word"] forState:UIControlStateNormal];
            [sendMsgBtn addTarget:self action:@selector(sendMsgBtnPressed) forControlEvents:UIControlEventTouchDown];
            
            verifyCodeTF.frame = CGRectMake(cellSize.width/2, 0, cellSize.width/2-4, cellHeight);
            verifyCodeTF.placeholder = @"请输入验证码";
            [cell addSubview:sendMsgBtn];
            [cell addSubview:verifyCodeTF];
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)allTextfieldResignResponder
{
    [userNameTF resignFirstResponder];
    [passwordTF resignFirstResponder];
    [passwordReTF resignFirstResponder];
//    [userNameTF resignFirstResponder];
    [companyTF resignFirstResponder];
    [phoneNumTF resignFirstResponder];
    [verifyCodeTF resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
    [self allTextfieldResignResponder];
}


//点击发送短信按钮
- (void)sendMsgBtnPressed
{
    [self allTextfieldResignResponder];
    
    NSString *phoneNum = phoneNumTF.text;
    if (IS_NULL_STRING(phoneNum)) {
        [self.view makeToast:@"手机号码不能为空"];
        return;
    }
    if (![phoneNum checkPhoneNumInput]) {
        [self.view makeToast:@"您输入手机号有误，请重新输入"];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"发送请求...";
    hud.delegate = self;
    [self.view addSubview:hud];
    
    //[hud showAnimated:YES whileExecutingBlock:<#^(void)block#>];
    [hud showWhileExecuting:@selector(requestVerifyMessage) onTarget:self withObject:nil animated:YES];
}

//发送验证短信
- (void)requestVerifyMessage
{
    NSString *phoneNum = phoneNumTF.text;
    NSString *deviceID = [HBCommonUtil getDeviceIdentifier];
    
    [serverConnect requestVerifyCodeWithPhone:phoneNum devID:deviceID];
}

//点击注册按钮
- (IBAction)registBtnPressed:(id)sender {
    [self allTextfieldResignResponder];
    
    //输入合法性检查
    NSString *errorMsg = [self checkInputs];
    if (errorMsg) {
        [self.view makeToast:errorMsg];
        return;
    }
    //加了手机号检测，没有走验证码逻辑
    NSString *phoneNum = phoneNumTF.text;
    if (IS_NULL_STRING(phoneNum)) {
        [self.view makeToast:@"手机号码不能为空"];
        return;
    }
    if (![phoneNum checkPhoneNumInput]) {
        [self.view makeToast:@"您输入手机号有误，请重新输入"];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在注册";
    HBUserConfig *user = [[HBUserConfig alloc] init];
    user.userName = userNameTF.text;
    user.password = passwordTF.text;
    user.phoneNumber = phoneNumTF.text;
    user.companyID = companyTF.text;
    [user registerToServer:^(bool isOK, NSString *msg) {
        [hud hide:YES];
        if (isOK) {
            [self dismissViewControllerAnimated:true completion:^{
                if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(handleRegist:)]) {
                    [self.delegate handleRegist:user];
                }
            }];
        } else {
            [QMUITips showWithText:[NSString stringWithFormat:@"注册失败：%@", msg] inView:self.view hideAfterDelay:1];
            
        }
    }];
}

- (NSString *)checkInputs
{
    NSString *erroMsg = nil;
    
    //登录名
    if (IS_NULL_STRING(userNameTF.text)) {
        erroMsg = @"登录名不能为空";
    }
    
    //密码
    else if (IS_NULL_STRING(passwordTF.text)) {
        erroMsg = @"密码不能为空";
    }
    else if (IS_NULL_STRING(passwordReTF.text)) {
        erroMsg = @"确认密码不能为空";
    }
    else if (![passwordTF.text isEqualToString:passwordReTF.text]) {
        erroMsg = @"两次密码不相同";
    }
    else if (passwordTF.text.length < 4 || passwordTF.text.length > 25) {
        erroMsg = @"密码长度为4~25";
    }
    else if (![passwordTF.text checkPassword]) {
        erroMsg = @"密码只能由英文字母、数字或下划线组成";
    }
    
    //姓名
//    else if (IS_NULL_STRING(userNameTF.text)) {
//        erroMsg = @"姓名不能为空";
//    }
    //企业名称
    else if (IS_NULL_STRING(companyTF.text)) {
        erroMsg = @"企业名称不能为空";
    }
    //验证码
//    else if (IS_NULL_STRING(verifyCodeTF.text)) {
//        erroMsg = @"验证码不能为空";
//    }
//    else if (verifyCodeTF.text.length != 6) {
//        erroMsg = @"验证码长度错误";
//    }
    
    return erroMsg;
}


#pragma textfield
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    switch (textField.tag) {
        case 0:
            [passwordTF becomeFirstResponder];
            break;
            
        case 1:
            [passwordReTF becomeFirstResponder];
            break;
            
//        case 2:
//            [userNameTF becomeFirstResponder];
//            break;
//
        case 2:
            [companyTF becomeFirstResponder];
            break;
            
        case 3:
            [phoneNumTF becomeFirstResponder];
            break;
            
        default:
            break;
    }
    
    
    return YES;
}

@end
