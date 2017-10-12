//
//  HBSendDoorOpenInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: sendDoorOpenAct:
//Input -App开门
//Func1: getDoorListInfo:
//Reply -App开门结果

@interface HBSendDoorOpenInfo : NSObject
@property (nonatomic, copy)NSString *userId;    //用户id （打卡函数入参）
@property (nonatomic, copy)NSString *time;      //打卡时间 （获取上次打卡信息出参）
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //打卡地址
@property (nonatomic, copy)NSString *CID;   //
@property (nonatomic, copy)NSString *IID;   //
@property (nonatomic, copy)NSString *IState;   //
@end
