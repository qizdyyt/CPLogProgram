//
//  HBServerInterface.m
//  HebcaLog
//
//  Created by 周超 on 15/2/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBServerInterface.h"
#import "HBCommonUtil.h"

@implementation HBServerConnect (HBServerInterface)

-(HBUserInfo *)getUserInfo:(NSString *)user password:(NSString *)password divID:(NSString *)divId
{
    if (nil == user || nil == password || nil == divId) {
        HM_SET_ERROR(HM_PARAMETER_INVALID);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"username=%@&password=%@&divid=%@", user, password, divId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"getUser.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    HBUserInfo *userInfo = [[HBUserInfo alloc] init];
    userInfo.userId =   [retnDic objectForKey:@"userid"];
    userInfo.userName = [retnDic objectForKey:@"name"];
    userInfo.phone =    [retnDic objectForKey:@"mobilephone"];
    userInfo.idNum =    [retnDic objectForKey:@"identitycard"];
    userInfo.certCN =   [retnDic objectForKey:@"certcn"];
    userInfo.divname =  [retnDic objectForKey:@"divname"];
    
    return userInfo;
}


-(HBLoginReply *)loginWithParam:(HBLoginParam *)loginParam
{
    if (IS_NULL(loginParam)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"cert", loginParam.cert)];
    [paramDic addObject: MAKE_PARAM(@"random", loginParam.random)];
    [paramDic addObject: MAKE_PARAM(@"randomsign", loginParam.randomSign)];
    [paramDic addObject: MAKE_PARAM(@"username", loginParam.userName)];
    [paramDic addObject: MAKE_PARAM(@"password", loginParam.password)];
    [paramDic addObject: MAKE_PARAM(@"divid", loginParam.divid)];
    [paramDic addObject: MAKE_PARAM(@"deviceid", loginParam.deviceId)];
    [paramDic addObject: MAKE_PARAM(@"packageversion", loginParam.pkgVersion)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"login.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    HBLoginReply *reply = [[HBLoginReply alloc] init];
    reply.userId =      [retnDic objectForKey:@"userid"];
    reply.userName =    [retnDic objectForKey:@"name"];
    reply.deptId =      [retnDic objectForKey:@"deptid"];
    reply.deptName =    [retnDic objectForKey:@"deptname"];
    reply.clientRole =  [retnDic objectForKey:@"clientrole"];
    
    return reply;
}

-(NSInteger)bindPushID:(NSString *)certCN pushID:(NSString *)pushID
{
    if (IS_NULL(certCN) || IS_NULL(pushID)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_FAILED;
    }
    
    NSString *param = [NSString stringWithFormat:@"certcn=%@&pushid=%@", certCN, pushID];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"bindpush.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}


-(NSInteger)attendAct:(HBAttendInfo *)attendInfo
{
    if (IS_NULL(attendInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",    attendInfo.userId)];
    [paramDic addObject: MAKE_PARAM(@"longitude", attendInfo.longitude)];
    [paramDic addObject: MAKE_PARAM(@"latitude",  attendInfo.latitude)];
    [paramDic addObject: MAKE_PARAM(@"address",   attendInfo.address)];
    [paramDic addObject: MAKE_INT_PARAM(@"type",  attendInfo.type)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];

    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"attend.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}
-(HBAttendInfo *)getLastAttendInfo:(NSString *)userId
{
    if (IS_NULL(userId)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"userid=%@", userId];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getLastAttend.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    
    HBAttendInfo *attendInfo = [[HBAttendInfo alloc] init];
    attendInfo.time = [retnDic objectForKey:@"time"];
    attendInfo.longitude = [retnDic objectForKey:@"longitude"];
    attendInfo.latitude = [retnDic objectForKey:@"latitude"];
    attendInfo.address = [retnDic objectForKey:@"address"];
    attendInfo.type = [[retnDic objectForKey:@"type"] integerValue];
    
    return attendInfo;
}



-(NSMutableArray *)getDoorListInfo:(NSString *)userId
{
    NSMutableArray *attendList;
    if (IS_NULL(userId)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    NSString *param = [NSString stringWithFormat:@"userid=%@", userId];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getDoorsList.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    //获取门禁记录列表
     NSArray *retnAttendList = [retnDic objectForKey:@"records"];
    if (retnAttendList != nil && [retnAttendList count] > 0) {
        attendList = [NSMutableArray array];
        for (NSDictionary *attendItem in retnAttendList) {
            HBDoorListInfo *doorListInfo = [[HBDoorListInfo alloc] init];
            doorListInfo.CID = [attendItem objectForKey:@"CID"];
            doorListInfo.IID = [attendItem objectForKey:@"IID"];
            doorListInfo.IState = [attendItem objectForKey:@"IState"];
            doorListInfo.Iname = [attendItem objectForKey:@"Iname"];
            doorListInfo.Online = [NSString stringWithFormat:@"%@", [attendItem objectForKey:@"Online"]];
            [attendList addObject:doorListInfo];
        }
    }//if
    return attendList;
}


-(NSInteger)getDoorOpenInfo2:(HBSendDoorOpenInfo *)attendInfo
{
    if (IS_NULL(attendInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",    attendInfo.userId)];
    [paramDic addObject: MAKE_PARAM(@"longitude", attendInfo.longitude)];
    [paramDic addObject: MAKE_PARAM(@"latitude",  attendInfo.latitude)];
    [paramDic addObject: MAKE_PARAM(@"address",   attendInfo.address)];
    [paramDic addObject: MAKE_PARAM(@"CID",   attendInfo.CID)];
    [paramDic addObject: MAKE_PARAM(@"IID",   attendInfo.IID)];
    [paramDic addObject: MAKE_PARAM(@"IState",   @"1")];
    
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"sendDoorOpen.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}

-(HBAttendStatisticInfo *)getAttendStatistics:(HBAttendRequesInfo *)requestInfo
{
    if (IS_NULL(requestInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",    requestInfo.userid)];
    [paramDic addObject: MAKE_PARAM(@"getuserid", requestInfo.getuserid)];
    [paramDic addObject: MAKE_PARAM(@"date",  requestInfo.date)];
    [paramDic addObject: MAKE_BOOL_PARAM(@"badonly", requestInfo.badonly)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagenum",  requestInfo.pagenum)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagesize", requestInfo.pagesize)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getAttendStatisticsList.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }

    
    HBAttendStatisticInfo *attendStatistc = [[HBAttendStatisticInfo alloc] init];
    
    attendStatistc.userid = [retnDic objectForKey:@"userid"];
    attendStatistc.userName = [retnDic objectForKey:@"username"];
    attendStatistc.baddays = [[retnDic objectForKey:@"baddays"] integerValue];
    
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        attendStatistc.records = nil;
        return attendStatistc;
    }
    
    //获取考勤统计信息中的记录列表
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *recordItem in retnRecords) {
        HBAttendRecord *attendRecord = [[HBAttendRecord alloc] init];
        attendRecord.date = [recordItem objectForKey:@"date"];
        attendRecord.worktime = [recordItem objectForKey:@"worktime"];
        NSString *isbad = [recordItem objectForKey:@"isbad"];
        attendRecord.isbad = [isbad isEqualToString:@"true"]?YES:NO;
        
        NSArray *retnAttendList = [recordItem objectForKey:@"attendlist"];
        if (retnAttendList != nil && [retnAttendList count] > 0) {
            //获取考勤记录信息中的打卡列表
            NSMutableArray *attendList = [NSMutableArray array];
            
            for (NSDictionary *attendItem in retnAttendList) {
                HBAttendInfo *attendInfo = [[HBAttendInfo alloc] init];
                attendInfo.type = [[attendItem objectForKey:@"type"] integerValue];
                attendInfo.time = [attendItem objectForKey:@"time"];
                attendInfo.longitude = [attendItem objectForKey:@"longitude"];
                attendInfo.latitude = [attendItem objectForKey:@"latitude"];
                attendInfo.address = [attendItem objectForKey:@"address"];
                
                [attendList addObject:attendInfo];
            }
            attendRecord.attendlist = attendList;
        }//if
        [records addObject:attendRecord];
        
    }//for
    attendStatistc.records = records;
    
    return attendStatistc;
}

-(NSInteger)sendMsg:(HBMessageInfo *)msgInfo
{
    if (IS_NULL(msgInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:7];
    if (!IS_NULL( msgInfo.userid))    [paramDic setObject: msgInfo.userid forKey: @"userid"];
    if (!IS_NULL( msgInfo.content))   [paramDic setObject: msgInfo.content forKey: @"content"];
    if (!IS_NULL( msgInfo.image))     [paramDic setObject: msgInfo.image forKey: @"image"];
    if (!IS_NULL( msgInfo.receivers)) [paramDic setObject: msgInfo.receivers forKey: @"receivers"];
    if (!IS_NULL( msgInfo.longitude)) [paramDic setObject: msgInfo.longitude forKey: @"longitude"];
    if (!IS_NULL( msgInfo.latitude))  [paramDic setObject: msgInfo.latitude forKey: @"latitude"];
    if (!IS_NULL( msgInfo.address))   [paramDic setObject: msgInfo.address forKey: @"address"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequestMultiPart:@"sendMsg.action" parameter:[paramDic copy] response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}


-(HBUserMessage *)getMsgList:(HBMsgRequestInfo *)msgRequest
{
    if (IS_NULL(msgRequest)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",      msgRequest.userid)];
    [paramDic addObject: MAKE_PARAM(@"getuserid",   msgRequest.getuserid)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagenum", msgRequest.pagenum)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagesize",msgRequest.pagesize)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getMsgList.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    HBUserMessage * userMsg = [[HBUserMessage alloc] init];
    userMsg.jsonData = received;
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    //获取消息信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        HM_SET_ERROR_MSG(HM_SERVER_DATA_NULL, HM_SERVER_DATA_NULL_MSG);
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *msgItem in retnRecords) {
        HBMessageInfo *mesg = [[HBMessageInfo alloc] init];
        mesg.msgid =    [msgItem objectForKey:@"id"];
        mesg.username = [msgItem objectForKey:@"username"];
        NSString *userid = [msgItem objectForKey:@"userid"];
        mesg.userid =   userid;
        mesg.content = [msgItem objectForKey:@"content"];
        mesg.image =    [msgItem objectForKey:@"image"];
        NSString *time =[msgItem objectForKey:@"time"];
        mesg.time =  [HBCommonUtil processDate:time];
        mesg.longitude =[msgItem objectForKey:@"longitude"];
        mesg.latitude = [msgItem objectForKey:@"latitude"];
        mesg.address =  [msgItem objectForKey:@"address"];
        
        if (![userids containsObject:userid]) {
            [userids addObject:userid];
        }
        
        //获取回复列表
        NSArray *retnReplys = [msgItem objectForKey:@"replies"];
        if (retnReplys != nil && [retnReplys count] != 0) {
            NSMutableArray *replys = [NSMutableArray array];
            
            for (NSDictionary *rplItem in retnReplys) {
                HBReply *reply = [[HBReply alloc] init];
                reply.msgid =     [rplItem objectForKey:@"id"];
                reply.content =   [rplItem objectForKey:@"content"];
                reply.senderid =  [rplItem objectForKey:@"userid"];
                reply.sendername =[rplItem objectForKey:@"username"];
                NSString *rtime = [rplItem objectForKey:@"time"];
                reply.time =      [HBCommonUtil processDate:rtime];
                
                [replys addObject:reply];
            }
            mesg.replies = replys;
        }
        
        [records addObject:mesg];
    }
    
    userMsg.messageList = [records copy];
    userMsg.users = [userids copy];
    
    return userMsg;
}


-(NSInteger)replyMsg:(HBReplyContent *)replyInfo
{
    if (IS_NULL(replyInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",  replyInfo.userid)];
    [paramDic addObject: MAKE_PARAM(@"replyid", replyInfo.replyid)];
    [paramDic addObject: MAKE_PARAM(@"replyto", replyInfo.replyto)];
    [paramDic addObject: MAKE_PARAM(@"content", replyInfo.content)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"replyMsg.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}

-(NSInteger)writeJournal:(HBJournalInfo *)journal
{
    if (IS_NULL(journal)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:7];
    if (!IS_NULL( journal.userid))    [paramDic setObject: journal.userid forKey: @"userid"];
    if (!IS_NULL( journal.content))   [paramDic setObject: journal.content forKey: @"content"];
    if (!IS_NULL( journal.image))     [paramDic setObject: journal.image forKey: @"image"];
    if (!IS_NULL( journal.longitude)) [paramDic setObject: journal.longitude forKey: @"longitude"];
    if (!IS_NULL( journal.latitude))  [paramDic setObject: journal.latitude forKey: @"latitude"];
    if (!IS_NULL( journal.address))   [paramDic setObject: journal.address forKey: @"address"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequestMultiPart:@"writeJournal.action" parameter:[paramDic copy] response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}

-(HBUserJournal *)getJournalList:(HBJournalRequestInfo *)journalRequest
{
    if (IS_NULL(journalRequest)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",    journalRequest.userid)];
    [paramDic addObject: MAKE_PARAM(@"getuserid", journalRequest.getuserid)];
    [paramDic addObject: MAKE_PARAM(@"date",      journalRequest.date)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagenum",   journalRequest.pagenum)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagesize",  journalRequest.pagesize)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getJournalList.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    HBUserJournal *userJournal = [[HBUserJournal alloc] init];
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    //获取日志信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        HM_SET_ERROR_MSG(HM_SERVER_DATA_NULL, HM_SERVER_DATA_NULL_MSG);
        return nil;
    }

    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *jnItem in retnRecords) {
        HBJournalInfo *jnInfo = [[HBJournalInfo alloc] init];
        jnInfo.journalId =[jnItem objectForKey:@"id"];
        NSString *userid = [jnItem objectForKey:@"userid"];
        jnInfo.userid = userid;
        jnInfo.userName = [jnItem objectForKey:@"username"];
        jnInfo.content = [jnItem objectForKey:@"content"];
        jnInfo.image =    [jnItem objectForKey:@"image"];
        NSString *jtime = [jnItem objectForKey:@"time"];
        jnInfo.time =     [HBCommonUtil processDate:jtime];
        jnInfo.longitude =[jnItem objectForKey:@"longitude"];
        jnInfo.latitude = [jnItem objectForKey:@"latitude"];
        jnInfo.address =  [jnItem objectForKey:@"address"];
        
        if (![userids containsObject:userid]) {
            [userids addObject:userid];
        }
        
        //获取回复列表
        NSArray *retnReplys = [jnItem objectForKey:@"replies"];
        if (retnReplys != nil && [retnReplys count] != 0) {
            NSMutableArray *replys = [NSMutableArray array];
            
            for (NSDictionary *rplItem in retnReplys) {
                HBReply *reply = [[HBReply alloc] init];
                reply.msgid =     [rplItem objectForKey:@"id"];
                //NSMutableString *content = [[rplItem objectForKey:@"content"] mutableCopy];
                //[content replaceOccurrencesOfString:TAB_REPLACEMENT withString:@"    " options:NSLiteralSearch range:NSMakeRange(0, content.length)];
                //reply.content =   content;
                reply.content = [rplItem objectForKey:@"content"];
                reply.senderid =  [rplItem objectForKey:@"userid"];
                reply.sendername =[rplItem objectForKey:@"username"];
                NSString *rtime = [rplItem objectForKey:@"time"];
                reply.time =      [HBCommonUtil processDate:rtime];
                
                [replys addObject:reply];
            }
            jnInfo.replies = replys;
        }
        
        [records addObject:jnInfo];
    }
    userJournal.journalList = records;
    userJournal.jsonData = received;
    userJournal.users = [userids copy];
    
    return userJournal;
}

-(NSInteger)replyJournal:(HBReplyContent *)replyInfo
{
    if (IS_NULL(replyInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",  replyInfo.userid)];
    [paramDic addObject: MAKE_PARAM(@"replyid", replyInfo.replyid)];
    [paramDic addObject: MAKE_PARAM(@"replyto", replyInfo.replyto)];
    [paramDic addObject: MAKE_PARAM(@"content", replyInfo.content)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"replyJournal.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}

-(NSInteger)sendPosition:(HBPosition *)position
{
    if (IS_NULL(position)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",    position.userid)];
    [paramDic addObject: MAKE_PARAM(@"longitude", position.longitude)];
    [paramDic addObject: MAKE_PARAM(@"latitude",  position.latitude)];
    [paramDic addObject: MAKE_PARAM(@"address",   position.address)];
    [paramDic addObject: MAKE_INT_PARAM(@"forcesend", position.forcesend)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"sendPosition.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return HM_FAILED;
    }
    
    return [[retnDic objectForKey:@"type"] integerValue];
}


-(NSMutableArray *)getPositions:(NSString *)userid requestUsers:(NSArray *)users
{
    if (IS_NULL(userid) || IS_NULL(users)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"userid=%@&getuserid=%@", userid, [users componentsJoinedByString:@","]];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getLastPosition.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (nil == retnRecords || 0 == [retnRecords count]) {
        HM_SET_ERROR_MSG(HM_SERVER_DATA_NULL, HM_SERVER_DATA_NULL_MSG);
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *pstItem in retnRecords) {
        HBPosition *position = [[HBPosition alloc] init];
        if (pstItem && [pstItem count]) {
            position.userid =   [pstItem objectForKey:@"userid"];
            position.username = [pstItem objectForKey:@"username"];
            position.longitude =[pstItem objectForKey:@"longitude"];
            position.latitude = [pstItem objectForKey:@"latitude"];
            position.address =  [pstItem objectForKey:@"address"];
            NSString *time =    [pstItem objectForKey:@"time"];
            position.time =     [HBCommonUtil processDate:time];
        }
        
        [records addObject:position];
    }
    
    return records;
}

-(NSMutableArray *)getTrack:(NSString *)userId requstUser:(NSString *)requestUser date:(NSString *)date;
{
    if (IS_NULL(userId) || IS_NULL(requestUser) ||IS_NULL(date)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"userid=%@&getuserid=%@&date=%@", userId, requestUser, date];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getTrack.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }

    
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (nil == retnRecords || 0 == [retnRecords count]) {
        HM_SET_ERROR_MSG(HM_SERVER_DATA_NULL, HM_SERVER_DATA_NULL_MSG);
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    for (NSDictionary *pstItem in retnRecords) {
        HBPosition *position = [[HBPosition alloc] init];
        position.userid =   [pstItem objectForKey:@"userid"];
        position.username = [pstItem objectForKey:@"username"];
        position.longitude =[pstItem objectForKey:@"longitude"];
        position.latitude = [pstItem objectForKey:@"latitude"];
        position.address =  [pstItem objectForKey:@"address"];
        NSString *time =    [pstItem objectForKey:@"time"];
        position.time =     [HBCommonUtil processDate:time];
        
        [records addObject:position];
    }
    
    return records;
}

-(HBContactInfo *)getContacts:(HBContactRequest *)request
{
    if (IS_NULL(request)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",     request.userid)];
    [paramDic addObject: MAKE_PARAM(@"signcert",   request.signcert)];
    [paramDic addObject: MAKE_PARAM(@"signdata",   request.signdata)];
    [paramDic addObject: MAKE_PARAM(@"lastupdated",request.lastupdated)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getContacts.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }

    
    HBContactInfo *contactInfo = [[HBContactInfo alloc] init];
    contactInfo.modified = [[retnDic objectForKey:@"modified"] boolValue];
    contactInfo.updatedTime = [retnDic objectForKey:@"updatedTime"];
    contactInfo.jsonData = received;
    
    NSArray *retnDepts = [retnDic objectForKey:@"depts"];
    if (nil == retnDepts || 0 == [retnDepts count]) {
        return contactInfo;
    }
    
    NSMutableArray *topDepts = [NSMutableArray array];
    for (NSDictionary *deptItem in retnDepts) {
        HBContactDept *dept = [self getContactDept:deptItem];
        dept.selected = NO;
        if (dept != nil) {
            [topDepts addObject:dept];
        }
    }
    contactInfo.depts = topDepts;
    
    return contactInfo;
}

-(HBContactDept *)getContactDept:(NSDictionary *)deptDic
{
    HBContactDept *dept = [[HBContactDept alloc] init];
    dept.deptid = [deptDic objectForKey:@"deptid"];
    dept.deptname = [deptDic objectForKey:@"deptname"];
    
    //获取联系人信息列表
    NSArray *retnContacts = [deptDic objectForKey:@"contacts"];
    if (nil == retnContacts || 0 == [retnContacts count]) {
        dept.contacts = nil;
    }
    else {
        NSMutableArray *contacts = [NSMutableArray array];
        for (NSDictionary *cntItem in retnContacts) {
            HBContact *contact = [[HBContact alloc] init];
            contact.userid =   [cntItem objectForKey:@"userid"];
            contact.username = [cntItem objectForKey:@"name"];
            
            
        
            NSString *phone =    [cntItem objectForKey:@"mobilephone"];
            NSString *phone1 =    [cntItem objectForKey:@"telephone"];
            NSString *ephone =    [cntItem objectForKey:@"extension"];
            //去掉+
            NSRange plusRange = [phone rangeOfString:@"+"];
            if (plusRange.length != 0) {
                NSMutableString *mutablePhone = [phone mutableCopy];
                [mutablePhone deleteCharactersInRange:plusRange];
                phone = [mutablePhone copy];
            }
            contact.phone = phone;
            contact.telephone = phone1;
            contact.extension = ephone;
            contact.parentGroup = dept;
            contact.selected = NO;
            
            [contacts addObject:contact];
        }
        
        dept.contacts = contacts;
    }
    
    
    //获取子联系人列表
    NSArray *subDeptsDic = [deptDic objectForKey:@"depts"];
    if (nil == subDeptsDic || 0 == [subDeptsDic count]) {
        dept.depts = nil;
        return dept;
    }
    
    NSMutableArray *subDepts = [NSMutableArray array];
    for (NSDictionary *subDepItem in subDeptsDic) {
        HBContactDept *subDept = [self getContactDept:subDepItem];
        subDept.parentGroup = dept;
        subDept.selected = NO;
        
        [subDepts addObject:subDept];
    }
    dept.depts = subDepts;
    
    return dept;
}

//type-操作类型1:查看考勤  2:查看日志 3:查看位置信息
-(NSArray *)getAuthContacts:(NSString *)userid opType:(NSInteger)type
{
    if (IS_NULL(userid)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"userid=%@&type=%ld", userid, (long)type];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getAuthContacts.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    //返回数据格式为： {userids = "525,542,552,701,701";} 需要将字符串转换为数组
    NSString *retnStr = [retnDic objectForKey:@"userids"];
    
    return [retnStr componentsSeparatedByString:@","];
}

-(HBUpdateInfo *)checkUpdate:(NSString *)apkversion
{
    if (IS_NULL(apkversion)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"apkversion=%@&OS=iOS", apkversion];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"checkUpdate.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    HBUpdateInfo *updateInfo = [[HBUpdateInfo alloc] init];
    updateInfo.isupdate =    [[retnDic objectForKey:@"isupdate"] boolValue];
    updateInfo.isforceupdate=[[retnDic objectForKey:@"isforceupdate"] boolValue];
    updateInfo.downloadurl = [retnDic objectForKey:@"downloadurl"];
    updateInfo.updateDesc  = [retnDic objectForKey:@"description"];
    
    return updateInfo;
}

-(NSInteger)bugreport:(HBBugInfo *)bugInfo
{
    if (IS_NULL(bugInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"devicetype",bugInfo.devicetype)];
    [paramDic addObject: MAKE_PARAM(@"platform",  bugInfo.platform)];
    [paramDic addObject: MAKE_PARAM(@"phoneid",   bugInfo.phoneid)];
    [paramDic addObject: MAKE_PARAM(@"packagename",     bugInfo.packagename)];
    [paramDic addObject: MAKE_PARAM(@"packageversion",  bugInfo.packageversion)];
    [paramDic addObject: MAKE_PARAM(@"exceptiontime",   bugInfo.exceptiontime)];
    [paramDic addObject: MAKE_PARAM(@"stacktrace", bugInfo.stacktrace)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"bugreport.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}


- (NSInteger)uploadCustomConfig:(HBCustomConfig *)config
{
    if (IS_NULL(config)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:7];
    if (!IS_NULL( config.userid))    [paramDic setObject: config.userid forKey: @"userid"];
    if (!IS_NULL( config.key))       [paramDic setObject: config.key forKey: @"key"];
    if (!IS_NULL( config.value))     [paramDic setObject: config.value forKey: @"value"];
    if (!IS_NULL( config.attachment))[paramDic setObject: config.attachment forKey: @"attachment"];
    if (!IS_NULL( config.descript))  [paramDic setObject: config.descript forKey: @"description"];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequestMultiPart:@"userconfig.action" parameter:paramDic response:&response error:&error];
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return HM_FAILED;
    }
    
    return HM_OK;
}


- (NSString *)getCustomConfigWithUserid:(NSString *)userid withKey:(NSString *)key
{
    if (IS_NULL(userid) || IS_NULL_STRING(key)) {
        HB_SET_ERROR_MESSAGE(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSString *param = [NSString stringWithFormat:@"userid=%@&key=%@", userid, key];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *received = [self httpSynGetRequest:@"getuserconfig.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    NSString *imageDir = [retnDic objectForKey:@"value"];
    
    return imageDir;
}


- (HBRegistReply *)registUnit:(HBRegistRequest *)request
{
    if (IS_NULL(request)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"username",    request.username)];
    [paramDic addObject: MAKE_PARAM(@"password",    request.password)];
    [paramDic addObject: MAKE_PARAM(@"divname",     request.divname)];
    [paramDic addObject: MAKE_PARAM(@"name",        request.name)];
    [paramDic addObject: MAKE_PARAM(@"mobilephone", request.mobilephone)];
    [paramDic addObject: MAKE_PARAM(@"identitycard",request.identitycard)];
    [paramDic addObject: MAKE_PARAM(@"scertcn",     request.scertcn)];
    [paramDic addObject: MAKE_PARAM(@"code",        request.code)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"regUnit.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    HBRegistReply *reply = [[HBRegistReply alloc] init];
    reply.acceptNo = [retnDic objectForKey:@"acceptno"];
    reply.divid    = [retnDic objectForKey:@"divid"];
    
    return reply;
}


- (void)requestVerifyCodeWithPhone:(NSString *)mobilephone devID:(NSString *)imei
{
    if (IS_NULL_STRING(mobilephone) || IS_NULL_STRING(imei)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject:MAKE_PARAM(@"mobilephone", mobilephone)];
    [paramDic addObject:MAKE_PARAM(@"imei", imei)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [self httpSynPostRequest:@"getVerifyCode.action" parameter:param response:&response error:&error];
}


- (void)inviteUserNames:(NSString *)names phones:(NSString *)phones
{
    if (IS_NULL_STRING(names) || IS_NULL_STRING(phones)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject:MAKE_PARAM(@"userid", [HBCommonUtil getUserId])];
    [paramDic addObject:MAKE_PARAM(@"names", names)];
    [paramDic addObject:MAKE_PARAM(@"mobilephones", phones)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [self httpSynPostRequest:@"inviteUser.action" parameter:param response:&response error:&error];
}


//会议
-(NSInteger)createMeeting:(HBMeetingInfo *)meeting
{
    if (IS_NULL(meeting)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:7];
    if (!IS_NULL( meeting.userid))    [paramDic setObject: meeting.userid forKey: @"userid"];
    if (!IS_NULL( meeting.content))   [paramDic setObject: meeting.content forKey: @"content"];
    if (!IS_NULL( meeting.image))     [paramDic setObject: meeting.image forKey: @"image"];
    if (!IS_NULL( meeting.receivers)) [paramDic setObject: meeting.receivers forKey: @"receivers"];
    if (!IS_NULL( meeting.longitude)) [paramDic setObject: meeting.longitude forKey: @"longitude"];
    if (!IS_NULL( meeting.latitude))  [paramDic setObject: meeting.latitude forKey: @"latitude"];
    if (!IS_NULL( meeting.address))   [paramDic setObject: meeting.address forKey: @"address"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequestMultiPart:@"sendMeeting.action" parameter:[paramDic copy] response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}


-(HBUserMeeting *)getMeetingList:(HBMeetRequestInfo *)meetingRequest
{
    if (IS_NULL(meetingRequest)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return nil;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",      meetingRequest.userid)];
    [paramDic addObject: MAKE_PARAM(@"getuserid",   meetingRequest.getuserid)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagenum", meetingRequest.pagenum)];
    [paramDic addObject: MAKE_INT_PARAM(@"pagesize",meetingRequest.pagesize)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynGetRequest:@"getMeetingList.action" parameter:param response:&response error:&error];
    
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return nil;
    }
    
    HBUserMeeting * userMeeting = [[HBUserMeeting alloc] init];
    userMeeting.jsonData = received;
    
    NSDictionary *retnDic = [self getServerInfoData:received];
    if (IS_NULL(retnDic)) {
        return nil;
    }
    
    //获取消息信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        HM_SET_ERROR_MSG(HM_SERVER_DATA_NULL, HM_SERVER_DATA_NULL_MSG);
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *meetingItem in retnRecords) {
        HBMeetingInfo *meeting = [[HBMeetingInfo alloc] init];
        meeting.meetid =    [meetingItem objectForKey:@"id"];
        meeting.username = [meetingItem objectForKey:@"username"];
        NSString *userid = [meetingItem objectForKey:@"userid"];
        meeting.userid =   userid;
        meeting.content = [meetingItem objectForKey:@"content"];
        meeting.meetingman = [meetingItem objectForKey:@"meetingman"];
        meeting.leavecount = [[meetingItem objectForKey:@"leavecount"] integerValue];
        meeting.signcount = [[meetingItem objectForKey:@"signcount"] integerValue];
        meeting.image =    [meetingItem objectForKey:@"image"];
        NSString *time =[meetingItem objectForKey:@"time"];
        meeting.time =  [HBCommonUtil processDate:time];
        meeting.longitude =[meetingItem objectForKey:@"longitude"];
        meeting.latitude = [meetingItem objectForKey:@"latitude"];
        meeting.address =  [meetingItem objectForKey:@"address"];
        
        if (![userids containsObject:userid]) {
            [userids addObject:userid];
        }
        
        //获取回复列表
        NSArray *retnReplys = [meetingItem objectForKey:@"replies"];
        if (retnReplys != nil && [retnReplys count] != 0) {
            NSMutableArray *replys = [NSMutableArray array];
            
            for (NSDictionary *rplItem in retnReplys) {
                HBReply *reply = [[HBReply alloc] init];
                reply.msgid =     [rplItem objectForKey:@"id"];
                reply.content =   [rplItem objectForKey:@"content"];
                reply.senderid =  [rplItem objectForKey:@"userid"];
                reply.sendername =[rplItem objectForKey:@"username"];
                NSString *rtime = [rplItem objectForKey:@"time"];
                reply.time =      [HBCommonUtil processDate:rtime];
                
                [replys addObject:reply];
            }
            meeting.replies = replys;
        }
        
        [records addObject:meeting];
    }
    
    userMeeting.meetingList = [records copy];
    userMeeting.users = [userids copy];
    
    return userMeeting;
}


-(NSInteger)replyMeeting:(HBReplyContent *)replyInfo
{
    if (IS_NULL(replyInfo)) {
        HM_SET_ERROR_MSG(HM_PARAMETER_INVALID, HM_PARAMETER_INVALID_MSG);
        return HM_PARAMETER_INVALID;
    }
    
    NSMutableArray *paramDic = [NSMutableArray array];
    [paramDic addObject: MAKE_PARAM(@"userid",  replyInfo.userid)];
    [paramDic addObject: MAKE_PARAM(@"replyid", replyInfo.replyid)];
    [paramDic addObject: MAKE_PARAM(@"replyto", replyInfo.replyto)];
    //NSString *content = [replyInfo.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [paramDic addObject: MAKE_PARAM(@"content", replyInfo.content)];
    NSString *param = [paramDic componentsJoinedByString:@"&"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *received = [self httpSynPostRequest:@"replyMeeting.action" parameter:param response:&response error:&error];
    if (IS_NULL(received)||0==[received length]) {
        HM_SET_ERROR_MSG(HM_NETWORK_UNREACHABLE, ERROR_MESSAGE(error));
        return HM_NETWORK_UNREACHABLE;
    }
    
    return [self checkServerResult:received];
}

@end
