//
//  HBPasswordViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/16.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBPasswordViewController.h"
#import "HBCommonUtil.h"
#import "ToastUIView.h"
#import "HBMiddleWare.h"
#import "HBCert.h"

@interface HBPasswordViewController ()

@end

@implementation HBPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backgroundTouched:(id)sender
{
    [self.oldPasswordTF resignFirstResponder];
    [self.neewPasswordTF resignFirstResponder];
    [self.confirmPasswordTF resignFirstResponder];
}

- (IBAction)changePassword:(id)sender {
    [self.oldPasswordTF resignFirstResponder];
    [self.neewPasswordTF resignFirstResponder];
    [self.confirmPasswordTF resignFirstResponder];
    
    NSString *oldPassword = self.oldPasswordTF.text;
    NSString *newPassword = self.neewPasswordTF.text;
    NSString *repPassword = self.confirmPasswordTF.text;
    
    if (oldPassword == nil || [oldPassword length] == 0) {
        [self.view makeToast:@"请输入当前密码"];
        return;
    }else if (![oldPassword checkCertPassword]) {
        [self.view makeToast:@"密码只能由4~32位字母、数字或下划线组成"];
        return;
    }
    
    if (newPassword == nil || [newPassword length] == 0) {
        [self.view makeToast:@"请输入新密码"];
        return;
    }else if (![newPassword checkCertPassword]) {
        [self.view makeToast:@"密码只能由4~32位字母、数字或下划线组成"];
        return;
    }
    
    if (repPassword == nil || [repPassword length] == 0) {
        [self.view makeToast:@"请确认新密码"];
        return;
    }else if (![repPassword checkCertPassword]) {
        [self.view makeToast:@"密码只能由4~32位字母、数字或下划线组成"];
        return;
    }
    
    if (![newPassword isEqualToString:repPassword]) {
        [self.view makeToast:@"两次输入的新密码不一致"];
        return;
    }
    
    //获取登录用的证书密码
    //MARK: 涉及证书，全部删掉
//    NSString *certCN = [HBCommonUtil getCertCN];
//    HBCert *logCert = nil;
//    NSArray *certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_ALL_DEVICE];
//    for (HBCert *cert in certList) {
//        if ([[cert getSubjectItem:HB_DN_GIVEN_NAME] isEqualToString:certCN]) {
//            logCert = cert;
//            break;
//        }
//    }
//    HBDevice *device = [logCert getDevice];
//
//    //中间件修改密码
//    NSInteger hr = [device changeUserPin:oldPassword newPin:newPassword];
//    if (hr != HB_OK)
//    {
//        NSString *errorMsg = [HBMiddleWare lastErrorMessage];
//        [self.view makeToast:errorMsg];
//        return;
//    }
    
    [HBCommonUtil recordPasswordToDefaults:newPassword];
    
    [self.setVC passwordChanged];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
