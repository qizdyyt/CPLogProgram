//
//  HBFileManager.h
//  HebcaLog
//
//  Created by 周超 on 15/3/24.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBServerInterface.h"
#import "HBCommonUtil.h"

@interface HBFileManager : NSObject

//联系人
- (void)writeUserContacts:(HBContactInfo *)serverData;
- (HBContactInfo *)getContactFromLocalFile;

//消息
- (void)writeUserMessage:(HBUserMessage *)userMsg;
- (HBUserMessage *)getLocalMesage;

- (void)writeMessageImage:(NSData *)imgData withName:(NSString *)imgName;
- (NSData *)getMessageImageData:(NSString *)imgName;

//日志
- (void)writeUserJournal:(HBUserJournal *)userJnl;
- (HBUserJournal *)getLocalJournal;

- (void)writeTeamJournal:(HBUserJournal *)userJnl;
- (HBUserJournal *)getTeamLocalJournal;

//会议
- (void)writeUserMeetings:(HBUserMeeting *)userMeet;
- (HBUserMeeting *)getLocalMeeting;


//头像
- (void)writeUserHeadImg:(NSData *)imgData withName:(NSString *)imgName;
- (UIImage *)getUserHeadImg:(NSString *)userid;

@end
