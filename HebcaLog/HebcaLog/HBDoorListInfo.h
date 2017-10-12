//
//  HBDoorListInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func: doorList:
//Input -考勤信息
//Func1: getDoorListInfo:
//Reply -门禁列表
@interface HBDoorListInfo : NSObject
@property (nonatomic, copy)NSString *CID;    //
@property (nonatomic, copy)NSString *IID;    //
@property (nonatomic, copy)NSString *IState; //
@property (nonatomic, copy)NSString *Iname;  //
@property (nonatomic, copy)NSString *Online;  //
@end
