//
//  HBMiddleWare.h
//  hbmiddleware
//
//  Created by hebca on 13-11-21.
//  Copyright (c) 2013年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBEnumType.h"
#include "HBErrorCode.h"
#import "HBDevice.h"
#import "HBCert.h"

//设置错误
#define HB_SET_ERROR(error) [HBMiddleWare setLastError:error];
//设置错误号和错误描述
#define HB_SET_ERROR_MESSAGE(error,message)  [HBMiddleWare setLastError:error withMessage:message];
//获取新近的错误号
#define HB_LAST_ERROR ([HBMiddleWare lastError])
//获取新近的错误描述
#define HB_LAST_ERROR_MESSAGE [HBMiddleWare lastErrorMessage]
//返回是否为成功
#define HB_IS_SUCCESS(error) (error==HB_OK)
//返回是否为错误
#define HB_IS_FAILED(error) (error!=HB_OK)

/*
 中间件接口
 */

@interface HBMiddleWare : NSObject


/*
 功能描述：获取应用开发接口的版本。
 参数：无
 返回值：版本号字符串，不能正确返回时，返回nil。
 备注： 版本号字符串的格式为X.X.X，如1.0.0。
 */
+ (NSString*)getMiddleWareVersion;

/*
 功能描述：获取能够唯一标识一台IOS设备的标识信息。
 参数：无
 返回值：IOS设备唯一标识，不能正确返回时，返回nil。
 备注：
 */
+ (NSString*)getIOSDeviceId;

/*
 功能描述：初始化消息摘要操作，设定消息摘要的算法。
 参数：
 参数	    类型	            输入/输出	 描述
 digestAlg	HB_DIGEST_ALG	IN	     摘要算法
 
 返回值：成功返回HB_OK，失败返回错误码。
 备注：调用digestInit 后，应用可以调用digest 摘要单部分中的数据，或者先调用digestUpdate 零次或多次，接着调用digestFinal 来摘要多部分中的数据。消息摘要操作是现用的，直到应用调用digest 或digestFinal 确实获得最后的密文。要处理另外的数据（单部分或多部分），应用必须再次调用digestInit。
 */
+ (NSInteger)digestInit:(HB_DIGEST_ALG)digestAlg;

/*
 功能描述：摘要单部分中的数据。
 参数：
 参数	类型	    输入/输出	  描述
 pData	NSData*	IN	      数据
 
 返回值：消息摘要，如果出错，返回nil。
 备注：摘要操作必须用digestInit 来预置。调用digest 总是会终止现用的摘要操作。不能用digest来结束一个多部分操作，必须在不插入digestUpdate调用的情况下在digestInit之后调用。
 digest 相当于一系列digestUpdate 操作后面跟着digestFinal 。
 */
+ (NSData*)digest:(NSData*)pData;

/*
 功能描述：继续多部分消息摘要操作，处理另一个数据部分。
 参数：
 参数	类型	     输入/输出	描述
 pPart	NSData*	 IN	        数据
 
 返回值：成功返回HB_OK，失败返回错误码。
 备注：
 */
+ (NSInteger)digestUpdate:(NSData*)pPart;

/*
 功能描述：结束多部分消息摘要操作，返回消息摘要。
 参数：无
 返回值：消息摘要，如果出错，返回nil。
 备注：
 */
+ (NSData*)digestFinal;

/*
 功能描述：生成对称加密密钥。
 参数：
 参数	     类型	            输入/输出 	描述
 encryptAlg	 HB_ ENCRYPT_ALG	IN	        对称加密算法
 
 返回值：成功返回生成的密钥，如果失败，返回nil。
 备注：
 */
+ (NSData*)generateSymmetricKey:(HB_SYMMETRIC_ALG)encryptAlg;

/*
 功能描述：初始化数据加密操作，设定对称加密的算法。
 参数：
 参数	     类型	            输入/输出   描述
 encryptAlg	 HB_ENCRYPT_ALG	    IN	      对称加密算法
 algParam	 NSData*	        IN	      算法参数，对于CBC模式，通过该参数出入iv
 pKey	     NSData*	        IN	      密钥
 
 返回值：成功返回HB_OK，失败返回错误码。
 备注：调用encryptInit 后，应用可以调用encrypt加密单部分中的数据，或者先调用encryptUpdate 零次或多次，接着调用encryptFinal 来加密多部分中的数据。加密操作是现用的，直到应用调用encrypt或encryptFinal 确实获得最后的密文。要处理另外的数据（单部分或多部分），应用必须再次调用encryptInit。
 */
+ (NSInteger)encryptInit:(HB_SYMMETRIC_ALG)encryptAlg
       algParameter:(NSData*)algParam
                key:(NSData*)pKey;

/*
 功能描述：加密单部分中的数据。
 参数：
 参数	类型	     输入/输出	描述
 pData	NSData*	 IN	        数据
 
 返回值：加密数据，如果出错，返回nil。
 备注：加密操作必须用encryptInit 来预置。调用encrypt总是会终止现用的加密操作。不能用encrypt来结束一个多部分操作，必须在不插入encryptUpdate调用的情况下在encryptInit之后调用。
 encrypt相当于一系列encryptUpdate 操作后面跟着encryptFinal 。
 */
+ (NSData*)encrypt:(NSData*)pData;

/*
 功能描述：继续多部分数据加密操作，处理另一个数据部分。
 参数：
 参数	类型	     输入/输出	描述
 pPart	NSData*	 IN	        数据
 
 返回值：加密数据，如果出错，返回nil。
 备注：
 */
+ (NSData*) encryptUpdate:(NSData*)pPart;

/*
 功能描述：结束多部分数据加密操作，返回最后一部分加密数据。
 参数：无
 返回值：加密数据，如果出错，返回nil。
 备注：
 */
+ (NSData*)encryptFinal;

/*
 功能描述：初始化数据解密操作，设定对称加密的算法。
 参数：
 参数	     类型	         输入/输出	描述
 encryptAlg	 HB_ENCRYPT_ALG	 IN	        对称加密算法
 algParam	 NSData*	     IN	        算法参数，对于CBC模式，通过该参数出入iv
 pKey	     NSData*	     IN	        密钥
 
 返回值：成功返回HB_OK，失败返回错误码。
 备注：调用decryptInit 后，应用可以调用decrypt解密单部分中的数据，或者先调用decryptUpdate 零次或多次，接着调用decryptFinal 来解密多部分中的数据。解密操作是现用的，直到应用调用decrypt或decryptFinal 确实获得最后的明文。要处理另外的数据（单部分或多部分），应用必须再次调用decryptInit。
 */
+ (NSInteger)decryptInit:(HB_SYMMETRIC_ALG)encryptAlg
       algParameter:(NSData*)algParam
                key:(NSData*)pKey;

/*
 功能描述：解密单部分中的数据。
 参数：
 参数	类型	     输入/输出	描述
 pData	NSData*	 IN	        数据
 
 返回值：明文数据，如果出错，返回nil。
 备注：解密操作必须用decryptInit 来预置。调用decrypt总是会终止现用的解密操作。不能用decrypt来结束一个多部分操作，必须在不插入decryptUpdate调用的情况下在decryptInit之后调用。
 decrypt相当于一系列decryptUpdate 操作后面跟着decryptFinal 。
 */
+ (NSData*)decrypt:(NSData*)pData;

/*
 功能描述：继续多部分数据解密操作，处理另一个数据部分。
 参数：
 参数	类型	     输入/输出	描述
 pPart	NSData*	 IN	        数据
 
 返回值：明文数据，如果出错，返回nil。
 备注：
 */
+ (NSData*)decryptUpdate:(NSData*)pPart;

/*
 功能描述：结束多部分数据解密操作，返回最后一部分明文数据。
 参数：无
 返回值：明文数据，如果出错，返回nil。
 备注：
 */
+ (NSData*)decryptFinal;


/*
 消息加解密：当公钥算法为RSA时，加密结果的结构遵循PKCS#7；当公钥算法为SM2时，加密结果的结构遵循 GM/T 0010。
 */
/*
 功能描述：加密消息。
 参数：
 参数	            类型	                输入/输出	  描述
 encryptAlg	        HB_SYMMETRIC_ALG	IN	      对称加密算法,RSA算法支持3DES，SM2算法支持SM1、SM4，都只支持CBC_PAD模式
 certsArray	        NSArray*	        IN	      加密会话秘钥的公钥证书HBCert对象列表
 inMessage	        NSData*	            IN	      被加密消息
 useDevice          HBDevice *          IN        加密时使用的设备，如果为nil，表示不使用设备，使用软算法
 
 返回值：加密结果。
 备注：
 */
+ (NSData*)encryptMessage:(HB_SYMMETRIC_ALG)encryptAlg
           certificate:(NSArray*)certsArray
               message:(NSData*)inMessage
                useDevice:(HBDevice *)device;


/*
 功能描述： 验证消息签名。
 参数：
 参数              类型         输入/输出	描述
 signedMessage	 NSData*        IN      签名结果
 inMessage       NSData*        IN      如果消息不包含原文，需要通过该参数传入原文；否则传nil
 
 返回值： 验证通过返回HB_OK，否则返回错误码。
 备注：
 */
+(NSInteger)verifySignedMessage:(NSData*)signedMessage
                        message:(NSData*)inMessage;


/*
 功能描述： 获取签名消息信息。
 参数：
 参数             类型          输入/输出      描述
 signedMessage   NSData*        IN          签名消息
 inMessage       NSData**       OUT         获取被签名数据，如果输入为nil，则表示不获取原文，如果签名消息中不包含原文，则输出为nil
 cert            NSString**     OUT         获取签名证书，如果输入为nil，则表示不获取
 certChain       NSArray**      OUT         获取证书链，NSString对象的集合，NSString对象包含base64编码的证书，如果输入为nil，则表示不获取
 crls            NSArray**      OUT         获取证书撤销列表，NSString对象的集合，NSString对象包含base64编码的证书列表，如果输入为nil，则表示不获取

 返回值： 成功返回HB_OK，失败返回错误码。
 备注：
 */
+(NSInteger)getSignMessageInfo:(NSData*)signedMessage
                       message:(NSData**)inMessage
                      signCert:(NSString**)cert
              certificateChain:(NSArray**)certChain
                          CRLs:(NSArray**)crls;

/*
 功能描述：列举设备
 参数：无
 返回值：无
 */
+ (void)reloadDevice;

/*
 功能描述：获取当前可用的指定类型数字证书介质列表
 参数：
 参数	      类型	            输入/输出	  描述
 deviceType	  HB_DEVICE_TYPE	IN	      证书介质类型
 certType	  HB_CERT_TYPE	    IN	      数字证书类型
 
 返回值：当前可用证书介质HBDevice对象的列表，以NSArray对象的形式返回，如果出错，则返回nil。
 */
+ (NSArray*)getDeviceList:(HB_DEVICE_TYPE)deviceType;

/*
 功能描述：获取当前可用的数字证书列表
 参数：
 参数	      类型	          输入/输出	描述
 certType	  HB_CERT_TYPE	  IN	    数字证书类型
 deviceType	  HB_DEVICE_TYPE  IN	    证书介质类型
 
 返回值：当前可用证书HBCert对象的列表，以NSArray对象的形式返回，如果出错，则返回nil。
 */
+ (NSArray*)getCertList:(HB_CERT_TYPE)certType
         forDeviceType:(HB_DEVICE_TYPE)deviceType;

/*
 功能描述：从证书数据构造HBCert对象。
 参数：
 参数	        类型	      输入/输出	描述
 pDERCertData	NSData*	  IN	    DER编码格式的证书数据
 
 返回值：从指定证书数据构造的HBCert对象，则返回nil。
 */
+ (HBCert*)getCertFromDERCert:(NSData*)pDERCertData;

/*
 功能描述：从证书数据构造HBCert对象。
 参数：
 参数	            类型	        输入/输出	  描述
 pBase64CertData	NSString*	IN	      Base64编码格式的证书数据
 
 返回值：从指定证书数据构造的HBCert对象，则返回nil。
 */
+ (HBCert*)getCertFromBase64Cert:(NSString*)pBase64CertData;

/*
 功能描述：返回指定数字证书设备HBDevice对象
 参数：
 参数	       类型	            输入/输出	    描述
 deviceType	   HB_DEVICE_TYPE	IN	        证书介质类型
 
 返回值：指定的HBDevice对象，如果出错，则返回nil。
 备注：如果满足参数条件的有多个对象，则弹出界面让用户选择；如果只有一个对象满足条件则直接返回该对象。
 */
+ (HBDevice*)getDevice:(HB_DEVICE_TYPE)deviceType;

/*
 功能描述：获取指定的数字证书HBCert对象
 参数：
 参数	    类型	            输入/输出	   描述
 certType	HB_CERT_TYPE	IN	       数字证书类型
 deviceType	HB_DEVICE_TYPE	IN	       证书介质类型
 
 返回值：指定的数字证书HBCert对象，如果出错，则返回nil。
 备注：如果有多个数字证书对象满足条件，则弹出界面让用户选择；如果只有一个数字证书满足参数条件，则直接返回该对象。
 */
+ (HBCert*)getCert:(HB_CERT_TYPE)certType
     forDeviceType:(HB_DEVICE_TYPE)deviceType;



/*
 功能描述：获取最近错误的错误号
 参数：无 
 返回值：错误号
 */
+ (NSInteger) lastError;

/*
 功能描述：获取最近错误的错误描述
 参数：无
 返回值：错误描述
 */
+ (NSString*) lastErrorMessage;

/*
 功能描述：设置错误号
 参数：
 参数	    类型	            输入/输出	   描述
 error	NSInteger           IN	       错误号
 
 返回值：设置的错误号
 */
+ (NSInteger) setLastError:(NSInteger)error;

/*
 功能描述：设置错误号和描述
 参数：
 参数	    类型	            输入/输出	   描述
 error      NSInteger       IN	       错误号
 message    NSString*       IN         错误描述
 
 返回值：设置的错误号
 */
+ (NSInteger) setLastError:(NSInteger)error withMessage:(NSString*) message;

/*
 功能描述：Base64编码
 参数：
 参数	    类型	            输入/输出	   描述
 data       NSData*         IN	       待编码数据
 
 返回值：编码后Base64字符串
 */
+ (NSString*) base64Encode:(NSData * )data;

/*
 功能描述：Base64解码
 参数：
 参数	    类型	            输入/输出	   描述
 data       NSString*         IN	   Base64数据
 
 返回值：解码后数据
 */
+ (NSData*) base64Decode:(NSString*)base64Data;

/*
 功能描述：新建软设备。
 参数：
 参数             类型      输入/输出	描述
 deviceLabel	NSString*	IN      软设备标示
 返回值：成功返回HB_OK，如果失败，返回错误码。
 备注：
 */
+ (NSInteger)createSoftDevice:(NSString *)deviceLabel;

/*
 功能描述：删除软设备。
 参数：
 参数             类型      输入/输出	描述
 deviceLabel	NSString*	IN      软设备标示
 返回值：成功返回HB_OK，如果失败，返回错误码。
 备注：
 */
+ (NSInteger)deleteSoftDevice:(NSString *)deviceLabel;

/*
 功能描述：设置是否自动提示登录。
 参数：
 参数             类型      输入/输出	描述
 autoLogin	     BOOL	   IN        需要登录时，是否自动提示登录
 返回值：无
 备注：
 */
+(void)setAutoLogin:(BOOL)autoLogin;

/*
 功能描述：获取是否自动提示登录。
 参数：无
 返回值：需要登录时，是否自动提示登录
 备注：
 */
+(BOOL)getAutoLogin;

@end




