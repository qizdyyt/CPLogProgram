//
//  HBContactRequest.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func getContacts
//Input 联系人请求信息
@interface HBContactRequest : NSObject
@property (nonatomic, copy) NSString *userid;    //用户id
@property (nonatomic, copy) NSString *signcert;  //签名证书
@property (nonatomic, copy) NSData *signdata;  //签名数据
@property (nonatomic, copy) NSString *lastupdated;//上次更新联系人列表的时间
@end
