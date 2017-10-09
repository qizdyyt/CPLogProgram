//
//  HBServerConnect.h
//  HebcaLog
//
//  Created by 周超 on 15/2/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBServerConfig.h"
#import "HBCommonUtil.h"

#define HM_SET_ERROR(error) [self setLastError:error]
#define HM_SET_ERROR_MSG(error, errMsg) [self setLastError:error message:errMsg]
//#define HM_SET_ERROR_MSG(error) [self setLastError:error message:errMsg];
#define HM_GET_ERROR [self getLastError]
#define HM_GET_ERROR_MSG [self getLastErrorMessage]
#define MAKE_PARAM(str, var) [NSString stringWithFormat:@"%@=%@", str, var]
#define MAKE_INT_PARAM(str, var) [NSString stringWithFormat:@"%@=%ld", str, (long)var]
#define MAKE_BOOL_PARAM(str, var) [NSString stringWithFormat:@"%@=%@", str, var?@"true":@"false"]



@interface HBServerConnect : NSObject

//初始化URL信息
- (id)initWithUrl:(NSString *)url;
//初始化URL信息，及配置超时
- (id)initWithUrl:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval;

//编码组织HTTP连接参数
- (NSString *)setHttpBodyParameters:(NSDictionary *)parameters;

//HTTP同步GET连接
- (NSData*)httpSynGetRequest:(NSString *)method
                   parameter:(NSString *)param
                    response:(NSHTTPURLResponse **)response
                       error:(NSError **)error;
//HTTP同步POST连接
- (NSData*)httpSynPostRequest:(NSString *)method
                    parameter:(NSString *)param
                     response:(NSHTTPURLResponse **)response
                        error:(NSError **)error;

- (NSData *)httpSynPostRequestMultiPart:(NSString *)method
                              parameter:(NSDictionary *)param
                               response:(NSHTTPURLResponse **)response
                                  error:(NSError **)error;

-(id)getServerInfoData:(NSData *)serverData;
-(NSInteger)checkServerResult:(NSData *)serverData;

//解析头部错误信息
- (NSInteger)httpResponseCheck:(NSHTTPURLResponse *)response;

//对返回数据进行解码
-(NSData *)decodingServerReturnedData:(NSData *)retData;

//base64编码
-(NSString *)encodingURLString:(NSString *)original;

//返回数据进行Unicode解码
-(NSString *)decodingWithUnicode:(NSString *)original;



-(NSInteger)setLastError:(NSInteger)error;
-(NSInteger)setLastError:(NSInteger)error message:(NSString*)msg;

-(NSInteger)getLastError;
-(NSString*)getLastErrorMessage;


@end
