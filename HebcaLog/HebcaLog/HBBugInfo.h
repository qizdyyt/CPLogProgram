//
//  HBBugInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func bugreport
//Input bug信息
@interface HBBugInfo : NSObject
@property (nonatomic, copy)NSString *devicetype;    //
@property (nonatomic, copy)NSString *platform;      //
@property (nonatomic, copy)NSString *phoneid;       //
@property (nonatomic, copy)NSString *packagename;   //
@property (nonatomic, copy)NSString *packageversion;//
@property (nonatomic, copy)NSString *exceptiontime; //
@property (nonatomic, copy)NSString *stacktrace;    //
@end
