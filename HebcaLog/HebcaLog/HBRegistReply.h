//
//  HBRegistReply.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Output 注册返回信息
@interface HBRegistReply : NSObject

@property (nonatomic, copy) NSString *divid;        //单位ID
@property (nonatomic, copy) NSString *acceptNo;     //订单号
@end
