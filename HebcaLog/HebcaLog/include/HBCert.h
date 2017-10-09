//
//  HBCert.h
//  hbmiddleware
//
//  Created by hebca on 13-11-21.
//  Copyright (c) 2013年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBEnumType.h"
#import "HBErrorCode.h"

@class HBDevice;

#define HB_DN_COMMON_NAME @"CN"
#define HB_DN_COUNTRY @"C"
#define HB_DN_ORG @"O"
#define HB_DN_ORG_UNIT  @"OU"
#define HB_DN_STATE @"S"
#define HB_DN_LOCAL @"L"
#define HB_DN_EMAIL @"E"
#define HB_DN_GIVEN_NAME @"G"
#define HB_DN_TITLE @"T"
#define HB_DN_SURNAME @"SN"
#define HB_DN_INITIALS @"Initials"
#define HB_DN_POSTAL_ADDRESS @"PostalAddress"
#define HB_DN_POSTAL_CODE @"PostalCode"
#define HB_DN_POSTAL_OFFICE_BOX @"PostalOfficeBox"
#define HB_DN_PHONE @"Phone"
#define HB_DN_ALIAS @"Alias"


@interface HBCert : NSObject

/*
 功能描述：装载驱动对象。
 参数：
 参数	       类型	输入/输出	描述
 deviceDriver	id	IN	设备驱动对象
 返回值：无
 备注：该方法用于内部功能实现，不对外暴露。
 */
-(void)setDeviceDriver:(id)deviceDriver;

/*
 功能描述：获取驱动对象。
 参数：无
 返回值：驱动对象
 备注：该方法用于内部功能实现，不对外暴露。
 */
-(id)getDeviceDriver;


-(void)setDevice:(HBDevice*)device;

-(HBCert*)initWithDERCert:(NSData*)derCert;

/*
功能描述：初始化数据签名操作。
参数：
参数          类型          输入/输出	描述
digestAlg	HB_DIGEST_ALG	IN      摘要算法
返回值：成功返回HB_OK，出错时返回错误码。
备注：调用signDataInit 后，应用可以调用signData签名单部分中的数据，或者先调用signDataUpdate 零次或多次，
 接着调用signDataFinal 来签名多部分中的数据。数据签名操作是现用的，直到应用调用signData或signDataFinal 确实获得最后的签名数据。
 要处理另外的数据（单部分或多部分），应用必须再次调用signDataInit。
*/
 -(NSInteger) signDataInit:(HB_DIGEST_ALG)digestAlg;


/*
 功能描述：签名单部分中的数据。
 参数：
 参数	类型      输入/输出	描述
 pData	NSData*     IN      数据
 
 返回值：签名结果，如果出错，返回nil。
 备注：数据签名操作必须用signDataInit 来预置。调用signData总是会终止现用的签名操作。
 不能用signData来结束一个多部分操作，必须在不插入signDataUpdate调用的情况下在signDataInit之后调用。
 signData相当于一系列signDataUpdate 操作后面跟着signDataFinal 。
 */
-(NSData*)signData:(NSData*)pData; 

/*
 功能描述：继续多部分数据签名操作，处理另一个数据部分。
 参数：
 参数	类型	输入/输出	描述
 pPart	NSData*	IN	数据
 
 返回值：成功返回HB_OK，失败返回错误码。
 */
-(NSInteger) signDataUpdate:(NSData*)pPart;

/*
 功能描述：结束多部分数据签名操作，返回签名结果。
 参数：无
 返回值：签名结果，如果出错，返回nil。
 备注：
 */
-(NSData*)signDataFinal;


/*
 功能描述：初始化验证签名操作。
 参数：
 参数         类型          输入/输出	描述
 digestAlg	HB_DIGEST_ALG	IN      摘要算法
 返回值：成功返回HB_OK，出错时返回错误码。
 备注：调用verifySignedDataInit 后，应用可以调用verifySignedData验证单部分中的数据签名，或者先调用verifySignedDataUpdate 零次或多次，接着调用verifySignedDataFinal 来验证多部分中的数据数据。签名验证操作是现用的，直到应用调用verifySignedData或verifySignedDataFinal 确实获得最后的验证结果。要处理另外的数据（单部分或多部分），应用必须再次调用verifySignedDataInit。
 */
-(NSInteger) verifySignedDataInit:(HB_DIGEST_ALG) digestAlg;


/*
 功能描述：验证单部分中的数据签名。
 参数：
 参数         类型	输入/输出	描述
 pData      NSData*	IN      数据
 pSignature	NSData*	IN      签名
 
 返回值：签名验证结果，验证成功，返回HB_OK，验证失败，返回HB_HBCERT_SIGNATURE_INVALID。
 备注：数据签名操作必须用verifySignedDataInit 来预置。调用verifySignedData总是会终止现用的签名操作。不能用verifySignedData来结束一个多部分操作，必须在不插入verifySignedDataUpdate调用的情况下在verifySignedDataInit之后调用。
 verifySignedData相当于一系列verifySignedDataUpdate 操作后面跟着verifySignedDataFinal 。
 */
-(NSInteger)verifySignedData:(NSData*)pData signature:(NSData*)pSignature;


/*
 功能描述：继续多部分数据验证签名操作，处理另一个数据部分。
 参数：
 参数	类型	输入/输出	描述
 pPart	NSData*	IN	数据
 
 返回值：成功返回HB_OK，失败返回错误码。
 备注：
 */
-(NSInteger) verifySignedDataUpdate:(NSData*)pPart;


/*
功能描述：结束多部分数据验证签名操作，返回签名结果。
参数：
参数          类型	输入/输出	描述
pSignature	NSData*	IN      签名
返回值：签名验证结果，验证成功，返回HB_OK，验证失败，返回HB_HBCERT_SIGNATURE_INVALID。
备注：
*/
-(NSInteger)verifySignedDataFinal:(NSData*)pSignature;



/*
功能描述： 对数据进行签名。
参数：
参数          类型          输入/输出	描述
digestAlg	HB_DIGEST_ALG	IN	摘要算法
inMessage	NSData*         IN	被签名数据
contain     BOOL            IN	是否包含原文
certChain	NSArray*        IN	证书链，NSString对象的集合，NSString对象包含base64编码的证书
crls        NSarray*        IN	证书撤销列表，NSString对象的集合，NSString对象包含base64编码的证书列表
返回值： 消息签名。
备注：
*/
-(NSData*)signMessage:(HB_DIGEST_ALG)digestAlg
           message:(NSData*)inMessage
    containMessage:(BOOL)contain
  certificateChain:(NSArray*)certChain
                 CRLs:(NSArray*)crls;


/*
 功能描述：解密消息。
 参数：
 参数	            类型	        输入/输出  	描述
 encryptedMessage	NSData*	    IN	        加密结果
 isUseDeviceAlg     BOOL        IN          是否使用设备硬算法
 
 返回值：解密后的消息。
 备注：
 */
- (NSData*)decryptMessage:(NSData*)encryptedMessage
               useDeviceAlg:(BOOL)isUseDeviceAlg;


/*
功能描述：用HBCert对象对应的公钥加密数据。
参数：
参数              类型      输入/输出	描述
pData           NSData*     IN      数据

返回值：加密结果，失败返回nil。
备注：
 */
-(NSData*)encryptData:(NSData*)pData;

/*
功能描述：用HBCert对象对应的私钥解密数据。
参数：
参数              类型	输入/输出	描述
pEncryptedData	NSData*	IN      加密后的数据

返回值：解密结果，失败返回nil。
备注：
 */
-(NSData*)decryptData:(NSData*)pEncryptedData;

/*
功能描述：获取DER编码格式的证书数据。
参数：无
返回值：DER格式的证书数据，如果失败，返回nil。
备注：
 */
-(NSData*)getDERCertData;

/*
功能描述：获取base64编码格式的证书数据。
参数：无
返回值：base64格式的证书数据，如果失败，返回nil。
备注：
 */
-(NSString*)getBase64CertData;

/*
功能描述：获取数字证书绑定的IOS设备唯一标识。
参数：无
返回值：IOS设备唯一标识，如果失败，返回nil。
备注：
 */
-(NSString*)getBindingDeviceId;


/*
功能描述：获取数字证书绑定的手机号。
参数：无
返回值：绑定手机号，如果失败，返回nil。
备注：
 */
-(NSString*) getBindingMobileNumber;

/*
功能描述：获取数字证书编码版本。
参数：无
返回值：版本，如果失败，返回nil。
备注：
*/
-(NSNumber*)getVersion;

/*
功能描述：获取数字证书16进制形式的序列号。
参数：无
返回值：序列号字符串，如果失败，返回nil。
备注：
*/
-(NSString*)getSerialNumberHex;

/*
 功能描述：获取数字证书10进制形式的序列号。
 参数：无
 返回值：序列号字符串，如果失败，返回nil。
 备注：
 */
-(NSString*)getSerialNumberDec;

/*
功能描述：获取数字证书的签名算法。
参数：无
返回值：签名算法，如“sha1RSA”，如果失败，返回nil。
备注：
*/
-(NSString*)getSignAlg;

/*
功能描述：获取数字证书认证机构的相关信息。
参数：无
返回值：数字证书认证机构的相关信息，如果失败，返回nil。
备注：
 */
-(NSString*)getIssuer;

/*
功能描述：获取数字证书认证机构的某一项的具体信息。
参数：
参数      类型      输入/输出	描述
pIndex	NSString*	IN      指定具体项，如“O”“CN”等

返回值：数字证书认证机构的某一项的具体信息，如果失败，返回nil。
备注：。
*/
-(NSString*)getIssuerItem:(NSString*)pIndex;

/*
功能描述：获取数字主题的相关信息。
参数：无
返回值：数字证书主题的相关信息，如果失败，返回nil。
备注：
*/
-(NSString*)getSubject;

/*
功能描述：获取数字证书主题的某一项的具体信息。
参数：
参数	类型	输入/输出	描述
pIndex	NSString*	IN	指定具体项，如“O”“CN”等
 
返回值：数字证书主题的某一项的具体信息，如果失败，返回nil。
备注：。
*/
-(NSString*) getSubjectItem:(NSString*)pIndex;

/*
功能描述：获取数字证书有效期的起始日期。
参数：无
返回值：起始日期，如果失败，返回nil。
备注：
*/
-(NSDate*)getNotBefore;

/*
功能描述：获取数字证书有效期的截止日期。
参数：无
返回值：截止日期，如果失败，返回nil。
备注：
*/
-(NSDate*)getNotAfter;

/*
功能描述：获取数字证书中的公钥数据。
参数：无
返回值：二进制形式公钥数据，如果失败，返回nil。
备注：
*/
-(NSData*)getPublicKey;

/*
功能描述：获取数字证书中的密钥用法。
参数：无
返回值：密钥用法，如果失败，返回0。
备注：HB_KEY_USAGE_TYPE类型定义密钥用法标识，返回值使用OR运算符对各种用法进行组合。
*/
-(int)getUsage;

/*
 功能描述：是否为签名证书。
 参数：无
 返回值：如果为签名证书，返回YES。
 备注：
 */
-(BOOL)isSignCert;

/*
 功能描述：是否为加密证书。
 参数：无
 返回值：如果为加密证书，返回YES。
 备注：
 */
-(BOOL)isEncryptCert;

/*
功能描述：获取数字证书中的公钥类型。
参数：无
返回值：公钥类型，如果失败，返回nil。
备注：
*/
-(HB_ANSYMMTRIC_TYPE)getPublicKeyType;

/*
功能描述：检查数字证书设备是否存在。
参数：
返回值：存在，返回YES，未找到，返回NO。
备注：
*/
-(BOOL)deviceIsOnline;

/*
功能描述：登录设备。
参数：
参数          类型      输入/输出	描述
pUserPin	NSString*	IN      设备密码

返回值：登录成功，返回HB_OK，如果失败，返回错误码。
备注：
*/
-(NSInteger)loginDevice:(NSString*)pUserPin;

/*
功能描述：登录设备，会弹出界面供用户输入设备密码。
参数：无
返回值：登录成功，返回HB_OK，如果失败，返回错误码。
备注：
定义：
 */
-(NSInteger)loginDeviceWithUI;


- (NSInteger)loginDeviceWithUI:(id)control;

/*
功能描述：检查数字证书设备是否已经登录。
参数：
返回值：已经登录，返回YES，未登录，返回NO。
备注：
 */
-(BOOL)deviceIsLogined;

/*
功能描述：登出设备。
参数：无
返回值：登出成功，返回HB_OK，如果失败，返回错误码。
备注：登出设备之后，如果用户调用使用私钥的相关方法，会弹出界面，要求用户输入设备密码。
*/
-(NSInteger)logoutDevice;


/*
功能描述：获取数字证书对应的设备对象，代表数字证书的存储介质。
参数：无
返回值：密钥用法，如果失败，返回nil。
备注：
*/
-(HBDevice*)getDevice;

/*
 功能描述：获取签名证书匹配的摘要算法
 参数：无
 返回值：如果签名证书为RSA证书，则为HB_SHA1、HB_MD5,如果签名证书为SM2证书，则为HB_SM3.
 */
-(HB_DIGEST_ALG)getSupportDigestAlg;

@end
