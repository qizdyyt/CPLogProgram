////
////  HBDevice.h
////  hbmiddleware
////
////  Created by hebca on 13-11-21.
////  Copyright (c) 2013年 hebca. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "HBEnumType.h"
//
//@class HBCert;
//
//#define FILE_PROPERTY_READ_NEED_LOGIN @"readNeedLogin"
//#define FILE_PROPERTY_WRITE_NEED_LOGIN @"writeNeedLogin"
//#define FILE_PROPERTY_DELETE_NEED_LOGIN @"deleteNeedLogin"
//
//@interface HBDeviceInfo : NSObject
//
//- (id) initWithDictionary:(NSDictionary*)dictionary;
//
//- (NSString*)getLabel;
//
///*
// 功能描述：获取当前设备的生产商ID。
// 参数：无
// 返回值：当前设备的生产商ID，如果出错，则返回nil。
// */
//- (NSString*)getManufacturerID;
//
///*
// 功能描述：获取当前设备的序列号。
// 参数：无
// 返回值：当前设备的序列号，如果出错，则返回nil。
// */
//- (NSString*)getSerialNumber;
//
///*
// 功能描述：获取当前设备的剩余存储空间大小（字节数）。
// 参数：无
// 返回值：当前设备的剩余存储空间大小，出错时返回-1。
// */
//- (NSInteger)getDeviceFreeSpace;
//
///*
// 功能描述：获取当前设备的设备类型。
// 参数：无
// 返回值：当前设备的设备类型。
// */
//- (HB_DEVICE_TYPE)getDeviceType;
//
///*
// 功能描述：获取当前设备类型名称
// 参数：无
// 返回值：当前设备的类型名称，出错时返回nil。
// */
//- (NSString*)getDeviceTypeName;
//
///*
// 功能描述：获取设备支持的摘要算法列表
// 参数：无
// 返回值：摘要算法列表。
// */
//- (NSArray*)getSupportDigestAlgs;
//
///*
// 功能描述：获取设备支持的非对称算法列表
// 参数：无
// 返回值：非对称算法列表。
// */
//- (NSArray*)getSupportAnsymmtricAlgs;
//
///*
// 功能描述：获取设备支持的对称算法列表
// 参数：无
// 返回值：对称算法列表。
// */
//- (NSArray*)getSupportSymmtricAlgs;
//
//@end
//
//@interface HBDevice : NSObject
//
///*
// 功能描述：装载驱动对象。
// 参数：
// 参数            类型      输入/输出    描述
// deviceDriver    id      IN        设备驱动对象
// 返回值：无
// 备注：该方法用于内部功能实现，不对外暴露。
// */
//- (void)setDeviceDriver:(id)deviceDriver;
//
//
//- (id)getDeviceDriver;
//
///*
// 功能描述：获取数字证书对应设备的设备信息对象。
// 参数：无
// 返回值：设备信息对象，如果失败，返回nil。
// 备注：
// */
//- (HBDeviceInfo*)getDeviceInfo;
//
///*
// 功能描述：格式化数字证书设备。
// 参数：
// 参数      类型         输入/输出    描述
// pSOPin      NSString*     IN            设备的SO PIN
// pLabel      NSData*     IN            设备的32字节标记（必须用空白字符填充）
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)initDevice:(NSString*)pSOPin tokenLabel:(NSString*)pLabel;
//
///*
// 功能描述：获取随机数。
// 参数：
// 参数         类型            输入/输出       描述
// iRandomLen     Int            IN           要生成的随机数据的长度
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSData*)generateRandom:(int)iRandomLen;
//
///*
// 功能描述：登录设备。
// 参数：
// 参数        类型            输入/输出      描述
// pUserPin    NSString*    IN          设备密码
// 
// 返回值：登录成功，返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)loginDevice:(NSString*)pUserPin;
//
///*
// 功能描述：登录设备，会弹出界面供用户输入设备密码。
// 参数：无
// 返回值：登录成功，返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)loginDeviceWithUI;
//
//
//- (NSInteger)loginDeviceWithUI:(id)control;
//
///*
// 功能描述：检查数字证书设备是否在线。
// 参数：
// 返回值：已经登录，返回YES，未登录，返回NO。
// 备注：
// */
//- (BOOL)deviceIsOnline;
//
///*
// 功能描述：检查数字证书设备是否已经登录。
// 参数：
// 返回值：已经登录，返回YES，未登录，返回NO。
// 备注：
// */
//- (BOOL)deviceIsLogined;
//
///*
// 功能描述：登出设备。
// 参数：无
// 返回值：登出成功，返回HB_OK，如果失败，返回错误码。
// 备注：登出设备之后，如果用户调用使用私钥的相关方法，会弹出界面，要求用户输入设备密码。
// */
//- (NSInteger)logoutDevice;
//
///*
// 功能描述：修改用户PIN。
// 参数：
// 参数        类型            输入/输出    描述
// pOldPIN    NSString*    IN
// pNewPin    NSString*    IN
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)changeUserPin:(NSString*)pOldPin newPin:(NSString*)pNewPin;
//
///*
// 功能描述：解锁数字证书的用户PIN。
// 参数：
// 参数        类型            输入/输出    描述
// pSOPin        NSString*    IN
// pNewPin    NSString*    IN
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)unlockUserPin:(NSString*)pSOPin newPin:(NSString*)pNewPin;
//
///*
// 功能描述：获取用户PIN可尝试次数。
// 参数：
// 参数            类型        输入/输出    描述
// pRetryTimes    long*    OUT
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注:
// */
//- (NSInteger)getUserPinRetryTimes:(long*)pRetryTimes;
//
///*
// 功能描述：是否支持对称算法。
// 参数：
// 参数         类型                输入/输出      描述
// encryptAlg     HB_ENCRYPT_ALG     IN          对称加密算法
// 
// 返回值：支持返回YES，否则返回NO。
// 备注：
// */
//- (BOOL)isSupportSymmetricAlg:(HB_SYMMETRIC_ALG)encryptAlg;
//
///*
// 功能描述：生成对称加密密钥。
// 参数：
// 参数         类型                输入/输出      描述
// encryptAlg     HB_ENCRYPT_ALG     IN          对称加密算法
// 
// 返回值：成功返回生成的密钥对象，如果失败，返回nil。
// 备注：
// */
//- (id)generateSymmetricKey:(HB_SYMMETRIC_ALG)encryptAlg;
//
///*
// 功能描述：明文导出对称加密密钥。
// 参数：
// 参数    类型    输入/输出    描述
// key    id    IN      密钥对象
// 
// 返回值：成功返回明文密钥，如果失败，返回nil。
// 备注：
// */
//-(NSData*)exportSymmetricKey:(id)key;
//
///*
// 功能描述：密文导出对称加密密钥。
// 参数：
// 参数    类型      输入/输出    描述
// key    id          IN      密钥对象
// cert   HBCert*     IN      用户加密证书，使用该证书的公钥对对称密钥进行非对称加密后导出
// 
// 返回值：成功返回密文密钥，如果失败，返回nil。
// 备注：
// */
//-(NSData*)exportWrapSymmetricKey:(id)key byCert:(HBCert*)cert;
//
///*
// 功能描述：明文导入对称加密密钥。
// 参数：
// 参数                 类型          输入/输出       描述
// encryptAlg     HB_SYMMETRIC_ALG    IN           对称加密算法
// data           NSData*             IN           明文对称密钥
// 
// 返回值：成功返回密钥对象，如果失败，返回nil。
// 备注：
// */
//-(id)importSymmetricKey:(HB_SYMMETRIC_ALG)encryptAlg keyData:(NSData*)data;
//
///*
// 功能描述：密文导入对称加密密钥。
// 参数：
// 参数                 类型          输入/输出       描述
// encryptAlg     HB_SYMMETRIC_ALG    IN           对称加密算法
// wrapData           NSData*         IN           密文对称密钥，需要使用证书私钥先解密
// cert               HBCert*         IN           用户加密证书
// 
// 返回值：成功返回密钥对象，如果失败，返回nil。
// 备注：
// */
//-(id)importWrapSymmetricKey:(HB_SYMMETRIC_ALG)encryptAlg keyData:(NSData*)wrapData byCert:(HBCert*)cert;
//
//
///*
// 功能描述：删除对称加密密钥。
// 参数：
// 参数    类型       输入/输出    描述
// key    id          IN      密钥对象
// 
// 返回值：无。
// 备注：
// */
//-(void)deleteSymmetricKey:(id)key;
//
//
//
///*
// 功能描述：初始化数据加密操作，设定对称加密的算法。
// 参数：
// 参数          类型                输入/输出      描述
// encryptAlg      HB_ ENCRYPT_ALG    IN          对称加密算法
// algParam      NSData*            IN          算法参数，对于CBC模式，通过该参数出入iv
// pKey          id                IN          密钥
// 
// 返回值：成功返回HB_OK，失败返回错误码。
// 备注：调用encryptInit 后，应用可以调用encrypt加密单部分中的数据，或者先调用encryptUpdate 零次或多次，接着调用encryptFinal 来加密多部分中的数据。加密操作是现用的，直到应用调用encrypt或encryptFinal 确实获得最后的密文。要处理另外的数据（单部分或多部分），应用必须再次调用encryptInit。
// */
//- (NSInteger)encryptInit:(HB_SYMMETRIC_ALG)encryptAlg
//       algParameter:(NSData*)algParam
//                key:(id)pKey;
//
///*
// 功能描述：加密单部分中的数据。
// 参数：
// 参数    类型        输入/输出     描述
// pData    NSData*     IN             数据
// 
// 返回值：加密数据，如果出错，返回nil。
// 备注：加密操作必须用encryptInit 来预置。调用encrypt总是会终止现用的加密操作。不能用encrypt来结束一个多部分操作，必须在不插入encryptUpdate调用的情况下在encryptInit之后调用。
// encrypt相当于一系列encryptUpdate 操作后面跟着encryptFinal 。
// */
//- (NSData*)encrypt:(NSData*)pData;
//
///*
// 功能描述：继续多部分数据加密操作，处理另一个数据部分。
// 参数：
// 参数     类型        输入/输出      描述
// pPart     NSData*    IN          数据
// 
// 返回值：加密数据，如果出错，返回nil。
// 备注：
// */
//- (NSData*)encryptUpdate:(NSData*)pPart;
//
///*
// 功能描述：结束多部分数据加密操作，返回最后一部分加密数据。
// 参数：无
// 返回值：加密数据，如果出错，返回nil。
// 备注：
// */
//- (NSData*)encryptFinal;
//
///*
// 功能描述：初始化数据解密操作，设定对称加密的算法。
// 参数：
// 参数          类型                输入/输出      描述
// encryptAlg      HB_ ENCRYPT_ALG    IN          对称加密算法
// algParam      NSData*            IN          算法参数，对于CBC模式，通过该参数出入iv
// pKey          id                IN          密钥
// 
// 返回值：成功返回HB_OK，失败返回错误码。
// 备注：调用decryptInit 后，应用可以调用decrypt解密单部分中的数据，或者先调用decryptUpdate 零次或多次，接着调用decryptFinal 来解密多部分中的数据。解密操作是现用的，直到应用调用decrypt或decryptFinal 确实获得最后的明文。要处理另外的数据（单部分或多部分），应用必须再次调用decryptInit。
// */
//- (NSInteger)decryptInit:(HB_SYMMETRIC_ALG)encryptAlg
//       algParameter:(NSData*)algParam
//                key:(id)pKey;
///*
// 功能描述：解密单部分中的数据。
// 参数：
// 参数    类型        输入/输出     描述
// pData    NSData*    IN         数据
// 
// 返回值：明文数据，如果出错，返回nil。
// 备注：解密操作必须用decryptInit 来预置。调用decrypt总是会终止现用的解密操作。不能用decrypt来结束一个多部分操作，必须在不插入decryptUpdate调用的情况下在decryptInit之后调用。
// decrypt相当于一系列decryptUpdate 操作后面跟着decryptFinal 。
// */
//- (NSData*)decrypt:(NSData*)pData;
//
///*
// 功能描述：继续多部分数据解密操作，处理另一个数据部分。
// 参数：
// 参数    类型         输入/输出    描述
// pPart    NSData*     IN            数据
// 
// 返回值：明文数据，如果出错，返回nil。
// 备注：
// */
//- (NSData*)decryptUpdate:(NSData*)pPart;
//
///*
// 功能描述：结束多部分数据解密操作，返回最后一部分明文数据。
// 参数：无
// 返回值：明文数据，如果出错，返回nil。
// 备注：
// */
//- (NSData*)decryptFinal;
//
///*
// 功能描述：获取设备中所有文件的文件名。
// 参数：
// 返回值：成功返回NSString对象的序列，如果失败，返回nil。
// 备注：文件操作相关方法根据文件名操作指定的文件，文件名由英文字母、数字组成。
// */
//- (NSArray*)getAllFileNames;
//
///*
// 功能描述：检查设备中是否存在指定文件名的文件。
// 参数：
// 参数        类型            输入/输出    描述
// fileName    NSString*    IN
// 返回值：文件存在返回YES，不存在返回NO。
// 备注：
// */
//- (BOOL)fileIsExist:(NSString*)fileName;
//
///*
// 功能描述：在设备中创建指定文件名的文件。
// 参数：
// 参数        类型            输入/输出        描述
// fileName    NSString*      IN        文件名称
// property   NSDictionary* IN        文件属性
// 
// 文件属性键值对定义
// 键（NSString）            对象类型
// @"deleteNeedLogin"      NSNumber(BOOL)
// @"writeNeddLogin"       NSNumber(BOOL)
// @"readNeedLogin"        NSNumber(BOOL)
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)createFile:(NSString*)fileName property:(NSDictionary*)fileProperty;
//
///*
// 功能描述：从设备中删除指定文件名的文件。
// 参数：
// 参数        类型            输入/输出    描述
// fileName    NSString*    IN
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)deleteFile:(NSString*)fileName;
//
///*
// 功能描述：向设备中指定文件写入数据。
// 参数：
// 参数        类型            输入/输出    描述
// fileName    NSString*    IN
// fileData    NSData*        IN
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)writeFile:(NSString*)filename data:(NSData*)fileData;
//
///*
// 功能描述：从设备中指定文件读取数据。
// 参数：
// 参数        类型            输入/输出    描述
// fileName    NSString*    IN
// 返回值：成功返回文件数据，如果失败，返回nil。
// 备注：
// */
//- (NSData*)readFile:(NSString*)filename;
//
///*
// 功能描述：生成签名密钥对并输出签名公钥。
// 参数：
// 参数             类型                 输入/输出        描述
// keyType         HB_ANSYMMTRIC_TYPE        IN            密钥类型
//
// 返回值：成功返回公钥，如果失败，返回nil。如果生成RSA密钥对，则返回PKCS#1格式的公钥，如果生成SM2密钥对，则公钥格式为04||X||Y，其中，X和Y分别为公钥的x分量和y分量，其长度各位256位。
// 备注：
// */
//- (NSData*)generateKeyPair:(HB_ANSYMMTRIC_TYPE)keyType;
//
///*
// 功能描述：导入加密公私钥对。
// 参数：
// 参数                        类型                    输入/输出      描述
// keyType                HB_ANSYMMTRIC_TYPE        IN          密钥类型
// symmetricAlg                HB_SYMMETRIC_ALG    IN          对称算法密钥标识，必须为ECB模式
// encryptedSymKey             NSData*                IN          使用签名公钥保护的对称算法密钥，如果为RSA，则依照PKCS1加密格式，如果为SM2，则加密数据格式为X||Y||HASH||Cipher
// signPulicKeyData            NSData*                IN          签名公钥
// publicKeyData                NSData*                IN          加密公钥，如果为RSA，则为PKCS#1格式的加密公钥，如果为SM2，则格式为04||X||Y
// encryptedPrivateKeyData    NSData*                IN          对称算法密钥保护的加密私钥，如果为RSA，则为PKCS8格式
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)importKeyPair:(HB_ANSYMMTRIC_TYPE)keyType
//              symmetricAlg:(HB_SYMMETRIC_ALG)alg
//              symmetricKey:(NSData*)encryptedSymKey
//             signPublicKey:(NSData*)signPulicKeyData
//                 publicKey:(NSData*) publicKeyData
//                privateKey:(NSData*)encryptedPrivateKeyData;
//
//
///*
// 功能描述：删除签名公钥。
// 参数：
// 参数             类型                 输入/输出        描述
// keyType         HB_ANSYMMTRIC_TYPE        IN            密钥类型
// pubKey          NSData*                IN          公钥
// 
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：
// */
//- (NSInteger)deleteKeyPair:(HB_ANSYMMTRIC_TYPE)keyType publicKey:(NSData*)pubKey;
//
///*
// 功能描述：导入p12软证书。
// 参数：
// 参数        类型        输入/输出  描述
// password   NSString IN      p12密码
// p12Data    NSData*    IN         p12数据
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：通过比较公钥的方式匹配对应的公私钥对。
// */
//- (NSInteger)importP12:(NSString*) password
//                   p12:(NSData*)p12Data;
//
///*
// 功能描述：导入X509证书。
// 参数：
// 参数        类型        输入/输出  描述
// certData    NSData*    IN         DER编码格式的证书数据
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：通过比较公钥的方式匹配对应的公私钥对。
// */
//-(NSInteger)importX509Cert:(NSData*)certData;
//
///*
// 功能描述：生成证书请求。
// 参数：
// 参数               类型                    输入/输出     描述
// ansymmtricType    HB_ANSYMMTRIC_TYPE    IN         非对称算法类型
//  pubKey           NSData*              IN       公钥
// commonName           NSString*            IN         证书主题CN信息
// attributeOids       NSArray*                IN         属性OID列表，可以为nil，表示没有属性
// attributeValues   NSArray*                IN         属性值列表，可以为nil，表示没有属性
// 
// 返回值：成功返回PKCS10请求，如果失败，返回nil。
// 备注：只支持RSA证书。
// */
//- (NSData*)certRequestPKCS10:(HB_ANSYMMTRIC_TYPE)ansymmtricType
//                   publicKey:(NSData*)pubKey
//                  commonName:(NSString*)commonName
//               attributeOids:(NSArray*) attributeOids
//             attributeValues:(NSArray*) attributeValues;
//
///*
// 功能描述：处理证书请求回应，导入加密密钥对、加密证书。
// 参数：
// 参数                类型        输入/输出     描述
// responsePKCS7     NSData*    IN         CA系统返回的PKCS#7回应，其中包含加密证书
// responsePFX     NSData*    IN       CA系统返回的PFX回应，其中包含加密密钥对
// password       NSString*   IN       p12密码
// signCert       NSData*     IN       即将配对的签名证书
// 返回值：成功返回HB_OK，如果失败，返回错误码。
// 备注：只支持RSA证书。
// */
//- (NSInteger)certResponsePKCS7:(NSData*)responsePKCS7
//                        andPFX:(NSData *)responsePFX
//                   pfxPassword:(NSString*)password
//                      signCert:(NSData*)signCert;
//
///*
// 功能描述：获取当前可用的数字证书列表
// 参数：
// 参数          类型              输入/输出    描述
// certType      HB_CERT_TYPE      IN        数字证书类型
// 
// 返回值：当前可用证书HBCert对象的列表，以NSArray对象的形式返回，如果出错，则返回nil。
// */
//- (NSArray*)getCertList:(HB_CERT_TYPE)certType;
//
//
///*
// 功能描述：获取指定的数字证书HBCert对象
// 参数：
// 参数        类型                输入/输出       描述
// certType    HB_CERT_TYPE    IN           数字证书类型
// 
// 返回值：指定的数字证书HBCert对象，如果出错，则返回nil。
// 备注：如果有多个数字证书对象满足条件，则弹出界面让用户选择；如果只有一个数字证书满足参数条件，则直接返回该对象。
// */
//- (HBCert*)getCert:(HB_CERT_TYPE)certType;
//
//@end

