//
//  HBVerifyViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/2/3.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBVerifyViewController.h"
#import "HBRegistViewController.h"
#import "HBOnlineBusiness.h"
//#import "HBMiddleWare.h"//不再包含errorcode
#import "HBErrorCode.h"
#import "HBServerInterface.h"
#import "HBCommonUtil.h"
#import "HBHomepageViewController.h"
#import "AppDelegate.h"

@interface HBVerifyViewController ()

@end

@implementation HBVerifyViewController
{
//    HBOnlineBusiness *_onlineBussiness;//证书去掉
    NSArray  *_oldCertList;
    NSInteger _secBtnType; //0-重新申请 1-登录系统
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    _onlineBussiness = [[HBOnlineBusiness alloc] initWithServerURL:MLOG_ONLINE_SERVER_URL];
    
    _secBtnType = 0;
    
    //监听短信验证码输入框
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.verifyCodeTF];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_secBtnType == 0) {
        [self.secondBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    }
    else {
        [self.secondBtn setTitle:@"登录系统" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldChanged{
    if ([self.verifyCodeTF.text length] == 0) {
        _secBtnType = 0;
        [self.secondBtn setTitle:@"重新申请" forState:UIControlStateNormal];
    }else {
        _secBtnType = 1;
        [self.secondBtn setTitle:@"登录系统" forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFiled
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int padding = SYSTEM_VERSION_HIGHER(8.0) ? 70 : 0;
    
    CGRect frame = textField.frame;
    CGFloat keyboardHeight = 220;
    int offset = keyboardHeight - (self.view.frame.size.height - frame.origin.y - frame.size.height) + padding;
    
    NSTimeInterval animationDuration = 0.35f;
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

- (IBAction)backgroundTaped:(id)sender {
    [self.verifyCodeTF resignFirstResponder];
}

- (IBAction)reSendBtnPressed:(id)sender {
    [self.verifyCodeTF resignFirstResponder];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在发送...";
    __block NSInteger result;
    [hud showAnimated:YES whileExecutingBlock:^{
        //重新发送短信
//        result = [_onlineBussiness requestVerificationCode:self.acceptNumber];
    } completionBlock:^{
        [hud removeFromSuperview];
        
        if (result != HB_OK) {
            [HBCommonUtil showAttention:@"请求发送短信失败" sender:self];
            return;
        }
    }];
}

- (IBAction)secondBtnPressed:(id)sender {
    
    [self.verifyCodeTF resignFirstResponder];
    
    if (0 == _secBtnType) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"正在安装...";
    
    __block NSString *error = nil;
    [hud showAnimated:YES whileExecutingBlock:^{
//        _oldCertList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
        
        //验证短信、安装证书
//        error = [self verifyAndInstall];
    } completionBlock:^{
        [hud removeFromSuperview];
        
        if (error != nil) {
            [HBCommonUtil showAttention:error sender:self];
            return;
        }
        
        //用户登陆
        NSString *errorMsg = [self userLogin];
        if (errorMsg != nil) {
            [HBCommonUtil showAttention:errorMsg sender:self];
            return;
        }
        
        HBHomepageViewController *homepageControl = [[HBHomepageViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homepageControl];
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = navi;
    }];
}

//- (NSString *)verifyAndInstall
//{
//    //验证短信验证码；
//    NSInteger checkResult = [_onlineBussiness checkVerificationCode:self.acceptNumber verificationCode:self.verifyCodeTF.text];
//    if (HM_OK != checkResult) {
//        return @"验证码验证失败";
//    }
//
//    //获取设备 若为第一次安装，手机没有设备，则新建
//    HBDevice *device = [HBCommonUtil getSoftDevice];
//    if (IS_NULL(device)) {
//        return @"获取设备失败";
//    }
//    [HBCommonUtil loginDevice:device];
//
//    //安装证书
//    NSString *acceptNum = self.acceptNumber;
//    NSString *verifyCode = self.verifyCodeTF.text;
//    NSInteger installRslt = [_onlineBussiness certInstall:acceptNum verificationCode:verifyCode ansymmtricAlg:HB_RSA_1024 device:device];
//    if (HM_OK != installRslt) {
//        return @"安装证书失败";
//    }
//
//    return nil;
//}

//MARK: 登录方法需要按照需求后续修改
/////************ 登录方法需要按照需求后续修改 ***********////

- (NSString *)userLogin
{
//    [HBMiddleWare reloadDevice];
//    NSArray *newcertList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
    
//    HBCert *newCert = nil;
//    if (newcertList.count == 1) {
//        newCert = [newcertList objectAtIndex:0];
//    }
//    else if (newcertList.count > 1){
//        for (HBCert *cert in newcertList) {
//            NSString *certG = [cert getSubjectItem:HB_DN_GIVEN_NAME];
//            BOOL found = NO;
//
//            for (HBCert *oldCert in _oldCertList) {
//                NSString *oldCertG = [oldCert getSubjectItem:HB_DN_GIVEN_NAME];
//
//                if ([certG isEqualToString:oldCertG]) {
//                    found = YES;
//                    break;
//                }
//            }
//
//            if (found) { //找到后，停止查找
//                continue;
//            }
//            else { //没有找到，说明为新的
//                newCert = cert;
//                break;
//            }
//        }
//    }
    
//    if (IS_NULL(newCert)) {
//        return @"没有找到证书";
//    }
//    [HBCommonUtil loginCert:newCert];
//    NSString *certData = [newCert getBase64CertData];
//    NSString *certCN = [newCert getSubjectItem:HB_DN_GIVEN_NAME];
//    //对随机数串进行签名
//    NSString *random = [self getRandomString];
//    NSData *randomData = [random dataUsingEncoding:NSUTF8StringEncoding];
//    [newCert signDataInit:HB_SHA1];
//    NSString *randomSign = [HBMiddleWare base64Encode:[newCert signData:randomData]];
    
    //登录
    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
    HBLoginParam *loginParam = [[HBLoginParam alloc] init];
    
//    loginParam.cert     = certData;
//    loginParam.random   = random;
//    loginParam.randomSign = randomSign;
    loginParam.userName = self.username;
    loginParam.password = self.password;
    loginParam.divid    = self.divid;
    loginParam.deviceId = self.deviceId;
    loginParam.pkgVersion = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];

//    HBLoginReply *loginReply = [serverConnect loginWithParam:loginParam];
//    if (IS_NULL(loginReply)) {
//        return [serverConnect getLastErrorMessage];
//    }
    
//    [HBCommonUtil upDateUserLoginState:certCN state:YES];
    
    HBUserConfig *userConfig = [[HBUserConfig alloc] init];
//    userConfig.userId   = loginReply.userId;
//    userConfig.userName = loginReply.userName;
//    userConfig.deptId   = loginReply.deptId;
//    userConfig.deptName = loginReply.deptName;
//    userConfig.clientrole = [loginReply.clientRole integerValue];   //当前服务端未使用；若后续使用此字段，注意返回值类型
//    userConfig.certCN   = certCN;
    
    [HBCommonUtil updateUserConfig:userConfig];
    
    return nil;
}

//MARK: 可能没啥用，但也没影响，暂时没去
- (NSString *)getRandomString
{
    //获取时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

@end
