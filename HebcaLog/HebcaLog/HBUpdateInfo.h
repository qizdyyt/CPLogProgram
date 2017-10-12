//
//  HBUpdateInfo.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/12.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

//Func checkUpdate
//Reply 更新信息
@interface HBUpdateInfo : NSObject
@property (nonatomic, assign)BOOL isupdate;     //是否有更新 YES-有  NO-没有
@property (nonatomic, assign)BOOL isforceupdate;//是否强制升级 YES-是
@property (nonatomic, copy)NSString *downloadurl;//下载地址    若无更新的版本，则此字段为空
@property (nonatomic, copy)NSString *updateDesc;//升级描述    此字段可以为空
@end
