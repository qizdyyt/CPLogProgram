//
//  HBAuthorityUtil.h
//  HebcaLog
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HB_UNDETERMINED = 0,
    HB_NONE_AUTHOR = 1,
    HB_AUTHORIZED = 2
}HB_AUTHOR_STATUS;

typedef enum {
    HB_ATTEND = 1,
    HB_JOURNAL = 2,
    HB_LOCATION = 3
}HB_AUTHOR_TYPE;


@interface HBAuthorityUtil : NSObject

+ (HB_AUTHOR_STATUS)getTeamAuthority: (HB_AUTHOR_TYPE)optype;

//从服务端读取团队权限
+ (HB_AUTHOR_STATUS)getServerTeamAuthority: (HB_AUTHOR_TYPE)optype;
//从本地UserDefault获取存储的团队权限
+ (HB_AUTHOR_STATUS)getLocalTeamAuthority: (HB_AUTHOR_TYPE)optype;

//将团队权限保存到本地
+ (void)recordTeamAuthority: (HB_AUTHOR_TYPE)optype status: (HB_AUTHOR_STATUS)status;

@end
