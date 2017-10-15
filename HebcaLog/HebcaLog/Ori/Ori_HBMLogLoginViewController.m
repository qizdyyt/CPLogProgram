////
////  Ori_HBMLogLoginViewController.m
////  HebcaLog
////
////  Created by 祁子栋 on 2017/10/15.
////  Copyright © 2017年 hebca. All rights reserved.
////
//
//#import "Ori_HBMLogLoginViewController.h"
//
//@interface Ori_HBMLogLoginViewController ()
//
//@end
//
//@implementation Ori_HBMLogLoginViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose //
//    //  HBMLogLoginViewController.m
//    //  HebcaLog
//    //
//    //  Created by 周超 on 15/1/25.
//    //  Copyright (c) 2015年 hebca. All rights reserved.
//    //
//
//#import "HBMLogLoginViewController.h"
//#import "HBRegistViewController.h"
//#import "HBHomepageViewController.h"
//#import "HBCommonUtil.h"
//#import "HBServerConnect.h"
//#import "HBServerInterface.h"
//#import "ToastUIView.h"
//
//
//#import "HBAttendInfoViewController.h"
//
//    //#import "HBLocationViewController.h"
//
//
//    @implementation HBMLogLoginViewController
//    {
//        //    NSArray *_certList;
//        NSInteger _chooseItem;
//        NSMutableArray *_popViewOptions;
//        //    HBCert *logCert;
//    }
//
//    - (void)viewDidLoad {
//        [super viewDidLoad];
//        // Do any additional setup after loading the view from its nib.
//
//        UIImage *image = [UIImage imageNamed:@"btn_password.png"];
//        [self.passwordTF setBackground:image];
//
//        _chooseItem = 0;
//    }
//
//    - (void)didReceiveMemoryWarning {
//        [super didReceiveMemoryWarning];
//        // Dispose of any resources that can be recreated.
//    }
//
//    -(void)viewWillAppear:(BOOL)animated
//    {
//        [super viewWillAppear:animated];
//
//        //MARK: 涉及证书，删掉
//        //    [HBMiddleWare reloadDevice];
//        //    _certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
//        //    if (0 == [_certList count]) {
//        //        self.loginNameTF.text = nil;
//        //        self.loginNameTF.userInteractionEnabled = NO;
//        //        return;
//        //    }
//
//        //    self.loginNameTF.text = [[_certList objectAtIndex:0] getSubjectItem:HB_DN_COMMON_NAME];
//    }
//
//
//#pragma mark - UITextFieldViewDelegate
//
//    - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//    {
//        if (10 == textField.tag) {
//            return NO;
//        }
//        return YES;
//    }
//
//    //开始编辑输入框的时候，软键盘出现，执行此事件
//    -(void)textFieldDidBeginEditing:(UITextField *)textField
//    {
//        CGRect frame = textField.frame;
//        CGFloat keyboardHeight = 220;
//        int offset = keyboardHeight - (self.view.frame.size.height - frame.origin.y - frame.size.height);
//
//        NSTimeInterval animationDuration = 0.30f;
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:animationDuration];
//
//        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//        if(offset > 0) {
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }
//
//        [UIView commitAnimations];
//    }
//
//    //输入框编辑完成以后，将视图恢复到原始状态
//    -(void)textFieldDidEndEditing:(UITextField *)textField
//    {
//        NSTimeInterval animationDuration = 0.30f;
//        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//        [UIView setAnimationDuration:animationDuration];
//
//        self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//
//        [UIView commitAnimations];
//    }
//
//    -(BOOL)textFieldShouldReturn:(UITextField *)textField
//    {
//        [textField resignFirstResponder];
//        return YES;
//    }
//
//    - (IBAction)backGroundTouched:(id)sender {
//        [self.loginNameTF resignFirstResponder];
//        [self.passwordTF resignFirstResponder];
//    }
//
//    - (IBAction)certChoose:(id)sender {
//        [self.passwordTF resignFirstResponder];
//
//        _popViewOptions = [[NSMutableArray alloc] init];
//        //    for (HBCert *cert in _certList) {
//        //        NSString *certCN = [cert getSubjectItem:HB_DN_COMMON_NAME];
//        //        [_popViewOptions addObject:@{@"text":certCN}];
//        //    }
//
//
//        HBPopListView *lplv = [[HBPopListView alloc] initWithTitle:@"选择证书" options:_popViewOptions];
//        lplv.canCancelFlag = YES;
//        lplv.delegate = self;
//        [self.loginNameTF resignFirstResponder];
//        [lplv showInView:self.view animated:YES];
//
//    }
//
//    - (IBAction)registBtnPressed:(id)sender {
//        HBRegistViewController *registViewControl = [[HBRegistViewController alloc] init];
//        [self presentViewController:registViewControl animated:YES completion:nil];
//    }
//
//    - (IBAction)loginButtonPressed:(id)sender {
//        //是否有证书
//        //    if (0 == _certList) {
//        //        HBRegistViewController *registViewControl = [[HBRegistViewController alloc] init];
//        //        [self presentViewController:registViewControl animated:YES completion:nil];
//        //        return;
//        //    }
//
//        //    if (self.loginNameTF.text == nil || self.loginNameTF.text.length == 0) {
//        //        [self.view makeToast:@"请选择证书"];
//        //        return;
//        //    }
//
//        //本地验证密码
//        if (self.passwordTF.text == nil || 0 == [self.passwordTF.text length])
//        {
//            [self.view makeToast:@"请输入您的密码"];
//            return;
//        }
//
//        //验证证书密码
//        //    logCert = [_certList objectAtIndex:_chooseItem];
//        //    NSInteger result = [logCert loginDevice:self.passwordTF.text];
//        //    if (result != HM_OK) {
//        //        NSString *errorMsg = [HBMiddleWare lastErrorMessage];
//        //        [HBCommonUtil showAttention:errorMsg sender:self];
//        //        return;
//        //    }
//        [HBCommonUtil recordPasswordToDefaults:self.passwordTF.text];
//
//        //登录
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//        hud.labelText = @"正在登录";
//        [self.view addSubview:hud];
//        __block NSString *error = nil;
//        [hud showAnimated:YES whileExecutingBlock:^{
//            error = [self certLogin];   //登录系统
//        } completionBlock:^{
//            [hud removeFromSuperview];
//            if (nil != error) {
//                [HBCommonUtil showAttention:error sender:self];
//                return;
//            }
//
//            HBHomepageViewController *homepageControl = [[HBHomepageViewController alloc] init];
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homepageControl];
//            self.window.rootViewController = navi;
//
//            //[self.navigationController pushViewController:homepageControl animated:YES];
//
//        }];
//    }
//
//    - (NSString *)certLogin {
//        //准备登录参数
//        HBLoginParam *loginParam = [[HBLoginParam alloc] init];
//        //    NSString *certCN = [logCert getSubjectItem:HB_DN_GIVEN_NAME];
//        //    loginParam.cert = [logCert getBase64CertData];
//        //
//        //    NSString *randomStr = [self getRandomString];
//        //    [logCert signDataInit:HB_SHA1];
//        //    NSData *signedData = [logCert signData:[randomStr dataUsingEncoding:NSUTF8StringEncoding]];
//
//        //    loginParam.random = randomStr;
//        //    loginParam.randomSign = [HBMiddleWare base64Encode:signedData];
//        //    loginParam.deviceId = [HBCommonUtil getDeviceIdentifier];
//        //    loginParam.pkgVersion = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
//
//        HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//        //    HBLoginReply *logReply = [serverConnect loginWithParam:loginParam];
//        //    if (nil == logReply) {
//        //        if (HM_NETWORK_UNREACHABLE == [serverConnect getLastError]) {
//        //            return @"无法连接服务器，请检查您的网络状态";
//        //        }
//        //        return [serverConnect getLastErrorMessage];
//        //    }
//
//        //    if (-1 == [logReply.userName intValue]) {
//        //        return @"证书未绑定用户";
//        //    }
//
//        //    [HBCommonUtil upDateUserLoginState:certCN state:YES];
//
//        HBUserConfig *userConfig = [[HBUserConfig alloc] init];
//        //    userConfig.userId   = logReply.userId;
//        //    userConfig.userName = logReply.userName;
//        //    userConfig.deptId   = logReply.deptId;
//        //    userConfig.deptName = logReply.deptName;
//        //    userConfig.clientrole = [logReply.clientRole integerValue];   //TODO：当前服务端未使用；若后续使用此字段，注意返回值类型
//        //    userConfig.certCN   = certCN;
//
//        [HBCommonUtil updateUserConfig:userConfig];
//        [HBCommonUtil recordUSerConfigToDefaults];
//
//        return nil;
//    }
//
//
//#pragma mark - LeveyPopListView delegates
//    - (void)myPopListView:(HBPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
//    {
//        if ([[popListView title] isEqualToString:@"选择证书"])
//        {
//            self.loginNameTF.text = [[_popViewOptions objectAtIndex:anIndex] objectForKey:@"text"];
//        }
//
//        _chooseItem = anIndex;
//    }
//
//    - (void)myPopListViewDidCancel
//    {
//
//    }
//
//    - (IBAction)testFunc:(id)sender {
//        HBHomepageViewController *homepage = [[HBHomepageViewController alloc] init];
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:homepage];
//        self.window.rootViewController = navi;
//    }
//
//    - (NSString *)getRandomString
//    {
//        //获取时间
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyyMMddhhmmss"];
//        NSString *dateStr = [formatter stringFromDate:date];
//
//        return dateStr;
//    }
//
//
//    @end
//of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

