////
////  Ori_HBCommonUtil.m
////  HebcaLog
////
////  Created by 祁子栋 on 2017/10/22.
////  Copyright © 2017年 hebca. All rights reserved.
////
//
////
////  HBCommonUtil.m
////  SafeMail
////
////  Created by hebca on 14-8-13.
////  Copyright (c) 2014年 hebca. All rights reserved.
////
//
//#import "HBCommonUtil.h"
//#import "sys/utsname.h"
//#import "AppDelegate.h"
//#import "HBFileManager.h"
//#import "HBServerInterface.h"
//#import "SSKeychain.h"
//
//#define SSKC_ACCOUNT   @"com.hebca.kuaiban"
//#define SSKC_UUID_FLAG @"com.hebca.kuaiban.uuid"
//#define SSKC_PSWD_FLAG @"com.hebca.kuaiban.password"
//
//@implementation HBLocation : NSObject
//
//@end
//
//NSString *g_updateUrl = nil;
//
//@implementation NSString (Check)
//
//-(BOOL)checkPhoneNumInput{
//
//    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$";
//
//    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    //
//    //    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    //
//    //    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    //
//    //    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    //
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    //    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    //    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    BOOL res1 = [regextestmobile evaluateWithObject:self];
//    //    BOOL res2 = [regextestcm evaluateWithObject:self];
//    //    BOOL res3 = [regextestcu evaluateWithObject:self];
//    //    BOOL res4 = [regextestct evaluateWithObject:self];
//
//    if (res1)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//
//}
//
//-(BOOL)checkIDNumber{
//    NSString *isIDCard=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}[xX0-9]$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isIDCard];
//    BOOL res1 = [regextestmobile evaluateWithObject:self];
//    if (res1)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//-(BOOL)checkFullName{
//    NSString *isName = @"^[\u4E00-\u9FA5,a-z,A-Z]{1,50}$";
//    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isName];
//    BOOL res = [regextestName evaluateWithObject:self];
//    return res;
//}
//
///*
// 检查邮箱密码
// 1.密码只能由英文字母a～z(不区分大小写)、数字0～9、下划线组成。\n
// 2.密码长度为4~25个字符。
// ** 14-12-27更改：\w包含英文字母以外的其他字母：例如汉字、俄文等
// */
//-(BOOL)checkPassword {
//    NSString *PASSWORD = @"^[0-9a-zA-Z_]{4,25}$";
//    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PASSWORD];
//    BOOL res = [regextestName evaluateWithObject:self];
//    return res;
//}
//
///*
// 检查邮箱账户名
// 1.用户名只能由英文字母a～z(不区分大小写)、数字0～9、下划线组成。\n
// 2.用户名的起始字符必须是英文字母。如：hebtx_2013\n
// 3.用户名长度为4~20个字符。
// ** 14-12-27更改：\w包含英文字母以外的其他字母：例如汉字、俄文等
// */
//-(BOOL)checkMailAccount {
//    NSString *isAccount = @"^[0-9a-zA-Z_\\.]{3,19}@[0-9a-zA-Z_]+\\.[0-9a-zA-Z_]+$";
//    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isAccount];
//    BOOL res = [regextestName evaluateWithObject:self];
//    return res;
//}
//
///*
// 检查发送邮箱账户名
// ** 14-12-27更改：\w包含英文字母以外的其他字母：例如汉字、俄文等
// */
//- (BOOL)checkSendMailAccount
//{
//    NSString *isAccount = @"^[0-9a-zA-Z_\\.]+@[0-9a-zA-Z_]+\\.[0-9a-zA-Z_]+$";
//    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isAccount];
//    BOOL res = [regextestName evaluateWithObject:self];
//    return res;
//}
//
///*证书密码只能由4~32位字母、数字、下划线组成
// ** 14-12-27更改：\w包含英文字母以外的其他字母：例如汉字、俄文等
// */
//-(BOOL)checkCertPassword {
//    NSString *isPassword = @"^[0-9a-zA-Z_]{4,32}$";
//    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isPassword];
//    BOOL res = [regextestName evaluateWithObject:self];
//    return res;
//}
//
//@end
//
//@implementation UIViewController (UINaviUntranslucentViewController)
//- (void)configNavigationBar
//{
//    //导航栏位置状态
//    if (SYSTEM_VERSION_HIGHER(7.0)) {
//        self.navigationController.navigationBar.translucent = NO;
//    }
//    self.navigationController.navigationBar.hidden = NO;
//
//    //标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
//
//    //导航栏颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20.0f/255.0 green:98.0f/255.0 blue:166.0f/255.0 alpha:1.0]];
//
//    //返回按钮
//    UIImage *image = [UIImage imageNamed:@"btn_back"];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
//    [backButton setImage:image forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchDown];
//
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backBarButton;
//}
//
//- (void)configNavigationBar2
//{
//    //导航栏位置状态
//    if (SYSTEM_VERSION_HIGHER(7.0)) {
//        self.navigationController.navigationBar.translucent = NO;
//    }
//    self.navigationController.navigationBar.hidden = NO;
//
//    //标题颜色
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
//
//    //导航栏颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20.0f/255.0 green:98.0f/255.0 blue:166.0f/255.0 alpha:1.0]];
//
//    //返回按钮
//    UIImage *image = [UIImage imageNamed:@"btn_back"];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
//    [backButton setImage:image forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchDown];
//
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backBarButton;
//}
//
//
//- (void)backButtonPressed
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)dismissView
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//@end
//
//
//@implementation HBUserConfig : NSObject
//
//- (id)init
//{
//    self = [super init];
//    if (self)
//    {
//        self.clientrole = 0;
//        self.userId     = nil;
//        self.userName   = nil;
//        self.deptId     = nil;
//        self.deptName   = nil;
//        self.certCN     = nil;
//
//        HBLocation *location = [[HBLocation alloc] init];
//        self.location = location;
//    }
//
//    return self;
//}
//
//@end
//
//
//@implementation HBCommonUtil
//
//+ (NSString *)checkInputWithName:(NSString *)name withPhone:(NSString *)phone withIdNum:(NSString *)id
//{
//
//    NSString *nameNull = @"姓名不能为空";
//    NSString *nameError = @"姓名只能由汉字、英文字母组成";
//    NSString *nameTooLong = @"姓名长度不能超过50(一个汉字占两个字符)";
//
//    NSString *phoneNull = @"手机号码不能为空";
//    NSString *phoneErr = @"手机号码输入有误";
//
//    NSString *idNull = @"身份证号不能为空";
//    NSString *idError = @"身份证号码输入有误";
//
//    //是否为空
//    if (nil == name || 0 == [name length])
//    {
//        return nameNull;
//    }
//    //姓名超长检查(字节数不超过50)
//    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData *data = [name dataUsingEncoding:gbkEncoding];
//    if ([data length] > 50)
//    {
//        return nameTooLong;
//    }
//    if (0 == [name checkFullName])
//    {
//        return nameError;
//    }
//
//    //是否为空
//    if (nil == phone || 0 == [phone length])
//    {
//        return phoneNull;
//    }
//    if (YES != [phone checkPhoneNumInput])
//    {
//        return phoneErr;
//    }
//
//    //是否为空
//    if (nil == id || 0 == [id length])
//    {
//        return idNull;
//    }
//    if (YES != [id checkIDNumber])
//    {
//        return idError;
//    }
//    return nil;
//}
//
//+ (NSString *)getAppVersion
//{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//}
//
//+ (NSString *)getAppBuildVersion
//{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//
//    return [infoDictionary objectForKey:@"CFBundleVersion"];
//}
//
//+ (NSString *)getDeviceIdentifier
//{
//    NSString *uuid = [SSKeychain passwordForService:SSKC_UUID_FLAG account:SSKC_ACCOUNT];
//    if (IS_NULL_STRING(uuid)) {
//        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
//        [SSKeychain setPassword:uuid forService:SSKC_UUID_FLAG account:SSKC_ACCOUNT];
//    }
//
//    return uuid;
//}
//
//+ (NSString *)getSystemVerison
//{
//    NSMutableString *systemVersion = [NSMutableString stringWithString:[UIDevice currentDevice].systemName];
//    [systemVersion appendString:[UIDevice currentDevice].systemVersion];
//    return systemVersion;
//}
//
//+ (NSString *)getDeviceVersionInfo
//{
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *platform = [NSString stringWithFormat:@"%s", systemInfo.machine];
//
//    return platform;
//}
//
//+ (NSString *)getDeviceVersion
//{
//    NSString *platform = [self getDeviceVersionInfo];
//
//    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
//    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
//    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
//    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
//    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
//    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
//    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
//    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
//    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
//    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
//    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
//    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
//    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
//
//    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
//
//    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
//
//    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
//    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
//    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
//    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
//
//    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
//    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
//    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
//    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
//
//    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
//    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
//    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
//    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
//
//    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
//    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
//
//    return platform;
//}
//
//+ (CGRect)changeFrame:(CGRect)frame X:(float)x Y:(float)y width:(float)w height:(float)h
//{
//    CGRect tempFrame = frame;
//    tempFrame.origin.x = x;
//    tempFrame.origin.y = y;
//    tempFrame.size.width = w;
//    tempFrame.size.height = h;
//
//    return tempFrame;
//}
//
//
//+ (CGRect)changeFrame:(CGRect)frame X:(float)x Y:(float)y
//{
//    CGRect tempFrame = frame;
//
//    tempFrame.origin.x = x;
//    tempFrame.origin.y = y;
//
//    return tempFrame;
//}
//
////下面到451行都是证书相关，去掉了
////+ (HBDevice *)getSoftDevice {
////    [HBMiddleWare reloadDevice];
////
////    HBDevice *device = [HBMiddleWare getDevice:HB_SOFT_DEVICE];
////    if (IS_NULL(device)) //初次登陆，设备为空，需要重新创建
////    {
////        NSInteger createRslt = [HBMiddleWare createSoftDevice:@"SoftToken"];
////        if (createRslt != HM_OK) {
////            NSLog(@"[error]创建软设备失败");
////            return nil;
////        }
////
////        device = [HBMiddleWare getDevice:HB_SOFT_DEVICE];
////        if (IS_NULL(device)) {
////            NSLog(@"[error]创建软设备失败");
////            return nil;
////        }
////
////        NSInteger initRslt = [device initDevice:@"123456" tokenLabel:@"SoftToken"];
////        if (initRslt != HM_OK) {
////            NSLog(@"[error][%s]初始化软设备失败", __FUNCTION__);
////            return nil;
////        }
////
////        [HBMiddleWare reloadDevice];
////
////        device = [HBMiddleWare getDevice:HB_SOFT_DEVICE];
////        [device loginDevice:@"123456"];
////        [HBCommonUtil recordPasswordToDefaults:@"123456"];
////    }
////    else {
////        [HBCommonUtil loginDevice:device];
////    }
////
////    return device;
////}
//
////+ (NSInteger)loginDevice:(HBDevice *)device withUI:(id)sender
////{
////    NSInteger result = 0;
////    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
////        result = [device loginDeviceWithUI:self];
////    }
////    else {
////        result = [device loginDeviceWithUI];
////    }
////
////    return result;
////}
//
////+ (void)loginDevice:(HBDevice *)device
////{
////    [device loginDevice:[HBCommonUtil getPasswordFromDefaults]];
////}
////
////+ (void)loginCert:(HBCert *)cert
////{
////    [cert loginDevice:[HBCommonUtil getPasswordFromDefaults]];
////}
//
////------------------------UserDefaults用户数据----------------------//
///*userInfo =
// {
// USER_LOGIN_STATE = (BOOL)
// USER_LOGIN_CERT  = (string)
// USER_CERT_INFO   =
// {
// certA = 密码;
// certB = 密码;
// certC = 密码;
// ……
// }
//
// */
//
/////获取用户登录状态
//+ (NSNumber *)getUserLoginState
//{
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userInfo = [_userDefaults objectForKey:USER_DEFAULTS_USER_INFO];
//    if (!userInfo) {
//        return nil;
//    }
//    NSNumber *loginState = [userInfo objectForKey:USER_LOGIN_STATE];
//
//    return loginState;
//}
/////更新用户登录状态
//+ (void)upDateUserLoginState:(BOOL)login
//{
//    //    if (certCN == nil || [certCN length] == 0) {
//    //        return;
//    //    }
//
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[_userDefaults objectForKey:USER_DEFAULTS_USER_INFO]];
//    if (userInfo == nil) {
//        userInfo = [[NSMutableDictionary alloc] init];
//    }
//
//    NSNumber *state = [NSNumber numberWithBool:login];
//    [userInfo setObject:state forKey:USER_LOGIN_STATE];
//    //    [userInfo setObject:certCN forKey:USER_LOGIN_CERT];
//
//    [_userDefaults setObject:[userInfo copy] forKey:USER_DEFAULTS_USER_INFO];
//    [_userDefaults synchronize];
//}
//
////+ (NSString *)getUserLoginCert
////{
////    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
////    NSDictionary *userInfo = [_userDefaults objectForKey:USER_DEFAULTS_USER_INFO];
////    if (!userInfo) {
////        return nil;
////    }
////    NSString *loginCert = [userInfo objectForKey:USER_LOGIN_CERT];
////
////    return loginCert;
////}
//
//
//
////+ (Int)getUser
//
////保存证书密码
///*
// + (NSString *)getPasswordFromDefaults;
// + (void)recordPasswordToDefaults:(NSString *)password;
// */
//+ (void)recordPasswordToDefaults:(NSString *)password
//{
//    if (password == nil) {
//        return;
//    }
//
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//    [_userDefaults setValue:password forKey:USER_DEFAULTS_PASSWORD];
//
//    [_userDefaults synchronize];
//}
//
//+ (NSString *)getPasswordFromDefaults
//{
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//
//    NSString *password = [_userDefaults valueForKey:USER_DEFAULTS_PASSWORD];
//
//    return password;
//}
//
//
//+ (NSString *)getPasswordFromKeychain
//{
//    NSString *usercount = [NSString stringWithFormat:@"%@-%@", SSKC_ACCOUNT, [HBCommonUtil getUserId]];
//
//    NSString *passwd = [SSKeychain passwordForService:SSKC_PSWD_FLAG account:usercount];
//
//    return passwd;
//}
//
//+ (void)recordPasswordToKeychain:(NSString *)password
//{
//    NSString *usercount = [NSString stringWithFormat:@"%@-%@", SSKC_ACCOUNT, [HBCommonUtil getUserId]];
//
//    [SSKeychain setPassword:password forService:SSKC_PSWD_FLAG account:usercount];
//}
//
//
////从用户默认配置获取用户信息
//+ (void)loadUserConfigFromDefaults:(NSString *)certCN
//{
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userInfoDic = [_userDefaults objectForKey:USER_DEFAULTS_USER_CONFIG];
//    if (userInfoDic == nil || [userInfoDic count] == 0) {
//        return;
//    }
//    NSDictionary *recordsByCert = [userInfoDic objectForKey:certCN];
//    if (recordsByCert == nil || [recordsByCert count] == 0)
//    {
//        return;
//    }
//
//    HBUserConfig *userConfig = [[HBUserConfig alloc] init];
//    userConfig.attendState =[[recordsByCert objectForKey:@"attendState"] boolValue];
//    userConfig.hasHeadImg  =[[recordsByCert objectForKey:@"hasHeadImg"] boolValue];
//    userConfig.clientrole  =[[recordsByCert objectForKey:@"clientrole"] integerValue];
//    NSNumber *useridNum = [recordsByCert objectForKey:@"userId"];
//    userConfig.userId      = [NSString stringWithFormat:@"%d", useridNum.intValue];
//    userConfig.userName    = [recordsByCert objectForKey:@"userName"];
//    userConfig.deptId      = [recordsByCert objectForKey:@"deptId"];
//    userConfig.deptName    = [recordsByCert objectForKey:@"deptName"];
//    userConfig.certCN      = [recordsByCert objectForKey:@"certCN"];
//    userConfig.lastUpdate  = [recordsByCert objectForKey:@"lastUpdate"];
//
//    HBLocation *location = [[HBLocation alloc] init];
//    location.latitude  = [recordsByCert objectForKey:@"latitude"];
//    location.longitude = [recordsByCert objectForKey:@"longitude"];
//    location.address   = [recordsByCert objectForKey:@"address"];
//
//    userConfig.location = location;
//
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.userConfig = userConfig;
//
//    return;
//}
//
//+ (void)updateUserConfig:(HBUserConfig *)config
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.userConfig = config;
//
//    [self recordUSerConfigToDefaults];
//}
//
////保存用户信息到用户默认配置
//+ (void)recordUSerConfigToDefaults
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    HBUserConfig *config = appDelegate.userConfig;
//    if (config == nil) {
//        return;
//    }
//
//    NSUserDefaults * _userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfoDic =[NSMutableDictionary dictionaryWithDictionary:[_userDefaults objectForKey:USER_DEFAULTS_USER_CONFIG]];
//    if (userInfoDic == nil) {
//        userInfoDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    }
//    NSMutableDictionary *userConfig = [[userInfoDic objectForKey:config.certCN] mutableCopy];
//    if (userConfig == nil) {
//        userConfig = [[NSMutableDictionary alloc] init];
//    }
//
//    NSNumber *attendState = [NSNumber numberWithBool:config.attendState];
//    [userConfig setObject:attendState forKey:@"attendState"];
//
//    NSNumber *hasHeadImg = [NSNumber numberWithBool:config.hasHeadImg];
//    [userConfig setObject:hasHeadImg forKey:@"hasHeadImg"];
//
//    NSNumber *clientrole  = [NSNumber numberWithInteger:config.clientrole];
//    [userConfig setObject:clientrole  forKey:@"clientrole"];
//
//    [userConfig setObject:config.userId   forKey:@"userId"];
//    [userConfig setObject:config.userName forKey:@"userName"];
//    [userConfig setObject:config.deptId   forKey:@"deptId"];
//    [userConfig setObject:config.deptName forKey:@"deptName"];
//    [userConfig setObject:config.certCN   forKey:@"certCN"];
//    if (config.lastUpdate) {
//        [userConfig setObject:config.lastUpdate forKey:@"lastUpdate"];
//    }
//
//    HBLocation *location = config.location;
//    if (location) {
//        if (location.latitude) {
//            [userConfig setObject:location.latitude forKey:@"latitude"];
//        }
//        if (location.longitude) {
//            [userConfig setObject:location.longitude forKey:@"longitude"];
//        }
//        if (location.address) {
//            [userConfig setObject:location.address forKey:@"address"];
//        }
//    }
//
//    [userInfoDic setObject:[userConfig copy] forKey:config.certCN];
//
//    [_userDefaults setObject:[userInfoDic copy] forKey:USER_DEFAULTS_USER_CONFIG];
//    [_userDefaults synchronize];
//}
//
//+ (NSString *)getUserId
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.userId;
//}
//
//+ (NSString *)getUserName
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.userName;
//}
//
//+ (NSString *)getDeptId
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.deptId;
//}
//
//+ (NSString *)getDeptName
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.deptName;
//}
//
//+ (NSString *)getCertCN
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.certCN;
//}
//
//
////获取更新上班状态
//+ (BOOL)getAttendState:(NSString *)userid
//{
//    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//
//    HBAttendInfo *attendInfo = [serverConnect getLastAttendInfo:userid];
//    BOOL attendIn = (nil == attendInfo.time ? NO : YES);
//
//    [HBCommonUtil updateAttendState:attendIn];
//
//    return attendIn;
//}
//
//+ (void)updateAttendState:(BOOL)state
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    appDelegate.userConfig.attendState = state;
//}
//
//
////是否有头像
//+ (BOOL)hasHeadImage
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.hasHeadImg;
//}
//
//+ (void)updateUserHeadStatus:(BOOL)state
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    appDelegate.userConfig.hasHeadImg = state;
//}
//
//
////获取位置
//+ (HBLocation *)getUserLocation
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.location;
//}
////更新位置
//+ (void)updateLocation:(HBLocation *)location
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    appDelegate.userConfig.location = location;
//}
//
//
//+ (NSString *)getLastUpdateTime
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    return appDelegate.userConfig.lastUpdate;
//}
//
//+ (void)refreshLastUpdateTime:(NSString *)updateTime
//{
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    appDelegate.userConfig.lastUpdate = updateTime;
//}
//
//
//
////告警弹框
//+(void)showAttention:(NSString *)attentionMsg sender:(id)sender
//{
//    if (!SYSTEM_VERSION_HIGHER(8.0)) {
//        [HBCommonUtil showAlertView:attentionMsg title:@"错误提示"];
//    }
//    else {
//        [HBCommonUtil showAlertControl:attentionMsg title:@"错误提示" withSender:sender];
//    }
//}
//
//
//+ (void)showAttentionWithTitle:(NSString *)title message:(NSString *)attentionMsg sender:(id)sender
//{
//    if (!SYSTEM_VERSION_HIGHER(8.0)) {
//        [HBCommonUtil showAlertView:attentionMsg title:title];
//    }
//    else {
//        [HBCommonUtil showAlertControl:attentionMsg title:title withSender:sender];
//    }
//}
//
//+(void)showAlertView:(NSString *)message title:(NSString *)title
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//    [alertView show];
//}
//
//+(void)showAlertControl:(NSString *) message title:(NSString *)title withSender:(id)sender
//{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
//                                                                             message:message
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:okAction];
//
//    [(UIViewController *)sender presentViewController:alertController animated:YES completion:nil];
//}
//
//+ (void)showUpdateAlert:(HBUpdateInfo *)updateInfo withSender:(id)sender
//{
//    if (SYSTEM_VERSION_HIGHER(8.0)) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示"
//                                                                                 message:updateInfo.updateDesc
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            NSURL *downloadUrl = [NSURL URLWithString:updateInfo.downloadurl];
//            [[UIApplication sharedApplication]openURL:downloadUrl];
//        }];
//        [alertController addAction:okAction];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:cancelAction];
//
//        [(UIViewController *)sender presentViewController:alertController animated:YES completion:nil];
//    }
//    else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:updateInfo.updateDesc delegate:self cancelButtonTitle:@"升级" otherButtonTitles:@"以后再说", nil];
//        alertView.tag = 100;
//        g_updateUrl = updateInfo.downloadurl;
//
//        [alertView show];
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag != 100) return;
//
//    if (buttonIndex == 0) {
//        NSURL *downloadUrl = [NSURL URLWithString:g_updateUrl];
//        [[UIApplication sharedApplication]openURL:downloadUrl];
//    }
//}
//
//
////记录登录状态到默认配置
//+ (void)recordConfiguration
//{
//    BOOL loginState = [[HBCommonUtil getUserLoginState] boolValue];
//    [HBCommonUtil upDateUserLoginState:[HBCommonUtil getCertCN] state:loginState];
//
//    if (loginState) {   //如果为登录状态，则将用户配置信息保存到用户默认配置里
//        [HBCommonUtil recordUSerConfigToDefaults];
//    }
//
//    //停止定位
//    g_mapManager = nil;
//}
//
//
////时间日期处理
//+(NSString *)getDateWithYMD:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *currDate = [dateFormatter stringFromDate:date];
//
//    return currDate;
//}
//
//+(NSString *)getDateWithYMDCN:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//    NSString *currDate = [dateFormatter stringFromDate:date];
//
//    return currDate;
//}
//
//+ (NSString *)getVerifyCode
//{
//    NSDate *date = [NSDate date];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"ddMMyy"];
//    NSString *currDate = [dateFormatter stringFromDate:date];
//
//    return currDate;
//}
//
//
//+(NSString *)getDateWithWeek:(NSDate *)date {
//    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:date];
//    int week = [comps weekday];
//    int year=[comps year];
//    int month = [comps month];
//    int day = [comps day];
//
//    NSString *currDate = [NSString stringWithFormat:@"%d年%d月%d日 %@", year,month,day, [arrWeek objectAtIndex:week-1]];
//
//    return currDate;
//}
//
//+(NSString *)getTimeHHmm:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"HH:mm"];
//    NSString *time = [dateFormatter stringFromDate:date];
//
//    return time;
//}
//
//+(NSString *)getTimeHmS:(NSDate *)date
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"HH:mm:SS"];
//    NSString *time = [dateFormatter stringFromDate:date];
//
//    return time;
//}
//
//+(NSString *)translateDate:(NSString *)dateStr toCN:(BOOL)isture
//{
//    //TODO： 日期字符串转换  [YES] yyyy-MM-dd <====> yyyy年MM月dd日 [NO]
//    NSDateFormatter *sourceFormatter = [[NSDateFormatter alloc] init];
//    NSDateFormatter *targetFormatter = [[NSDateFormatter alloc] init];
//
//    if (isture) {
//        [sourceFormatter setDateFormat:@"yyyy-MM-dd"];
//        [targetFormatter setDateFormat:@"yyyy年MM月dd日"];
//    }
//    else {
//        [sourceFormatter setDateFormat:@"yyyy年MM月dd日"];
//        [targetFormatter setDateFormat:@"yyyy-MM-dd"];
//    }
//
//    NSDate *date = [sourceFormatter dateFromString:dateStr];
//    NSString *finalDate = [targetFormatter stringFromDate:date];
//
//    return finalDate;
//}
//
//+ (NSString*)processDate:(NSString*)sourceDateStr
//{
//    if (nil == sourceDateStr) {
//        return nil;
//    }
//
//    NSString *processedDate = nil;
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
//
//    NSDate *sourceDate = [dateFormatter dateFromString:sourceDateStr];
//
//    NSDate *nowDate = [NSDate date];
//
//
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int timeFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *sourComp = [cal components:timeFlags fromDate:sourceDate];
//    NSDateComponents *nowComp = [cal components:timeFlags fromDate:nowDate];
//
//    NSInteger mailYear = [sourComp year];
//    NSInteger mailMonth = [sourComp month];
//    NSInteger mailDay = [sourComp day];
//
//    NSInteger nowYear = [nowComp year];
//    NSInteger nowMonth = [nowComp month];
//    NSInteger nowDay = [nowComp day];
//
//    if (mailYear == nowYear) {
//        if (mailMonth == nowMonth) {
//            if (mailDay == nowDay) {
//                [dateFormatter setDateFormat:@"今天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else if (mailDay == (nowDay-1)){
//                [dateFormatter setDateFormat:@"昨天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else if (mailDay == (nowDay-2)){
//                [dateFormatter setDateFormat:@"前天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else {
//                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            }
//        } else {
//            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//            processedDate = [dateFormatter stringFromDate:sourceDate];
//        }
//    } else {
//        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        processedDate = [dateFormatter stringFromDate:sourceDate];
//    }
//
//    return processedDate;
//}
//
//+ (NSString*)processNSDate:(NSDate*)sourceDate
//{
//    NSString *processedDate = nil;
//
//    if (nil == sourceDate) {
//        return nil;
//    }
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    NSDate *nowDate = [NSDate date];
//
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int timeFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    NSDateComponents *sourComp = [cal components:timeFlags fromDate:sourceDate];
//    NSDateComponents *nowComp = [cal components:timeFlags fromDate:nowDate];
//
//    NSInteger mailYear = [sourComp year];
//    NSInteger mailMonth = [sourComp month];
//    NSInteger mailDay = [sourComp day];
//
//    NSInteger nowYear = [nowComp year];
//    NSInteger nowMonth = [nowComp month];
//    NSInteger nowDay = [nowComp day];
//
//    if (mailYear == nowYear) {
//        if (mailMonth == nowMonth) {
//            if (mailDay == nowDay) {
//                [dateFormatter setDateFormat:@"今天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else if (mailDay == (nowDay-1)){
//                [dateFormatter setDateFormat:@"昨天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else if (mailDay == (nowDay-2)){
//                [dateFormatter setDateFormat:@"前天 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            } else {
//                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//                processedDate = [dateFormatter stringFromDate:sourceDate];
//            }
//        } else {
//            [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
//            processedDate = [dateFormatter stringFromDate:sourceDate];
//        }
//    } else {
//        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
//        processedDate = [dateFormatter stringFromDate:sourceDate];
//    }
//
//    return processedDate;
//}
//
//
//+ (NSString *)calculateTimeIntervalSinceNow:(NSString *)rdate withTime:(NSString *)rtime
//{
//    NSString *destTimeStr = [NSString stringWithFormat:@"%@+%@",rdate, rtime];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd+HH:mm"];
//    NSDate *destTime = [formatter dateFromString:destTimeStr];
//
//    NSDate *nowdate = [NSDate date];
//
//    NSString *timeString=@"";
//    NSTimeInterval interval =[destTime timeIntervalSinceDate:nowdate];
//
//    if (interval < 0) {  //按周提醒的时间设置点在之前
//        while (interval < 0) {
//            interval += 604800;
//        }   //按模增加一周的时间
//    }
//    if (interval && interval < 60) {
//        return [NSString stringWithFormat:@"%ld秒", (long)interval];
//    }
//
//    NSInteger days  = interval/86400;
//    if (days > 0) {
//        timeString = [NSString stringWithFormat:@"%ld天", (long)days];
//    }
//
//    NSInteger hours = (interval - 86400*days)/3600;
//    NSInteger mints = (interval - 86400*days - 3600*hours)/60;
//    if (hours > 0) {
//        timeString = [timeString stringByAppendingFormat:@"%ld小时", (long)hours];
//    }
//    else if(hours == 0) {
//        if (days > 0 && mints >0) timeString = [timeString stringByAppendingString:@"零"];
//    }
//
//    if (mints > 0) {
//        timeString = [timeString stringByAppendingFormat:@"%ld分钟", (long)mints];
//    }
//
//    return timeString;
//}
//
//
//+ (UIColor *)greenColor
//{
//    return [UIColor colorWithRed:136.0/255.0 green:170.0/255.0 blue:31.0/255.0 alpha:1.0];
//}
//
////根据用户id查找用户姓名
//+ (NSString *)getUsernameByUserId:(NSString *)findId
//{
//    HBFileManager *fm = [[HBFileManager alloc] init];
//    HBContactInfo *contactInfo = [fm getContactFromLocalFile];   //读取联系人信息(本地不存在则从服务端获取)
//    if (contactInfo == nil) {
//        HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//
//        NSString *userId = [HBCommonUtil getUserId];
//        //        HBCert *cert = nil;
//        //        NSArray *certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
//        //        for (HBCert *item in certList) {
//        //            NSString *certCN = [item getSubjectItem:HB_DN_GIVEN_NAME];
//        //            if ([certCN isEqualToString:[HBCommonUtil getCertCN]]) {
//        //                cert = item;
//        //                break;
//        //            }
//        //        }
//
//        //        [HBCommonUtil loginCert:cert];
//        //        NSString *signCert = [cert getBase64CertData];
//        //        [cert signDataInit:HB_SHA1];
//        //        NSString *signStr = [NSString stringWithFormat:@"%@", userId];
//        //        NSData *signedData = [cert signData:[signStr dataUsingEncoding:NSUTF8StringEncoding]];
//
//
//        HBContactRequest *request = [[HBContactRequest alloc] init];
//        request.userid = userId;
//        //        request.signcert = signCert;
//        //        request.signdata = signedData;
//        request.lastupdated = [HBCommonUtil getLastUpdateTime];
//
//        contactInfo = [serverConnect getContacts:request];
//        if (contactInfo) {
//            if (contactInfo.modified) {
//                [fm writeUserContacts:contactInfo];
//            }
//        }
//
//        NSString *updateDate = [HBCommonUtil getDateWithYMD:[NSDate date]];
//        [HBCommonUtil refreshLastUpdateTime:updateDate];
//    }
//
//    NSArray *depts = contactInfo.depts;
//    NSString *userName = nil;
//    for (HBContactDept *dept in depts) {
//        userName = [HBCommonUtil findNameByUserId:findId indept:dept];
//        if (userName) {
//            break;
//        }
//    }
//
//    return userName;
//}
//
//+ (NSString *)findNameByUserId:(NSString *)userid indept:(HBContactDept *)dept
//{
//    NSString *findName = nil;
//
//    NSArray *subContacts = dept.contacts;
//    if (subContacts != nil && [subContacts count] != 0)
//    {
//        for (HBContact *contactItem in subContacts)
//        {
//            if ([[NSString stringWithString:contactItem.userid] isEqualToString:[NSString stringWithString:userid]]) {
//                findName = contactItem.username;
//                return findName;
//            }
//        }
//    }
//
//    NSArray *subDepts = dept.depts;
//    if (subDepts != nil && [subDepts count] != 0)
//    {
//        for (HBContactDept *subdept in subDepts)
//        {
//            findName = [HBCommonUtil findNameByUserId:userid indept:subdept];
//            if (findName) {
//                return findName;
//            }
//        }
//    }
//
//    return nil;
//}
//
////图片尺寸质量压缩： level=1:宽度600 压缩比例0.6 level=2:宽度64 压缩比例0.2
//+ (UIImage *)compressImage:(UIImage *)image toLevel:(NSInteger)level
//{
//    UIImage *imageNew = image;
//
//    NSInteger width = 0;
//    CGFloat ratio = 1.0;
//    if (level == 1) {
//        width = 600;
//        ratio = 0.8;
//    }
//    else if (level == 2) {
//        width = 200;
//        //ratio = 0.8;
//    }
//
//    //图片尺寸压缩
//    CGSize imgSize = image.size;
//    if (imgSize.width > width) {
//        CGSize newSize = imageNew.size;
//        newSize.width = width;
//        newSize.height = width * imgSize.height / imgSize.width;
//
//        UIGraphicsBeginImageContext(newSize);
//        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//
//        imageNew = UIGraphicsGetImageFromCurrentImageContext();
//    }
//
//    //图片质量压缩
//    NSData *imageData = UIImageJPEGRepresentation(imageNew, ratio);
//
//    return [UIImage imageWithData:imageData];
//}
//
//+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
//{
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    // 绘制改变大小的图片
//    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    // 返回新的改变大小后的图片
//    return scaledImage;
//}
//
//
//+ (NSString *)transferUrlHtmlStr:(NSString *)orignStr
//{
//    if (!orignStr) {
//        return nil;
//    }
//
//    /* 地址格式
//     <a href='http://item.jd.com/1424141566.html#none' target='_blank'>http://item.jd.com/1424141566.html#none</a>
//     */
//
//    //是否为url地址格式
//    static NSString *htmlHead = @"<a href=";
//    static NSString *htmlBody = @"target='_blank";
//    static NSString *htmlRear = @"</a>";
//
//    NSRange headRange = [orignStr rangeOfString:htmlHead options:NSLiteralSearch];
//    NSRange bodyRange = [orignStr rangeOfString:htmlBody options:NSLiteralSearch];
//    NSRange rearRange = [orignStr rangeOfString:htmlRear options:NSLiteralSearch];
//
//    if (headRange.length && bodyRange.length && rearRange.length) {
//        NSArray *strArray = [orignStr componentsSeparatedByString:@"'"];
//        orignStr = [strArray objectAtIndex:1];
//    }
//
//    return orignStr;
//}
//
//+ (UIImage *)getUserHead:(NSString *)userid
//{
//    if (IS_NULL(userid)) {
//        return nil;
//    }
//
//    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
//    NSString *imageServerPath = [serverConnect getCustomConfigWithUserid:userid withKey:@"head"];
//    if (IS_NULL_STRING(imageServerPath)) {
//        return nil;
//    }
//
//    //判断本地是否存在
//    /* 图片格式 U525/head_347e4625ab55484fae16eb6342a8378b.jpg */
//    NSArray *arr = [imageServerPath componentsSeparatedByString:@"/"];
//    NSString *imageName = [arr objectAtIndex:1];
//    HBFileManager *filemanager = [[HBFileManager alloc] init];
//
//    UIImage *image = [filemanager getUserHeadImg:imageName];
//    if (image) {
//        return image;
//    }
//
//    //本地不存在，则到服务端获取
//    NSString *fullUrl = [MLOG_SERVER_URL stringByAppendingFormat:@"download.action?filename=%@", imageServerPath];
//    NSString* imageUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//    if (!imageData || imageData.length == 0) {
//        return nil;
//    }
//
//    //图片压缩
//    UIImage *origImage = [UIImage imageWithData:imageData];
//    image = [HBCommonUtil compressImage:origImage toLevel:2];
//    imageData = UIImageJPEGRepresentation(image, 1.0);
//
//    //写入本地
//    [filemanager writeUserHeadImg:imageData withName:imageName];
//
//    return image;
//}
//
//
//@end
//
