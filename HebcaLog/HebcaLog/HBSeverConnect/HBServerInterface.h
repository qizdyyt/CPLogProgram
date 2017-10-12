//
//  HBServerInterface.h
//  HebcaLog
//
//  Created by 周超 on 15/2/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBServerConnect.h"
#import "HBCert.h"

//Func: getUserInfo
//Reply -获取到的用户信息
//@interface HBUserInfo : NSObject
/***** 这个模型移动出去 ****/
//@end
#import "HBUserInfo.h"

//Func: loginWithParam
//Input -登录参数
#import "HBLoginParam.h"

//Reply -登录返回信息
#import "HBLoginReply.h"


//Func: attendAct:
//Input -考勤信息
//Func1: getLastAttendInfo:
//Reply -上次考勤信息
//@interface HBAttendInfo : NSObject
//
//@end
#import "HBAttendInfo.h"

//Func: doorList:
//Input -考勤信息
//Func1: getDoorListInfo:
//Reply -门禁列表
//@interface HBDoorListInfo : NSObject
//
//@end
#import "HBDoorListInfo.h"

//Func: sendDoorOpenAct:
//Input -App开门
//Func1: getDoorListInfo:
//Reply -App开门结果

//@interface HBSendDoorOpenInfo : NSObject
//
//@end
#import "HBSendDoorOpenInfo.h"

//Func: getAttendStatistics:
//Input -查询配置信息
//@interface HBAttendRequesInfo : NSObject
//
//@end
#import "HBAttendRequesInfo.h"

//Reply_sub 打卡记录
//@interface HBAttendRecord : NSObject
//
//@end
#import "HBAttendRecord.h"

//Reply -考勤统计数据
//@interface HBAttendStatisticInfo : NSObject
//
//@end
#import "HBAttendStatisticInfo.h"

//Func: sendMsg:
//Input -待发送的消息信息
//Func1: getMsgList
//Reply_sub 获取到的消息
//@interface HBMessageInfo : NSObject
//
//@end
#import "HBMessageInfo.h"

//Reply_sub 接收到的回复消息
//@interface HBReply : NSObject
//
//@end
#import "HBReply.h"

//Func  getMsgList
//Reply

//@interface HBUserMessage : NSObject
//
//@end
#import "HBUserMessage.h"


//Func  getMsgList
//Input 消息请求信息
//@interface HBMsgRequestInfo : NSObject
//
//@end
#import "HBMsgRequestInfo.h"

//Func replyMsg
//Input 回复的消息内容
//@interface HBReplyContent : NSObject
//
//@end
#import "HBReplyContent.h"


//Func writeJournal
//Input 日志信息
//Func1 getJournalList
//Reply_sub 获取到的日志信息
//@interface HBJournalInfo : NSObject
//
//@end
#import "HBJournalInfo.h"


//Func getJournalList
//Input 日志请求信息
//@interface HBJournalRequestInfo : NSObject
//
//@end
#import "HBJournalRequestInfo.h"

//Func  getJrnlList
//Reply

//@interface HBUserJournal : NSObject
//@end
#import "HBUserJournal.h"

//Func sendPosition
//Input 用户位置信息
//Func1 getPositions
//Reply 获取到的用户位置信息
//@interface HBPosition : NSObject
//@end
#import "HBPosition.h"

//Func getContacts
//Input 联系人请求信息
//@interface HBContactRequest : NSObject
//@end
#import "HBContactRequest.h"
//Reply_sub
//@interface HBContactDept : NSObject
//@end
#import "HBContactDept.h"
//Reply_sub
//@interface HBContact : NSObject
//@end
#import "HBContact.h"
//Reply
//@interface HBContactInfo : NSObject
//@end
#import "HBContactInfo.h"

//Func checkUpdate
//Reply 更新信息
//@interface HBUpdateInfo : NSObject
//@end
#import "HBUpdateInfo.h"

//Func bugreport
//Input bug信息
//@interface HBBugInfo : NSObject
//@end
#import "HBBugInfo.h"

//Func registUnit
//Input 注册信息
//@interface HBRegistRequest : NSObject
//@end
#import "HBRegistRequest.h"

//Output 注册返回信息
//@interface HBRegistReply : NSObject
//@end
#import "HBRegistReply.h"

//Func uploadCustomConfig
//Input 上传注册信息
//@interface HBCustomConfig : NSObject
//@end
#import "HBCustomConfig.h"

//Func: sendMeeting:
//Input -待发送的消息信息
//Func1: getMeetingList
//Reply_sub 获取到的消息
//@interface HBMeetingInfo : NSObject
//@end
#import "HBMeetingInfo.h"

//Func  getMeetList
//Reply
//@interface HBUserMeeting : NSObject
//@end
#import "HBUserMeeting.h"

//Func  getMeetList
//Input 消息请求信息
//@interface HBMeetRequestInfo : NSObject
//@end
#import "HBMeetRequestInfo.h"



/****************************************************************
 ****************************************************************
 ****************************************************************/

@interface HBServerConnect (HBServerInterface)

/*2.3.8.1 获取用户信息
 *URL： getUser.action  POST
 *功能： 首次登陆，通过用户名和密码获取用户信息或证书信息
 *参数： username	用户英文名 password密码 divid单位id
 *返回： HBUserInfo *
 */
-(HBUserInfo *)getUserInfo:(NSString *)user password:(NSString *)password divID:(NSString *)divId;


/*2.3.8.2 登录
 *URL： login.action GET
 *功能： 手机端通过证书登陆。
 *参数： HBLoginParam *
 *返回： HBLoginReply *
 */
-(HBLoginReply *)loginWithParam:(HBLoginParam *)param;


/*2.3.8.3	绑定推送ID
 *URL： bindpush.action POST
 *功能： 绑定推送ID，以便从服务器向指定的设备推送消息。
 *参数： certcn：证书CN号    pushid	：设备推送ID
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)bindPushID:(NSString *)certCN pushID:(NSString *)pushID;


/*2.3.8.4.	考勤打卡
 *URL： attend.action POST
 *功能： 记录考勤上下班打卡，可多次打卡(但上下班必须成对打卡)
 *参数： HBAttendInfo *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)attendAct:(HBAttendInfo *)attendInfo;



/*2.3.8.4.	考勤打卡
 *URL： attend.action POST
 *功能： 记录考勤上下班打卡，可多次打卡(但上下班必须成对打卡)
 *参数： HBAttendInfo *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)sendDoorOpenAct:(HBSendDoorOpenInfo *)sendDoorOpenInfo;


/*2.3.8.5.	获取上次打卡记录
 *URL： getLastAttend.action
 *功能： 获取当前用户上一次的打卡记录
 *参数： userid	用户id
 *返回：
 */
-(NSInteger)getDoorOpenInfo2:(HBSendDoorOpenInfo *)attendInfo;

/*2.3.8.5.	获取上次打卡记录
 *URL： getLastAttend.action
 *功能： 获取当前用户上一次的打卡记录
 *参数： userid	用户id
 *返回：
 */
-(HBDoorListInfo *)getDoorListInfo:(NSString *)userId;


/*2.3.8.5.	获取上次打卡记录
 *URL： getLastAttend.action
 *功能： 获取当前用户上一次的打卡记录
 *参数： userid	用户id
 *返回：
 */
-(HBAttendInfo *)getLastAttendInfo:(NSString *)userId;


/*2.3.8.6.	获取考勤统计情况
 *URL： getAttendStatisticsList.action GET
 *功能： 获取统计该用户考勤上班时间情况。
 *参数： HBAttendRequesInfo *
 *返回： HBAttendStatisticInfo *
 */
-(HBAttendStatisticInfo *)getAttendStatistics:(HBAttendRequesInfo *)requestInfo;


/*2.3.8.7.	发送消息
 *URL： sendMsg.action POST
 *功能： 发送消息。
 *参数： HBMessageInfo *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)sendMsg:(HBMessageInfo *)msgInfo;


/*2.3.8.8.	获取消息列表
 *URL： getMsgList.action GET
 *功能： 获取该用户收到的通告。s
 *参数： HBMsgRequestInfo *
 *返回： NSArray - HBMessageInfo *
 */
-(HBUserMessage *)getMsgList:(HBMsgRequestInfo *)msgRequest;


/*2.3.8.9.	回复消息
 *URL： replyMsg.action POST
 *功能： 回复消息。
 *参数： HBReplyContent *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)replyMsg:(HBReplyContent *)replyInfo;


/*2.3.8.10.	填写日志
 *URL： writeJournal.action POST
 *功能： 填写日志
 *参数： HBJournalInfo *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)writeJournal:(HBJournalInfo *)journal;


/*2.3.8.11.	获取日志列表
 *URL： getJournalList.action GET
 *功能： 获取该用户可查看到的日志。
 *参数： HBJournalRequestInfo *
 *返回： HBUserJournal
 *      NSArray - HBJournalInfo *
 */
-(HBUserJournal *)getJournalList:(HBJournalRequestInfo *)journalRequest;


/*2.3.8.12.	回复日志
 *URL： replyJournal.action POST
 *功能： 回复日志
 *参数： HBReplyContent *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)replyJournal:(HBReplyContent *)replyInfo;


/*   创建会议
 *URL：sendMeeting.action POST
 *功能：创建会议
 *参数：HBUserMeetingInfo *
 *返回：正确时返回HB_OK；错误时返回错误号
 */
-(NSInteger)createMeeting:(HBMeetingInfo *)meeting;

/* 	获取会议列表
 *URL： getMeetingList.action GET
 *功能： 获取该用户可查看到的日志。
 *参数： HBMeetRequestInfo *
 *返回： HBUserJournal
 *      NSArray - HBMeetingInfo *
 */
-(HBUserMeeting *)getMeetingList:(HBMeetRequestInfo *)meetingRequest;


/* 	回复会议
 *URL： replyMeeting.action POST
 *功能： 回复会议
 *参数： HBReplyContent *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)replyMeeting:(HBReplyContent *)replyInfo;


/*2.3.8.13.	上传地理位置
 *URL： sendPosition.action POST
 *功能： 上传百度定位点数据
 *参数： HBPosition *
 *返回： 正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)sendPosition:(HBPosition *)position;


/*2.3.8.14.	获取用户位置点数据
 *URL：getPositions.action GET
 *功能： 获取指定用户最后一次上传的位置数据。
 *参数：userid-用户id   getuserid-待查看用户id(如有多个用户，以逗号分隔)
 *返回：NSArray 用户位置信息列表 HBPosition *
 */
-(NSMutableArray *)getPositions:(NSString *)userid requestUsers:(NSArray *)users;


/*2.3.8.15.	获取运动轨迹点数据
 *URL：getTrack.action GET
 *功能：获取该用户某天的定位点数据，以便形成运动轨迹图。
 *参数：userid:用户id  userId:待查看用户id（仅支持单个用户） date:查看日期 ----------------------????????
 *返回：NSArray HBPosition *
 */
-(NSMutableArray *)getTrack:(NSString *)userId requstUser:(NSString *)requestUser date:(NSString *)date;


/*2.3.8.16.	获取联系人列表
 *URL：getContacts.action GET
 *功能：获取部门及联系人列表。
 *参数：HBContactRequest *
 *返回：HBContactReply *
 */
-(HBContactInfo *)getContacts:(HBContactRequest *)request;


/*2.3.8.17.	获取有权限查看的用户列表
 *URL：getAuthContacts.action GET
 *功能：获取有权限查看的用户列表。
 *参数：userid - 用户id   type-操作类型1:查看考勤 2:查看日志 3:查看位置信息
 *返回：NSArray userids 有权限查看的用户id列表
 */
-(NSArray *)getAuthContacts:(NSString *)userid opType:(NSInteger)type;


/*2.3.8.18.	检测系统更新
 *URL：checkUpdate.action GET
 *功能：检测是否有系统更新的版本。
 *参数：apkversion 手机端版本号，必填项
 *返回：HBUpdateInfo *
 */
-(HBUpdateInfo *)checkUpdate:(NSString *)apkversion;


/*2.3.8.19.	上传错误报告
 *URL：bugreport.action POST
 *功能：将客户端崩溃的错误信息上传到服务器。
 *参数：HBBugInfo *
 *返回：正确时返回HB_OK；错误时返回错误号；
 */
-(NSInteger)bugreport:(HBBugInfo *)bugInfo;


/*2.3.8.20	上传个人设置
 *URL：userconfig.action POST
 *功能：将用户配置信息上传到服务器。
 *参数：HBCustomConfig *
 */
- (NSInteger)uploadCustomConfig:(HBCustomConfig *)config;


/*2.3.8.21	获取个人设置
 *URL：getuserconfig.action GET
 *功能：将用户配置信息上传到服务器。
 *参数：userid  key
 */

- (NSString *)getCustomConfigWithUserid:(NSString *)userid withKey:(NSString *)key;


/*2.3.8.23 注册管理员单位
 *URL：regUnit.action  POST
 *功能：注册管理员
 *参数：HBUnitRegistRequest *
 *返回：HBUnitRegistReply *
 */
- (HBRegistReply *)registUnit:(HBRegistRequest *)request;


/*2.3.8.24 请求发送短信验证码
 *URL：getVerifyCode.action POST
 *功能：请求验证短信
 *参数：mobilephone 手机号 imei 设备串号
 *返回：空
 */
- (void)requestVerifyCodeWithPhone:(NSString *)mobilephone devID:(NSString *)imei;

/*2.3.8.25.	邀请用户
 *URL：/interface/inviteUser.action POST
 *功能：邀请用户
 *参数: names中文名称  mobilephones 手机号
 *返回：空
 */
- (void)inviteUserNames:(NSString *)names phones:(NSString *)phones;
@end
