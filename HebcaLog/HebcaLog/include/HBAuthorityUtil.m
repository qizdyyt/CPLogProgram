//
//  HBAuthorityUtil.m
//  HebcaLog
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 hebca. All rights reserved.
//

#import "HBAuthorityUtil.h"
#import "HBCommonUtil.h"
#import "HBServerInterface.h"
#import "AppDelegate.h"

#define HB_TEAM_AUTHOR          @"HBMLog_Team_Author"
#define HB_TEAM_AUTHOR_ATTEND   @"HBMLog_Team_Author_Attend"
#define HB_TEAM_AUTHOR_JOURNAL  @"HBMLog_Team_Author_Journal"
#define HB_TEAM_AUTHOR_LOCATE   @"HBMLog_Team_Author_Location"

@implementation HBAuthorityUtil

+ (HB_AUTHOR_STATUS)getTeamAuthority: (HB_AUTHOR_TYPE)optype {
    HB_AUTHOR_STATUS status = [HBAuthorityUtil getLocalTeamAuthority:optype];
    if (status == HB_UNDETERMINED) {
        status = [HBAuthorityUtil getServerTeamAuthority:optype];
    }
    
    return status;
}

+ (HB_AUTHOR_STATUS)getServerTeamAuthority: (HB_AUTHOR_TYPE)optype {
    NSString *userid = [HBCommonUtil getUserId];
    HB_AUTHOR_STATUS status = HB_UNDETERMINED;
    
    HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
    NSArray *authUserList = [serverConnect getAuthContacts:userid opType:optype];
    if (authUserList == nil) {
        status = HB_NONE_AUTHOR;
    }
    else {
        BOOL foundOtherUser = NO;
        int count = [authUserList count];
        for (int index = 0; index < count; index++) {
            NSString *customerid = authUserList[index];
            if (![userid isEqualToString: customerid]) {
                foundOtherUser = YES;
                break;
            }
        }
        
        if (foundOtherUser) {
            status = HB_AUTHORIZED;
        }
        else {
            status = HB_NONE_AUTHOR;
        }
    }
    
    [HBAuthorityUtil recordTeamAuthority:optype status:status];
    
    return status;
}

//从本地UserDefault获取存储的团队权限
+ (HB_AUTHOR_STATUS)getLocalTeamAuthority: (HB_AUTHOR_TYPE)optype {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *teamAuthorDic = [userDefaults objectForKey:HB_TEAM_AUTHOR];
    if (teamAuthorDic == nil) {
        return HB_UNDETERMINED;
    }
    
    NSNumber *statusNum = [[NSNumber alloc] init];
    
    if (optype == HB_ATTEND) {
        statusNum = [teamAuthorDic objectForKey:HB_TEAM_AUTHOR_ATTEND];
    }
    else if (optype == HB_JOURNAL) {
        statusNum = [teamAuthorDic objectForKey:HB_TEAM_AUTHOR_JOURNAL];
    }
    else {
        statusNum = [teamAuthorDic objectForKey:HB_TEAM_AUTHOR_LOCATE];
    }
    
    if (statusNum == nil) {
        return HB_UNDETERMINED;
    }
    
    int status = [statusNum intValue];
    
    return status;
}

//将团队权限保存到本地
+ (void)recordTeamAuthority: (HB_AUTHOR_TYPE)optype status: (HB_AUTHOR_STATUS)status {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDefaultDic = [userDefaults objectForKey:HB_TEAM_AUTHOR];
    NSMutableDictionary *teamAuthorDic;
    if (userDefaultDic == nil) {
        teamAuthorDic = [[NSMutableDictionary alloc] init];
    }
    else {
        teamAuthorDic = [userDefaultDic mutableCopy];
    }
    
    NSNumber *authorStatus = [[NSNumber alloc] initWithInt:status];
//    if (status == HB_UNDETERMINED) {
//        authorStatus = [NSNumber numberWithInt:0];
//    }
//    else if (status == HB_NONE_AUTHOR) {
//        authorStatus = [NSNumber numberWithInt:1];
//    }
//    else {
//        authorStatus = [NSNumber numberWithInt:2];
//    }
    
    if (optype == HB_ATTEND) {
        [teamAuthorDic setObject:authorStatus forKey:HB_TEAM_AUTHOR_ATTEND];
    }
    else if (optype == HB_JOURNAL) {
        [teamAuthorDic setObject:authorStatus forKey:HB_TEAM_AUTHOR_JOURNAL];
    }
    else {
        [teamAuthorDic setObject:authorStatus forKey:HB_TEAM_AUTHOR_LOCATE];
    }
    
    [userDefaults setObject:teamAuthorDic forKey:HB_TEAM_AUTHOR];
    [userDefaults synchronize];
}

@end
