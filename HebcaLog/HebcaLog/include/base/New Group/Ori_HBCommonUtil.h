////
////  Ori_HBCommonUtil.h
////  HebcaLog
////
////  Created by 祁子栋 on 2017/10/22.
////  Copyright © 2017年 hebca. All rights reserved.
////
//
////
////  HBCommonUtil.h
////  SafeMail
////
////  Created by hebca on 14-8-13.
////  Copyright (c) 2014年 hebca. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
////#import "../include/HBMiddleWare.h"
//#import "../include/HBCert.h"
//#import "../include/HBDevice.h"
//
//
//
//#define IS_NULL(param) (nil == param)
//#define NOT_NULL(param) (nil != param)
//#define IS_NULL_STRING(str) ((id)str == [NSNull null] || str == nil || 0 == [str length])
//
//#define SYSTEM_VERSION_HIGHER(ver) ([[[UIDevice currentDevice] systemVersion] floatValue] >= ver)
//#define SYSTEM_VERSION_LOWER(ver) ([[[UIDevice currentDevice] systemVersion] floatValue] <= ver)
//#define SYSTEM_VERSION_EQUAL(ver) ([[[UIDevice currentDevice] systemVersion] floatValue] == ver)
//
///*userInfo =
// {
// USER_LOGIN_STATE = (BOOL)
// USER_LOGIN_CERT  = (string)
// }
// */
//
//#define USER_DEFAULTS_USER_INFO @"HBMLOG_USER_INFO"
//#define USER_LOGIN_STATE        @"HBMLog_LoginState"
//#define USER_LOGIN_CERT         @"HBMLog_LoginCert"
//
//#define USER_DEFAULTS_USER_CONFIG  @"HBMLog_User_ConfigInfo"
//#define USER_DEFAULTS_REMIND_INFO  @"HBMLog_User_RemindInfo"
//#define USER_DEFAULTS_PASSWORD     @"HBMLog_User_Password"
//
//
//@interface NSString (check)
//-(BOOL)checkPhoneNumInput;
//-(BOOL)checkIDNumber;
//-(BOOL)checkFullName;
//-(BOOL)checkPassword;
//-(BOOL)checkCertPassword;
//@end
//
//
//@interface UIViewController (UINaviUntranslucentViewController)
//- (void)configNavigationBar;
//- (void)configNavigationBar2;
//@end
//
//
////位置 经度、纬度、地址
//@interface HBLocation : NSObject
//
//@property (nonatomic, copy)NSString *latitude;
//@property (nonatomic, copy)NSString *longitude;
//@property (nonatomic, copy)NSString *address;
//
//@end
//
//
////用户配置信息
//@interface HBUserConfig : NSObject
//
//@property (nonatomic, assign)BOOL attendState; //上班状态：YES-上班； NO-下班；
//@property (nonatomic, assign)BOOL hasHeadImg;  //是否有头像
//@property (nonatomic, assign)NSInteger clientrole; //客户端角色 未使用
//@property (nonatomic, copy)NSString *userId;
//@property (nonatomic, copy)NSString *userName;
//@property (nonatomic, copy)NSString *deptId;
//@property (nonatomic, copy)NSString *deptName;
//@property (nonatomic, copy)NSString *certCN;
//@property (nonatomic, copy)NSString *lastUpdate;
//@property (nonatomic, retain)HBLocation *location;
//
//- (id)init;
//
//@end
//
//
//@interface HBCommonUtil : NSObject
//
//+ (NSString *)checkInputWithName:(NSString *)name withPhone:(NSString *)phone withIdNum:(NSString *)id;
//
//+ (CGRect)changeFrame:(CGRect)frame X:(float)x Y:(float)y;
//
//
////根据用户id查找用户姓名
//+ (NSString *)getUsernameByUserId:(NSString *)findId;
//
//
////------------------------获取系统设备信息----------------------//
////获取设备串号
//+ (NSString *)getDeviceIdentifier;
////获取设备类型
//+ (NSString *)getDeviceVersion;
////获取系统版本
//+ (NSString *)getSystemVerison;
////获取Version
//+ (NSString *)getAppVersion;
////获取Bundle Version
//+ (NSString *)getAppBuildVersion;
//
//
////------------------------证书设备----------------------//
////+ (HBDevice *)getSoftDevice;
////+ (NSInteger)loginDevice:(HBDevice *)device withUI:(id)sender;
////+ (void)loginDevice:(HBDevice *)device;
////+ (void)loginCert:(HBCert *)Cert;
//
//
////------------------------用户默认配置----------------------//
////登录状态/登录证书
//+ (NSNumber *)getUserLoginState;
//+ (NSString *)getUserLoginCert;
//+ (void)upDateUserLoginState:(NSString *)certCN state:(BOOL)login;
//
//
//+ (NSString *)getPasswordFromDefaults;
//+ (void)recordPasswordToDefaults:(NSString *)password;
//
//+ (NSString *)getPasswordFromKeychain;
//+ (void)recordPasswordToKeychain:(NSString *)password;
//
//
////------------------------存取用户信息----------------------//
////获取用户信息
//+ (void)loadUserConfigFromDefaults:(NSString *)certCN;
//+ (void)updateUserConfig:(HBUserConfig *)userConfig;
//+ (void)recordUSerConfigToDefaults;
//
//+ (NSString *)getUserId;
//+ (NSString *)getUserName;
//+ (NSString *)getDeptId;
//+ (NSString *)getDeptName;
//+ (NSString *)getCertCN;
//
////上班状态
//+ (BOOL)getAttendState:(NSString *)userid;
//+ (void)updateAttendState:(BOOL)state;
//
////是否有头像
//+ (BOOL)hasHeadImage;
//+ (void)updateUserHeadStatus:(BOOL)state;
//
////最新位置信息
//+ (HBLocation *)getUserLocation;
//+ (void)updateLocation:(HBLocation *)postion;
//
////联系人上次更新时间
//+ (NSString *)getLastUpdateTime;
//+ (void)refreshLastUpdateTime:(NSString *)updateTime;
//
////记录登录状态到默认配置
//+ (void)recordConfiguration;
//
////------------------------获取用户头像----------------------//
//+ (UIImage *)getUserHead:(NSString *)userid;
//
//
////------------------------登录证书设备----------------------//
//
//+ (void)showAttention:(NSString *)attentionMsg sender:(id)sender;
//+ (void)showAttentionWithTitle:(NSString *)title message:(NSString *)attentionMsg sender:(id)sender;
////+ (void)showUpdateAlert:(HBUpdateInfo *)updateInfo withSender:(id)sender;
//
////------------------------时间日期处理----------------------//
////获取日期  格式为：yyyy-MM-dd
//+(NSString *)getDateWithYMD:(NSDate *)date;
//
////获取日期  格式为：yyyy年MM月dd日
//+(NSString *)getDateWithYMDCN:(NSDate *)date;
//
////获取日期  格式为：yyyy年MM月dd日 星期几
//+(NSString *)getDateWithWeek:(NSDate *)date;
//
////获取时间  格式为：HH:mm
//+(NSString *)getTimeHHmm:(NSDate *)date;
//
////获取时间  格式为：HH:mm:SS
//+(NSString *)getTimeHmS:(NSDate *)date;
//
////转换日期格式  toCN=yes  yyyy-MM-dd <========> yyyy年MM月dd日 toCN=no
//+(NSString *)translateDate:(NSString *)dateStr toCN:(BOOL)isture;
//
////转换日期格式  今天、昨天、前天
//+ (NSString*)processDate:(NSString*)sourceDateStr;
//+ (NSString*)processNSDate:(NSDate*)sourceDate;
//
////计算指定时间与当前时间差
//+ (NSString *)calculateTimeIntervalSinceNow:(NSString *)rdate withTime:(NSString *)rtime;
//
////获取当前日期  格式为 ddMMyy 当做短信验证码用
//+ (NSString *)getVerifyCode;
//
////-------------------------其他---------------------------//
//+ (UIColor *)greenColor;
//
////图片尺寸质量压缩： level=1:宽度600 压缩比例0.6 level=2:宽度64 压缩比例0.2
//+ (UIImage *)compressImage:(UIImage *)image toLevel:(NSInteger)level;
//+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
//+ (NSString *)transferUrlHtmlStr:(NSString *)orignStr;
//@end
//
//
