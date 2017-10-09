//
//  HBOnlineBusiness.h
//  hbmiddleware
//
//  Created by hebca on 13-11-21.
//  Copyright (c) 2013年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBApplicationItem.h"
#import "HBEnumType.h"
#import "HBDevice.h"
#import "HBCert.h"
@interface HBOnlineBusiness : NSObject

- (id)initWithServerURL:(NSString*)url;
- (id)initWithServerURL:(NSString*)url timeoutInterval:(NSTimeInterval)timeoutInterval;

/*
 功能描述：获取申请单填报要素。
 参数： 
 参数	    类型	       输入/输出	 描述
 projectID	NSString*	IN	     项目编号
 type	HB_ONLINE_BUSINESS_TYPE	OUT	业务类型
 返回值：HBApplicationItem对象的数组，如果失败，返回nil。
 */
-(NSArray*)getApplicationFormInfo:(NSString*)projectID type:(HB_ONLINE_BUSINESS_TYPE)type;

/*
 功能描述：提交申请单。
 参数：          
 参数	            类型	           输入/输出	  描述
 projectID          NSString*       IN      项目编号
 applicationForm	NSArray*	IN	      HBApplicationItem对象的数组
 businessType	HB_ONLINE_BUSINESS_TYPE	 IN	                业务类型

 返回值：成功返回受理编号，如果失败，返回nil。
 */
-(NSString*)submitApplicationForm:(NSString*)projectID
                  applicationForm:(NSArray*)applicationForm
                     businessType:(HB_ONLINE_BUSINESS_TYPE)businessType;
/*
 功能描述：查询受理编号。
 参数：
 参数	        类型	                     输入/输出	        描述
 operatorName	NSString*	             IN	                经办人
 operatorPhone	NSString*	             IN	                经办人手机号
 identityCard	NSString*	             IN	                经办人身份证号
 businessType	HB_ONLINE_BUSINESS_TYPE	 IN	                业务类型
 返回值：成功返回HBAcceptNoInfo对象的数组，如果失败，返回nil。
 */
-(NSArray*)queryAcceptNumber:(NSString*)operatorName
               operatorPhone:(NSString*)operatorPhone
                     identityCard:(NSString*)identityCard
                businessType:(HB_ONLINE_BUSINESS_TYPE)businessType;

/*
 功能描述：根据设备串号查询受理编号。
 参数：
 参数	        类型	                     输入/输出	        描述
 serialNumber	NSString*	             IN	                设备串号
 businessType	HB_ONLINE_BUSINESS_TYPE	 IN	                业务类型
 返回值：成功返回HBAcceptNoInfo对象的数组，如果失败，返回nil。
 */
-(NSArray*)queryAcceptNumberBySN:(NSString*)serialNumber
                     businessType:(HB_ONLINE_BUSINESS_TYPE)businessType;

/*
 功能描述：获取申请单数据
 参数：
 参数	        类型	       输入/输出	描述
 acceptNumber	NSString*	IN   	受理编号
 返回值：成功返回HBApplicationItem对象的数组，如果失败，返回nil。
 */
-(NSArray*)queryApplicationForm:(NSString*)acceptNumber;

/*
 功能描述：获取申请单数据
 参数：
 参数	        类型	        输入/输出	  描述
 acceptNumber	NSString*	IN	      受理编号
 itemNames	    NSArray*	IN	      申请单项名称的数组
 返回值：成功返回申请单项名称(NSString)、值(NSString)的键值对，如果失败，返回nil。
 */
-(NSDictionary*)queryApplicationItemsData:(NSString*)acceptNumber
                            itemName:(NSArray*)itemNames;

/*
 功能描述：提交收费方案
 参数：
 参数	        类型	                输入/输出	  描述
 acceptNumber	NSString*       	IN	      受理编号
 chargingSchemeId	NSString*	IN	      收费方案
 返回值：成功返回HB_OK，如果失败，返回错误码。
 */
-(NSInteger)submitChargingScheme:(NSString*) acceptNumber
                  chargingScheme:(NSString*)chargingSchemeId;

/*
 功能描述：获取收费方案信息
 参数：
 参数	        类型	                    输入/输出 	描述
 acceptNumber	NSString*	            IN	      受理编号
 返回值：成功返回收费方案相关信息，如果失败，返回nil。
 */
-(NSDictionary*)queryChargingSchemeInfo:(NSString*)acceptNumber;

/*
 功能描述：查询业务状态
 参数：
 参数	        类型     	输入/输出	 描述
 acceptNumber	NSString*	IN	     受理编号
 返回值：返回业务当前状态
 */
-(HB_ONLINE_BUSINESS_STATUS)queryBusinessStatus:(NSString*)acceptNumber;

/*
 功能描述：请求短信验证码
 参数：  
 参数	        类型	        输入/输出	 描述
 acceptNumber	NSString*	IN	     受理编号
 返回值：成功返回HB_OK，并向受理编号对应申请单中的经办人手机号发送验证码短信，失败返回错误码
 */
-(NSInteger)requestVerificationCode:(NSString*)acceptNumber;

/*
 功能描述：验证短信验证码
 参数：
 参数	        类型	                    输入/输出	 描述
 acceptNumber	NSString*           	IN	     受理编号
 verificationCode	NSString*	        IN	     短信验证码
 返回值：验证通过返回HB_OK，失败返回HB_FAILED
 */
-(NSInteger)checkVerificationCode:(NSString*)acceptNumber
                 verificationCode:(NSString*)verificationCode;
/*
 功能描述：新办、延期、补办业务的证书安装
 参数：
 参数	            类型	        输入/输出	 描述
 acceptNumber   	NSString*	IN	     受理编号
 verificationCode	NSString*	IN	     短信验证码
 device	            HBDevice*	IN	     设备对象
 返回值：成功返回HB_OK，失败返回错误码
*/
-(NSInteger)certInstall:(NSString*) acceptNumber
       verificationCode:(NSString*)verificationCode
          ansymmtricAlg:(HB_ANSYMMTRIC_TYPE)ansymmtricType
                 device:(HBDevice*)device;

/*
 功能描述：下载服务器端生成的软证书
 参数：
 参数	            类型	        输入/输出	 描述
 acceptNumber	    NSString*	IN	     受理编号
 verificationCode	NSString*	IN	     短信验证码
 device	            HBDevice*	IN	     设备对象
 返回值：成功返回HB_OK，失败返回错误码
 */
-(NSInteger)certDownload:(NSString*) acceptNumber
        verificationCode:(NSString*)verificationCode
                  device:(HBDevice*)device;

/*
 功能描述：证书解锁
 参数：
 参数	            类型	        输入/输出	 描述
 acceptNumber	    NSString*	IN	     受理编号
 verificationCode	NSString*	IN	     短信验证码
 cert	            HBCert*	IN	     证书对象
 返回值：成功返回HB_OK，失败返回错误码
 */
-(NSInteger)certUnlock:(NSString*) acceptNumber
      verificationCode:(NSString*)verificationCode
                cert:(HBCert*)cert;

@end
