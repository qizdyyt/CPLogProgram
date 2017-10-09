//
//  HBRegistViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBRegistViewController.h"
#import "HBHomepageViewController.h"
#import "HBVerifyViewController.h"
#import "HBServerInterface.h"
#import "HBServerConfig.h"
#import "HBOnlineBusiness.h"
#import "HBMiddleWare.h"
#import "HBCommonUtil.h"
#import "ToastUIView.h"

@interface HBRegistViewController ()

@end

@implementation HBRegistViewController
{
    HBOnlineBusiness *onlineBusiness;
    NSString *_appNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFiled
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    CGFloat keyboardHeight = 220;
    int offset = keyboardHeight - (self.view.frame.size.height - frame.origin.y - frame.size.height);
    
    if (textField == self.userIdTF || textField == self.unitIdTF) {
        offset += 40;
    }
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0) {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backGroundTouched:(id)sender {
    [self.userIdTF resignFirstResponder];
    [self.passswordTF resignFirstResponder];
    [self.unitIdTF resignFirstResponder];
}

- (IBAction)loginBtnPressed:(id)sender {
    //验证用户名、密码、单位ID
    if (IS_NULL_STRING(self.userIdTF.text)) {
        [self.view makeToast:@"用户名不能为空" duration:2.0 position:@"top"];
        return;
    }
    if (IS_NULL_STRING(self.passswordTF.text)) {
        [self.view makeToast:@"密码不能为空" duration:2.0 position:@"top"];
        return;
    }
    if (IS_NULL_STRING(self.unitIdTF.text)) {
        [self.view makeToast:@"单位ID不能为空" duration:2.0 position:@"top"];
        return;
    }
    
    onlineBusiness = [[HBOnlineBusiness alloc] initWithServerURL:MLOG_ONLINE_SERVER_URL];
    
    NSString *userName = self.userIdTF.text;
    NSString *password = self.passswordTF.text;
    NSString *divid = self.unitIdTF.text;
    
    //获取用户信息 getUserInfo  然后提交在线业务新办申请
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在登录";
    __block NSString *error = nil;
    [hud showAnimated:YES whileExecutingBlock:^{
        error = [self requstNewApplication];
    } completionBlock:^{
        [hud removeFromSuperview];
        if (nil != error) {
            [HBCommonUtil showAttention:error sender:self];
            return;
        }
        
        //打开验证码界面
        HBVerifyViewController *verifyView = [[HBVerifyViewController alloc] init];
        verifyView.username = userName;
        verifyView.password = password;
        verifyView.divid    = divid;
        verifyView.deviceId = [HBCommonUtil getDeviceIdentifier];
        verifyView.acceptNumber = _appNo;
        
        [self presentViewController:verifyView animated:YES completion:nil];
    }];
}

- (NSString *)requstNewApplication
{
    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
    HBUserInfo *userInfo = [serverConnect getUserInfo:self.userIdTF.text
                                             password:self.passswordTF.text
                                                divID:self.unitIdTF.text];
    if (nil == userInfo) {
        return [serverConnect getLastErrorMessage];
    }
    
    //提交新办证书申请
    _appNo = [self makeOnlineBusinessNewRequest:userInfo];
    if (nil == _appNo) {
        return [HBMiddleWare lastErrorMessage];
    }
    
    HB_ONLINE_BUSINESS_STATUS status = [onlineBusiness queryBusinessStatus:_appNo];
    if (status != HB_ONLINE_STATUS_NO_INSTALL) {
        return @"申请待审批，请联系管理员处理";
    }
    
    return nil;
}

-(NSString *)makeOnlineBusinessNewRequest:(HBUserInfo *)userInfo
{
    NSDictionary *formDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 userInfo.userName,     @"OPERATORNAME",    //经办人 NO
                                 userInfo.phone,        @"OPERATORPHONE",   //经办人手机号 NO
                                 userInfo.idNum,        @"IDENTITYCARD",    //身份证号 NO
                                 userInfo.userName,     @"USERNAME",        //用户名称 NO
                                 userInfo.divname,      @"DIVID",           //单位名称 NO
                                 [HBCommonUtil getDeviceIdentifier], @"SERIALNUMBER",//设备串号
                                 nil];
    
    HB_ONLINE_BUSINESS_TYPE businessType = HB_ONLINE_NEW;
    //获取填报要素
    NSArray *formInfo = [onlineBusiness getApplicationFormInfo:MLOG_PROJECT_ID type:businessType];
    if (nil == formInfo) {
        return nil;
    }
    
    //填写申请单
    for (HBApplicationItem *item in formInfo) {
        [item setApplicationItemData:[formDataDic objectForKey:[item getItemName]]];
    }
    
    //提交申请单
    NSString *acceptNo = [onlineBusiness submitApplicationForm:MLOG_PROJECT_ID applicationForm:formInfo businessType:businessType];
    if (nil == acceptNo) {
        return nil;
    }
    
    return acceptNo;
}
@end
