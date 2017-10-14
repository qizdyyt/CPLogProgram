//
//  HBErrorCode.h
//  hbmiddleware
//
//  Created by hebca on 13-11-22.
//  Copyright (c) 2013年 hebca. All rights reserved.
//

#ifndef hbmiddleware_HBErrorCode_h
#define hbmiddleware_HBErrorCode_h

/*无错误*/
#define HB_OK 0x00000000
#define HB_OK_MSG @"无错误"
/*操作失败*/
#define HB_FAILED 0x800AFFFF
#define HB_FAILED_MSG @"操作失败"
/*无效的算法*/
#define HB_ALGORITHM_INVALID 0x800A0001
#define HB_ALGORITHM_INVALID_MSG @"无效的算法"
/*无效的密钥*/
#define HB_KEY_INVALID 0x800A0002
#define HB_KEY_INVALID_MSG @"无效的密钥"
/*无效的参数*/
#define HB_PARAMETER_INVALID 0x800A0003
#define HB_PARAMETER_INVALID_MSG @"无效的参数"
/*未装载设备驱动对象*/
#define HB_NO_DEVICE_DRIVER 0x800A0004
#define HB_NO_DEVICE_DRIVER_MSG @"未装载设备驱动对象" 
/*无效的设备*/
#define HB_DEVICE_INVALID 0x800A0005
#define HB_DEVICE_INVALID_MSG @"无效的设备"
/*无效的证书*/
#define HB_CERTIFICATE_INVALID 0x800A0006
#define HB_CERTIFICATE_INVALID_MSG @"无效的证书"
/*数据格式错误*/
#define HB_BAD_DATA_FORMAT 0x800A0007
#define HB_BAD_DATA_FORMAT_MSG @"数据格式错误"
/*验证签名失败*/
#define HB_HBCERT_SIGNATURE_INVALID 0x800A0008
#define HB_HBCERT_SIGNATURE_INVALID_MSG @"验证签名失败"
/*设备密码错误*/
#define HB_BAD_USER_PIN 0x800A0009
#define HB_BAD_USER_PIN_MSG @"设备密码错误"
#define HB_BAD_USER_PIN_MSG_RETRYTTIMES @"设备密码错误,还可以尝试%@次"
/*设备管理员密码错误*/
#define HB_BAD_SO_PIN 0x800A000A
#define HB_BAD_SO_PIN_MSG @"设备管理员密码错误"
/*设备密码被锁定*/
#define HB_PIN_IS_LOCKED 0x800A000B
#define HB_PIN_IS_LOCKED_MSG @"设备密码被锁定"
/*设备中已存在该文件*/
#define HB_FILE_ALREADY_EXIST 0x800A000C
#define HB_FILE_ALREADY_EXIST_MSG @"设备中已存在该文件"
/*设备中可用空间不足*/
#define HB_NO_MORE_SPACE 0x800A000D
#define HB_NO_MORE_SPACE_MSG @"设备中可用空间不足"
/*不存在指定文件*/
#define HB_FILE_NO_EXIST 0x800A000E
#define HB_FILE_NO_EXIST_MSG @"不存在指定文件"
/*内存错误*/
#define HB_MEMORY_ERROR 0x800A000F
#define HB_MEMORY_ERROR_MSG @"内存错误"
/*密钥长度错误*/
#define HB_BAD_KEY_LENGTH 0x800A0010
#define HB_BAD_KEY_LENGTH_MSG @"密钥长度错误"
/*不支持的功能*/
#define HB_NOT_SUPPORT_FUNCTION 0x800A0011
#define HB_NOT_SUPPORT_FUNCTION_MSG @"不支持的功能"
/*未找到签名密钥对*/    
#define HB_NO_FIND_SIGN_KEYPAIR 0x800A0012
#define HB_NO_FIND_SIGN_KEYPAIR_MSG @"未找到签名密钥对"
/*未找到加密密钥对*/
#define HB_NO_FIND_ENCRYPT_KEYPAIR 0x800A0013
#define HB_NO_FIND_ENCRYPT_KEYPAIR_MSG @"未找到加密密钥对"
/*不支持的业务类型*/
#define HB_NOT_SUPPORT_BUSINESS 0x800A0014
#define HB_NOT_SUPPORT_BUSINESS_MSG @"不支持的业务类型"
/*不支持的项目*/
#define HB_NOT_SUPPORT_PROJECT 0x800A0015
#define HB_NOT_SUPPORT_PROJECT_MSG @"不支持的项目"
/*不支持的申请单项目*/
#define HB_NOT_SUPPORT_FORM_ITEM 0x800A0016
#define HB_NOT_SUPPORT_FORM_ITEM_MSG @"不支持的申请单项目"
/*算法未初始化*/
#define HB_ALG_NO_INIT 0x800A0017
#define HB_ALG_NO_INIT_MSG @"算法未初始化"
/*证书没有和设备关联*/
#define HB_NO_ASSOSIATE_WITH_DEVICE 0x800A0018
#define HB_NO_ASSOSIATE_WITH_DEVICE_MSG @"证书没有和设备关联"
/*证书格式错误*/
#define HB_BAD_CERT_FORMAT 0x800A0019
#define HB_BAD_CERT_FORMAT_MSG @"证书格式错误"
/*无对应数据项*/
#define HB_NO_FIND_DATA_ITEM 0x800A001A
#define HB_NO_FIND_DATA_ITEM_MSG @"无对应数据项"
/*设备未登录*/
#define HB_DEVICE_IS_NOT_LOGIN 0X800A001B
#define HB_DEVICE_IS_NOT_LOGIN_MSG @"设备未登录"
/*用户取消操作*/
#define HB_USER_CANCEL 0x800A001C
#define HB_USER_CANCEL_MSG @"用户取消操作"
/*设备未初始化*/
#define HB_DEVICE_IS_NOT_INIT 0x800A001D
#define HB_DEVICE_IS_NOT_INIT_MSG @"设备未初始化"
/*找不到数字证书设备*/
#define HB_NOT_FIND_DEVICE 0x800A001E
#define HB_NOT_FIND_DEVICE_MSG @"找不到数字证书设备"
/*找不到数字证书*/
#define HB_NOT_FIND_CERT 0x800A001F
#define HB_NOT_FIND_CERT_MSG @"找不到数字证书"
/*证书不能用于该用途*/
#define HB_BAD_CERT_USAGE 0x800A0020
#define HB_BAD_CERT_USAGE_MSG @"证书不能用于该用途"
/*生成证书请求失败*/
#define HB_MAKE_P10_REQUEST_FAILED 0x800A0021
#define HB_MAKE_P10_REQUEST_FAILED_MSG @"生成证书请求失败"
/*错误的申请单状态*/
#define HB_ONLINE_STATUS_WRONG 0x800A0022
#define HB_ONLINE_STATUS_WRONG_MSG @"错误的申请单状态"
/*查询申请单失败*/
#define HB_QUERY_APPLICATION_FORM_FAILED 0x800A0023
#define HB_QUERY_APPLICATION_FORM_FAILED_MSG @"查询申请单失败"

//在线业务
/*http错误，状态码*/
#define HB_HTTP_STATUS_CODE_ERROR 0x800B0001

/*在线业务系统错误*/
#define HB_ONLINE_BUSINESS_ERROR 0x800B0002



NSString * GetDefaultErrorMessage(NSInteger error);


#endif

