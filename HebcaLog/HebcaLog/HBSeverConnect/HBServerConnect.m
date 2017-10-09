//
//  HBServerConnect.m
//  HebcaLog
//
//  Created by 周超 on 15/2/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBServerConnect.h"
#import "HBMiddleWare.h"

#define ERROR_MSG_MAP(error)   (@error).stringValue:error##_MSG

@implementation HBServerConnect
{
    NSInteger _error;
    NSString* _errorMessage;
    NSDictionary *_errorMsgMap;
    
    NSString * _serverUrl;
    NSTimeInterval _timeoutInterval;
}

- (id)init
{
    self = [super init];
    if (self) {
        _serverUrl = MLOG_SERVER_URL;
        _timeoutInterval = TIME_OUT_INTERVAL;
    }
    
    _error = HM_OK;
    _errorMessage = nil;
    
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        _serverUrl = url;
        _timeoutInterval = TIME_OUT_INTERVAL;
    }
    
    _error = HM_OK;
    _errorMessage = nil;
    
    return self;
}


- (id)initWithUrl:(NSString *)url timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super init];
    if (self) {
        _serverUrl = url;
        _timeoutInterval = timeoutInterval;
    }
    return self;
}
//组织GET方式下url中参数、POST方法中的request参数
- (NSString *)setHttpBodyParameters:(NSDictionary *)parameters
{
    if (nil == parameters) {
        [self setLastError:HM_PARAMETER_INVALID];
        return nil;
    }
    NSMutableArray *parametersArray = [[NSMutableArray alloc]init];
    
    for (NSString *key in [parameters allKeys]) {
        id value = [parameters objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            [parametersArray addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
    }
    
    NSString *finalUrl = [parametersArray componentsJoinedByString:@"&"];
    
    return [finalUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
}

- (NSData*)httpSynGetRequest:(NSString *)method
                   parameter:(NSString *)param
                    response:(NSHTTPURLResponse **)response
                       error:(NSError **)error
{
    if (nil == method) {
        [self setLastError:HM_PARAMETER_INVALID];
        return nil;
    }
    
    NSString *interfaceUrlStr = [_serverUrl stringByAppendingString:method];
    NSString *urlStr = nil;
    
    if (nil == param){
        urlStr = interfaceUrlStr;
    }
    else{
        NSString *encodedParam = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    //UTF-8编码
        urlStr = [[interfaceUrlStr stringByAppendingString:@"?"] stringByAppendingString:encodedParam];
    }
    
    //替换参数中的+号
    NSString *transformStr = [self transformURLParamCharacters:urlStr];
    
    NSURL *httpUrl = [[NSURL alloc]initWithString:transformStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:_timeoutInterval];
    if (nil == request) {
        return nil;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSInteger result = [self httpResponseCheck:*response];
    if (HM_HTTP_UNLOG_SESSION_FAILD == result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    return received;
}

- (NSData*)httpSynPostRequest:(NSString *)method
                    parameter:(NSString *)param
                     response:(NSHTTPURLResponse **)response
                        error:(NSError **)error
{
    if (nil == method) {
        HM_SET_ERROR(HM_PARAMETER_INVALID);
        return nil;
    }
    
    NSURL *httpUrl = [[NSURL alloc] initWithString:[_serverUrl stringByAppendingString:method]];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    
    NSString *encodedParam = [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    //UTF-8编码
    NSString *transParam = [self transformURLParamCharacters:encodedParam];     //转换+号
    
    NSData *requestData = [transParam dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestData];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSInteger result = [self httpResponseCheck:*response];
    if (HM_HTTP_UNLOG_SESSION_FAILD == result) {
        received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    }
    
    return received;
}


/* Multipart/form-data发送表单数据 */
- (NSData *)httpSynPostRequestMultiPart:(NSString *)method
                              parameter:(NSDictionary *)param
                               response:(NSHTTPURLResponse **)response
                                  error:(NSError **)error
{
    if (nil == method) {
        HM_SET_ERROR(HM_PARAMETER_INVALID);
        return nil;
    }
    
    NSURL *httpUrl = [[NSURL alloc] initWithString:[_serverUrl stringByAppendingString:method]];
    
    NSData *httpBodyData = [self getHttpBobyContent:param];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", HB_MULTIPART_BOUNDARY];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:_timeoutInterval];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    //[request addValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:httpBodyData];
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSInteger result = [self httpResponseCheck:*response];
    if (HM_HTTP_UNLOG_SESSION_FAILD == result) {
        received = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:error];
    }
    
    return received;
}

/*根据from表单组织part结构*/
- (NSData *)getHttpBobyContent:(NSDictionary *)paramDic
{
    if (IS_NULL(paramDic)) {
        HM_SET_ERROR(HM_PARAMETER_INVALID);
        return nil;
    }
    NSMutableString *bodyContent = nil;
    NSMutableData *bodyContentData = [[NSMutableData alloc] init];
    
    for (NSString *key in [paramDic allKeys])
    {
        if ([key isEqualToString:@"image"])
        {   //图片
            id value = [paramDic objectForKey:key];
            if (value == nil || [value length] == 0) {
                continue;
            }
            //value为图片路径
            UIImage *image = [UIImage imageWithContentsOfFile:value];
            NSData *data = UIImagePNGRepresentation(image);
            
            bodyContent = [NSMutableString stringWithFormat:@"--%@\r\n", HB_MULTIPART_BOUNDARY];
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
            bodyContent = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", value];
            [bodyContent appendFormat:@"Content-Type: image/x-png\r\n"];
            [bodyContent appendFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"];
            
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
            
            [bodyContentData appendData:data];
            
            bodyContent = [NSMutableString stringWithString:@"\r\n"];
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if ([key isEqualToString:@"attachment"]) {
            id value = [paramDic objectForKey:key];
            if (value == nil || [value length] == 0) {
                continue;
            }
            
            UIImage *image = [UIImage imageWithContentsOfFile:value];
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            
            bodyContent = [NSMutableString stringWithFormat:@"--%@\r\n", HB_MULTIPART_BOUNDARY];
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
            bodyContent = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"head.jpg\"\r\n", key];
            [bodyContent appendFormat:@"Content-Type: application/octet-stream\r\n"];
            [bodyContent appendFormat:@"Content-Transfer-Encoding: binary\r\n\r\n"];
            
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
            
            [bodyContentData appendData:data];
            
            bodyContent = [NSMutableString stringWithString:@"\r\n"];
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else{  //普通字段
            NSString *value = [paramDic objectForKey:key];
            
            bodyContent = [NSMutableString stringWithFormat:@"--%@\r\n", HB_MULTIPART_BOUNDARY];
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
            bodyContent = [NSMutableString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
            
            [bodyContent appendFormat:@"Content-Type: text/plain\r\n"];
            [bodyContent appendFormat:@"Content-Transfer-Encoding: base64\r\n\r\n"];
            [bodyContent appendFormat:@"%@\r\n",value];
            
            [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    bodyContent = [NSMutableString stringWithFormat:@"--%@--\r\n", HB_MULTIPART_BOUNDARY];
    [bodyContentData appendData:[bodyContent dataUsingEncoding:NSUTF8StringEncoding]];
    
    return bodyContentData;
}

- (NSInteger)httpResponseCheck:(NSHTTPURLResponse *)response
{
    if (nil == response) {
        HM_SET_ERROR_MSG(HM_HTTP_SERVER_ERR, HM_HTTP_SERVER_ERR_MSG);
        return HM_FAILED;
    }
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        // 取得所有的请求的头
        NSDictionary *allHeaderFields = [response allHeaderFields];
        
        //取得自定义错误码
        NSString *resultCodeStr = [allHeaderFields objectForKey:@"Result-Code"];
        int iResultCode = [resultCodeStr intValue];
        
        NSInteger lastError = 0;
        switch (iResultCode) {
            case HTTP_OPRATION_SUCCESS:
                break;
                
            case HTTP_PARAM_ERR:
                lastError = HM_HTTP_PARAM_ERR;
                break;
                
            case HTTP_SERVER_ERR:
                lastError = HM_HTTP_SERVER_ERR;
                break;
                
            case HTTP_UNLOG_SESSION_FAILD:
                lastError = HM_HTTP_UNLOG_SESSION_FAILD;
                break;
                
            case HTTP_NO_AUTHORITY:
                lastError = HM_HTTP_NO_AUTHORITY;
                break;
                
            default:
                lastError = HM_RETURN_UNEXPECTED;
                break;
        }
        
        if (HTTP_OPRATION_SUCCESS != iResultCode) {
            NSString *errorMsg = [allHeaderFields objectForKey:@"errorMessage"];
            NSString *lastErrMsg = [errorMsg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //将+号替换为空格
            NSMutableString *tempParam = [lastErrMsg mutableCopy];
            [tempParam replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
            
            if (nil==tempParam || 0==[tempParam length]) {
                tempParam = [NSMutableString stringWithFormat:@"错误号：%d", iResultCode];
            }
            HM_SET_ERROR_MSG(lastError, tempParam);
            
            return lastError;
        }
    }
    
    NSInteger statusCode = [response statusCode];
    if (200 != statusCode) {
        NSString *errorMsg = [NSString stringWithFormat:@"http错误，状态码为:%ld", (long)statusCode];
        HM_SET_ERROR_MSG(HM_HTTP_STATUS_CODE_ERROR, errorMsg);
        
        return HM_FAILED;
    }
    
    return HM_OK;
}


-(id)getServerInfoData:(NSData *)serverData
{
    NSString *sourceReceive = [[NSString alloc] initWithData:serverData encoding:NSUTF8StringEncoding];
    
    NSMutableString *tempParam = [sourceReceive mutableCopy];
    //将 \\ 转换为 / (图片路径中的分隔符)
    [tempParam replaceOccurrencesOfString:@"%5C%5C" withString:@"%2F" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //替换制表符
    //[tempParam replaceOccurrencesOfString:@"++++" withString:TAB_REPLACEMENT options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    [tempParam replaceOccurrencesOfString:@"%5Ct" withString:@"%20%20%20%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    [tempParam replaceOccurrencesOfString:@"%09" withString:@"%20%20%20%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //替换换行符
    [tempParam replaceOccurrencesOfString:@"%5Cr%5Cn" withString:@"%5Cn" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //将+号替换为空格
    [tempParam replaceOccurrencesOfString:@"+" withString:@"%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    
    
    NSString *decodeReceive = [[tempParam copy] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *decodeData = [decodeReceive dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:&error];
    if (IS_NULL(result) || 0 == [result count]) {
        HM_SET_ERROR_MSG(HM_RETURN_UNEXPECTED, ERROR_MESSAGE(error));
        return nil;
    }

    
    BOOL success = [[result objectForKey:@"success"] boolValue];
    if (!success) {
        NSString *errorMsg = [result objectForKey:@"msg"];
        HM_SET_ERROR_MSG(HM_SERVER_OPERATE_FAILED, errorMsg);
        return nil;
    }
    
    return (id)[result objectForKey:@"data"];
}

-(NSInteger)checkServerResult:(NSData *)serverData
{
    NSString *sourceReceive = [[NSString alloc] initWithData:serverData encoding:NSUTF8StringEncoding];
    NSString *decodeReceive = [sourceReceive stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *decodeData = [decodeReceive dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:&error];
    if (IS_NULL(result) || 0 == [result count]) {
        HM_SET_ERROR_MSG(HM_RETURN_UNEXPECTED, ERROR_MESSAGE(error));
        return HM_RETURN_UNEXPECTED;
    }
    
    BOOL success = [[result objectForKey:@"success"] boolValue];
    if (!success) {
        NSString *errorMsg = [result objectForKey:@"msg"];
        HM_SET_ERROR_MSG(HM_SERVER_OPERATE_FAILED, errorMsg);
        return HM_SERVER_OPERATE_FAILED;
    }
    
    return HM_OK;
}



//UTF-8 Unicode解码
-(NSData *)decodingServerReturnedData:(NSData *)retData
{
    if (nil == retData) {
        return nil;
    }
    
    NSString *originalStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    NSString *decodedStr = [originalStr stringByReplacingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    NSData *decodedData = [decodedStr dataUsingEncoding:NSUTF8StringEncoding];
    
    return decodedData;
}

-(NSString *)encodingURLString:(NSString *)original
{
    if (IS_NULL(original)) {
        return nil;
    }
    
    NSData *utfData = [original dataUsingEncoding:NSUTF8StringEncoding];
    
    return [HBMiddleWare base64Encode:utfData];
}

-(NSString *)decodingWithUnicode:(NSString *)original
{
    NSData *decodedData = [original dataUsingEncoding:NSUnicodeStringEncoding];
    NSString *decodedStr = [[NSString alloc] initWithData:decodedData encoding:NSUnicodeStringEncoding];
    
    return decodedStr;
}

//去掉参数中特殊符号，+ ---》%2B
-(NSString *)transformURLParamCharacters:(NSString *)param
{
    if (IS_NULL(param)) {
        return nil;
    }
    
    NSMutableString *tempParam = [param mutableCopy];
    
    [tempParam replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    
    return [tempParam copy];
}

//将换行占位符替换为换行符


-(NSInteger)setLastError:(NSInteger)error
{
    if (nil == _errorMsgMap) {
        _errorMsgMap = @{
                         ERROR_MSG_MAP(HM_OK),
                         ERROR_MSG_MAP(HM_FAILED),
                         ERROR_MSG_MAP(HM_PARAMETER_INVALID),
                         ERROR_MSG_MAP(HM_MEMORY_ERROR),
                         ERROR_MSG_MAP(HM_NETWORK_UNREACHABLE),
                         };
        
    }
    
    _error = error;
    _errorMessage = [_errorMsgMap objectForKey:[[NSNumber numberWithInteger:error] stringValue]];
    
    return error;
}

-(NSInteger)setLastError:(NSInteger)error message:(NSString*)msg
{
    _error = error;
    _errorMessage = msg;
    
    return error;
}

-(NSInteger)getLastError
{
    return _error;
}

-(NSString*)getLastErrorMessage
{
    return _errorMessage;
}

@end
