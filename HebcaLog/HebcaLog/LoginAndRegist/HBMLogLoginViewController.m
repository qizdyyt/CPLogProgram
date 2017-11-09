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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    [self.user login:^(bool isOK, NSString *msg) {
        if (isOK) {
            self.loginSuccess = isOK;
            [hud hide:YES];
            [QMUITips showWithText:@"登录成功" inView:self.view hideAfterDelay:1];
            //登录
            HBHomepageViewController *homepageControl = [[HBHomepageViewController alloc] init];
            [self.navigationController pushViewController:homepageControl animated:YES];
        }else {
            self.loginSuccess = isOK;
            [hud hide:YES];
            [QMUITips showWithText:@"登录失败" inView:self.view hideAfterDelay:1];
        }
    }];
    
    [UserDefaultTool recordPasswordToDefaults:self.passwordTF.text];
    
    
    

//    [self.view addSubview:hud];
//    __block NSString *error = nil;
//    [hud showAnimated:YES whileExecutingBlock:^{
//        error = [self certLogin];   //登录系统
//    } completionBlock:^{
//        [hud removeFromSuperview];
//        if (nil != error) {
//            [HBCommonUtil showAttention:error sender:self];
//            return;
//        }
//
//        HBHomepageViewController *homepageControl = [[HBHomepageViewController alloc] init];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homepageControl];
//        self.window.rootViewController = navi;
//
//        //[self.navigationController pushViewController:homepageControl animated:YES];
//
//    }];
}

- (IBAction)resetButtonPressed:(id)sender {
}

- (NSString *)certLogin {
    //准备登录参数
    HBLoginParam *loginParam = [[HBLoginParam alloc] init];
//    NSString *certCN = [logCert getSubjectItem:HB_DN_GIVEN_NAME];
//    loginParam.cert = [logCert getBase64CertData];
//
//    NSString *randomStr = [self getRandomString];
//    [logCert signDataInit:HB_SHA1];
//    NSData *signedData = [logCert signData:[randomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
//    loginParam.random = randomStr;
//    loginParam.randomSign = [HBMiddleWare base64Encode:signedData];
//    loginParam.deviceId = [HBCommonUtil getDeviceIdentifier];
//    loginParam.pkgVersion = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    
    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//    HBLoginReply *logReply = [serverConnect loginWithParam:loginParam];
//    if (nil == logReply) {
//        if (HM_NETWORK_UNREACHABLE == [serverConnect getLastError]) {
//            return @"无法连接服务器，请检查您的网络状态";
//        }
//        return [serverConnect getLastErrorMessage];
//    }
    
//    if (-1 == [logReply.userName intValue]) {
//        return @"证书未绑定用户";
//    }
    
//    [HBCommonUtil upDateUserLoginState:certCN state:YES];
    
    HBUserConfig *userConfig = [[HBUserConfig alloc] init];
//    userConfig.userId   = logReply.userId;
//    userConfig.userName = logReply.userName;
//    userConfig.deptId   = logReply.deptId;
//    userConfig.deptName = logReply.deptName;
//    userConfig.clientrole = [logReply.clientRole integerValue];   //TODO：当前服务端未使用；若后续使用此字段，注意返回值类型
//    userConfig.certCN   = certCN;
    
    [UserDefaultTool updateUserConfig:userConfig];
    [UserDefaultTool recordUSerConfigToDefaults];
    
    return nil;
}


#pragma mark - LeveyPopListView delegates
- (void)myPopListView:(HBPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if ([[popListView title] isEqualToString:@"选择证书"])
    {
        self.loginNameTF.text = [[_popViewOptions objectAtIndex:anIndex] objectForKey:@"text"];
    }
    
//    _chooseItem = anIndex;
}

- (void)myPopListViewDidCancel
{
    
}

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
