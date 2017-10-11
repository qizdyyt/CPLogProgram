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
@interface HBAttendInfo : NSObject
@property (nonatomic, copy)NSString *userId;    //用户id （打卡函数入参）
@property (nonatomic, copy)NSString *time;      //打卡时间 （获取上次打卡信息出参）
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //打卡地址
@property (nonatomic, assign)NSInteger type;    //打卡类型 1-上班  2-下班
@end


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

//Func: getAttendStatistics:
//Input -查询配置信息
@interface HBAttendRequesInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, copy)NSString *date;      //考勤截止日期（不传默认当月）
@property (nonatomic, assign)BOOL badonly;      //是否仅查看异常的考勤信息 NO-返回所有考勤信息 YES-仅返回异常的考勤信息。
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end
//Reply_sub 打卡记录
@interface HBAttendRecord : NSObject
@property (nonatomic, copy)NSString *date;      //考勤日期
@property (nonatomic, copy)NSString *worktime;    //工作时长
@property (nonatomic, assign)BOOL isbad;        //是否考勤异常 NO-考勤正常 YES-考勤异常
@property (nonatomic, copy)NSMutableArray *attendlist;//打卡列表  打卡信息：HBAttendInfo *（出参）
@end
//Reply -考勤统计数据
@interface HBAttendStatisticInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //打卡人
@property (nonatomic, copy)NSString *userName;  //打卡人姓名
@property (nonatomic, assign)NSInteger baddays; //本月考勤异常天数
@property (nonatomic, copy)NSMutableArray *records; //打卡记录 HBAttendRecord *
@end


//Func: sendMsg:
//Input -待发送的消息信息
//Func1: getMsgList
//Reply_sub 获取到的消息
@interface HBMessageInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *content;   //消息内容
@property (nonatomic, copy)NSString *image;     //消息图片      -------------------------------?????
@property (nonatomic, copy)NSString *receivers; //接收人列表
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *msgid;     //消息id func1出参
@property (nonatomic, copy)NSString *time;      //发布时间 func1出参
@property (nonatomic, copy)NSMutableArray *replies; //消息回复列表 func1出参  -HBReply *
@end
//Reply_sub 接收到的回复消息
@interface HBReply : NSObject
@property (nonatomic, copy)NSString *msgid;     //消息ID
@property (nonatomic, copy)NSString *content;   //消息内容
@property (nonatomic, copy)NSString *senderid;  //回复者ID
@property (nonatomic, copy)NSString *sendername;//回复者姓名
@property (nonatomic, copy)NSString *time;      //发布时间
@end

//Func  getMsgList
//Reply

@interface HBUserMessage : NSObject
@property (nonatomic, copy) NSArray *messageList;   //消息列表
@property (nonatomic, copy) NSArray *users;         //发消息的用户列表
@property (nonatomic, copy) NSData *jsonData;       //服务端读取的JSON数据
@end


//Func  getMsgList
//Input 消息请求信息
@interface HBMsgRequestInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end


//Func replyMsg
//Input 回复的消息内容
@interface HBReplyContent : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *replyid;   //被回复消息id
@property (nonatomic, copy)NSString *replyto;
@property (nonatomic, copy)NSString *content;   //回复内容
@end


//Func writeJournal
//Input 日志信息
//Func1 getJournalList
//Reply_sub 获取到的日志信息
@interface HBJournalInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //登录用户id
@property (nonatomic, copy)NSString *content;   //日志内容
@property (nonatomic, copy)NSString *image;     //日志图片
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *costtime;  //耗费工时，保留字段，暂不使用
@property (nonatomic, copy)NSString *journalId; //日志id  func1-输出参数
@property (nonatomic, copy)NSString *userName;  //用户姓名 func1-输出参数
@property (nonatomic, copy)NSString *time;      //发布时间 func1-输出参数
@property (nonatomic, copy)NSMutableArray *replies; //消息回复 HBReply* func1-输出参数
@end


//Func getJournalList
//Input 日志请求信息
@interface HBJournalRequestInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, copy)NSString *date;      //日志终止日期
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end


//Func  getJrnlList
//Reply

@interface HBUserJournal : NSObject
@property (nonatomic, copy) NSArray *journalList;   //日志列表
@property (nonatomic, copy) NSArray *users;         //发日志的用户列表
@property (nonatomic, copy) NSData *jsonData;       //服务端读取的JSON数据
@end


//Func sendPosition
//Input 用户位置信息
//Func1 getPositions
//Reply 获取到的用户位置信息
@interface HBPosition : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic,assign)NSInteger forcesend; //是否强制上传
@property (nonatomic, copy)NSString *username;  //用户姓名 Func1 返回参数
@property (nonatomic, copy)NSString *time;      //该点定位时间 Func1 返回参数
@end


//Func getContacts
//Input 联系人请求信息
@interface HBContactRequest : NSObject
@property (nonatomic, copy) NSString *userid;    //用户id
@property (nonatomic, copy) NSString *signcert;  //签名证书
@property (nonatomic, copy) NSData *signdata;  //签名数据
@property (nonatomic, copy) NSString *lastupdated;//上次更新联系人列表的时间
@end
//Reply_sub
@interface HBContactDept : NSObject
@property (nonatomic, copy) NSString *deptid;    //部门id
@property (nonatomic, copy) NSString *deptname;  //部门名称
@property (nonatomic, copy) NSMutableArray *depts; //部门列表 HBContactDept*
@property (nonatomic, copy) NSMutableArray *contacts; //联系人列表 HBContact*
@property (nonatomic, strong) HBContactDept * parentGroup;    //上级分组
@property (nonatomic, assign) BOOL selected;     //该组是否为选中状态
@end
//Reply_sub
@interface HBContact : NSObject
@property (nonatomic, copy) NSString *userid;    //用户id
@property (nonatomic, copy) NSString *username;  //用户姓名
@property (nonatomic, copy) NSString *phone;     //手机号码
@property (nonatomic, copy) NSString *telephone;     //坐机号码
@property (nonatomic, copy) NSString *extension;     //分机号码


@property (nonatomic, strong) HBContactDept * parentGroup;    //上级分组
@property (nonatomic, assign) BOOL selected;     //该组是否为选中状态
@end
//Reply
@interface HBContactInfo : NSObject
@property (nonatomic, assign) BOOL modified;   //是否需要更新本地的联系人缓存文件 YES-需要更新 NO-不需要更新
@property (nonatomic, copy) NSString *updatedTime; //联系人列表的更新时间	需要更新时返回
@property (nonatomic, copy) NSMutableArray *depts; //部门列表 HBContactDept*
@property (nonatomic, copy) NSData *jsonData; //用以保存联系人到本地
@end


//Func checkUpdate
//Reply 更新信息
@interface HBUpdateInfo : NSObject
@property (nonatomic, assign)BOOL isupdate;     //是否有更新 YES-有  NO-没有
@property (nonatomic, assign)BOOL isforceupdate;//是否强制升级 YES-是
@property (nonatomic, copy)NSString *downloadurl;//下载地址	若无更新的版本，则此字段为空
@property (nonatomic, copy)NSString *updateDesc;//升级描述	此字段可以为空
@end


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


//Func registUnit
//Input 注册信息
@interface HBRegistRequest : NSObject
@property (nonatomic, copy) NSString *username;     //用户登录名
@property (nonatomic, copy) NSString *password;     //密码
@property (nonatomic, copy) NSString *divname;      //单位名称
@property (nonatomic, copy) NSString *name;         //用户姓名
@property (nonatomic, copy) NSString *mobilephone;  //手机号
@property (nonatomic, copy) NSString *identitycard; //身份证号码
@property (nonatomic, copy) NSString *scertcn;      //已经存在的签名证书CN号
@property (nonatomic, copy) NSString *code;         //短信验证码
@end
//Output 注册返回信息
@interface HBRegistReply : NSObject
@property (nonatomic, copy) NSString *divid;        //单位ID
@property (nonatomic, copy) NSString *acceptNo;     //订单号
@end


//Func uploadCustomConfig
//Input 上传注册信息
@interface HBCustomConfig : NSObject
@property (nonatomic, copy) NSString *userid;       //用户ID
@property (nonatomic, copy) NSString *key;          //参数标识
@property (nonatomic, copy) NSString *value;        //参数值（若参数为文件类型（如设置用户头像），则此字段为空）
@property (nonatomic, copy) NSString *attachment;   //附件（上传文件时使用, 所填值为文件保存路径）
@property (nonatomic, copy) NSString *descript;     //参数描述
@end


//Func: sendMeeting:
//Input -待发送的消息信息
//Func1: getMeetingList
//Reply_sub 获取到的消息
@interface HBMeetingInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *content;   //会议内容
@property (nonatomic, copy)NSString *image;     //会议图片      -------------------------------?????
@property (nonatomic, copy)NSString *receivers;
@property (nonatomic, copy)NSString *meetingman; //与会人列表
@property (nonatomic, assign)NSInteger leavecount; //请假人数
@property (nonatomic, assign)NSInteger signcount;  //签到人数
@property (nonatomic, copy)NSString *longitude; //经度
@property (nonatomic, copy)NSString *latitude;  //纬度
@property (nonatomic, copy)NSString *address;   //地址
@property (nonatomic, copy)NSString *meetid;    //会议id func1出参
@property (nonatomic, copy)NSString *time;      //发布时间 func1出参
@property (nonatomic, copy)NSMutableArray *replies; //消息回复列表 func1出参  -HBReply *
@end

//Func  getMeetList
//Reply
@interface HBUserMeeting : NSObject
@property (nonatomic, copy) NSArray *meetingList;   //会议列表
@property (nonatomic, copy) NSArray *users;         //发消息的用户列表
@property (nonatomic, copy) NSData *jsonData;       //服务端读取的JSON数据
@end


//Func  getMeetList
//Input 消息请求信息
@interface HBMeetRequestInfo : NSObject
@property (nonatomic, copy)NSString *userid;    //用户id
@property (nonatomic, copy)NSString *getuserid; //待查看用户id
@property (nonatomic, assign)NSInteger pagenum; //第几页
@property (nonatomic, assign)NSInteger pagesize;//每页显示条数
@end




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
