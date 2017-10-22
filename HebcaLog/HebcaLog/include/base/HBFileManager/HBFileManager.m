//
//  HBFileManager.m
//  HebcaLog
//
//  Created by 周超 on 15/3/24.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBFileManager.h"
#import "HBServerInterface.h"
#import "HBCommonUtil.h"

@implementation HBFileManager
{
    NSFileManager * _fileManager;
    NSString *_rootPath;
    NSString *_contactPath;
    NSString *_messagePath;
    NSString *_journalPath;
    NSString *_meetingPath;
    NSString *_imageFolder;
    NSString *_headImagePath;
}

- (id)init
{
    self = [super init];
    if (self) {
        _fileManager = [[NSFileManager alloc] init];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString *userFolder = [NSString stringWithFormat:@"%@/", [UserDefaultTool getUserId]];
        _rootPath = [documentsDirectory stringByAppendingPathComponent:userFolder];
        
        BOOL isDir = YES;
        NSError *error = nil;
        if (![_fileManager fileExistsAtPath:_rootPath isDirectory:&isDir]) {
            [_fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    
    return self;
}


- (id)parseLocalFileData:(NSData *)fileData
{
    if (fileData == nil || [fileData length] == 0) {
        return nil;
    }
    
    NSString *sourceReceive = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    NSMutableString *tempParam = [sourceReceive mutableCopy];
    //将 \\ 转换为 / (图片路径中的分隔符)
    [tempParam replaceOccurrencesOfString:@"%5C%5C" withString:@"%2F" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //替换制表符
    //[tempParam replaceOccurrencesOfString:@"++++" withString:TAB_REPLACEMENT options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    [tempParam replaceOccurrencesOfString:@"%5Ct" withString:@"%20%20%20%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    [tempParam replaceOccurrencesOfString:@"%09" withString:@"%20%20%20%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //替换换行符
    [tempParam replaceOccurrencesOfString:@"%5Cr%5Cn" withString:@"%5Cn" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    //将+号替换为空格
    [tempParam replaceOccurrencesOfString:@"+" withString:@"%20" options:NSLiteralSearch range:NSMakeRange(0, [tempParam length])];
    
    
    NSString *decodeReceive = [[tempParam copy] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *decodeData = [decodeReceive dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = [[NSError alloc] init];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:&error];
    if (IS_NULL(result) || 0 == [result count]) {
        return nil;
    }
    
    BOOL success = [[result objectForKey:@"success"] boolValue];
    if (!success) {
        return nil;
    }
    
    id userData = [result objectForKey:@"data"];
    
    return userData;
}

/**************************************/
/**************  联系人  ***************/
/**************************************/

- (void)writeUserContacts:(HBContactInfo *)contactInfo
{
    if (contactInfo == nil || contactInfo.jsonData == nil) {
        return;
    }
    
    NSData *contactData = contactInfo.jsonData;
    
    _contactPath = [_rootPath stringByAppendingPathComponent:@"contact"];
    
    if ([_fileManager fileExistsAtPath:_contactPath]) {
        NSError *error = nil;
        [_fileManager removeItemAtPath:_contactPath error:&error];
    }
    
    BOOL result = [_fileManager createFileAtPath:_contactPath contents:contactData attributes:nil];
    if (!result) {
        NSLog(@"写入联系人失败");
    }
}

-(HBContactInfo *)getContactFromLocalFile
{
    _contactPath = [_rootPath stringByAppendingPathComponent:@"contact"];
    
    if (![_fileManager fileExistsAtPath:_contactPath]) {
        return nil;
    }
    
    NSData *fileData = [_fileManager contentsAtPath:_contactPath];
    NSDictionary *retnDic = (NSDictionary *)[self parseLocalFileData:fileData];
    if (retnDic == nil || [retnDic count] == 0) {
        return nil;
    }
    
    HBContactInfo *contactInfo = [[HBContactInfo alloc] init];
    contactInfo.modified = [[retnDic objectForKey:@"modified"] boolValue];
    contactInfo.updatedTime = [retnDic objectForKey:@"updatedTime"];
    
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


/**************************************/
/**************   消息   ***************/
/**************************************/

- (void)writeUserMessage:(HBUserMessage *)userMsg
{
    if (userMsg == nil || userMsg.jsonData == nil) {
        return;
    }

    NSData *MsgData = userMsg.jsonData;
    
    _messagePath = [_rootPath stringByAppendingPathComponent:@"/message"];
    
    if ([_fileManager fileExistsAtPath:_messagePath]) {
        NSError *error = nil;
        [_fileManager removeItemAtPath:_messagePath error:&error];
    }
    
    BOOL result = [_fileManager createFileAtPath:_messagePath contents:MsgData attributes:nil];
    if (!result) {
        NSLog(@"写入消息失败");
    }
}

- (HBUserMessage *)getLocalMesage
{
    _messagePath = [_rootPath stringByAppendingPathComponent:@"/message"];
    
    if (![_fileManager fileExistsAtPath:_messagePath]) {
        return nil;
    }
    
    NSData *fileData = [_fileManager contentsAtPath:_messagePath];
    HBUserMessage * userMsg = [[HBUserMessage alloc] init];
    //userMsg.jsonData = fileData;
    
    NSDictionary *retnDic = [self parseLocalFileData:fileData];
    if (IS_NULL(retnDic) || [retnDic count] == 0) {
        return nil;
    }
    
    //获取消息信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *msgItem in retnRecords) {
        HBMessageInfo *mesg = [[HBMessageInfo alloc] init];
        mesg.msgid =    [msgItem objectForKey:@"id"];
        NSString *userid = [msgItem objectForKey:@"userid"];
        mesg.userid =   userid;
        mesg.username = [msgItem objectForKey:@"username"];
        mesg.content = [msgItem objectForKey:@"content"];
        mesg.image =    [msgItem objectForKey:@"image"];
        NSString *time =[msgItem objectForKey:@"time"];
        mesg.time =     [HBCommonUtil processDate:time];
        mesg.longitude =[msgItem objectForKey:@"longitude"];
        mesg.latitude = [msgItem objectForKey:@"latitude"];
        mesg.address =  [msgItem objectForKey:@"address"];
        
        if (![userids containsObject:userid])
        {
            [userids addObject:userid];
        }
        
        //获取回复列表
        NSArray *retnReplys = [msgItem objectForKey:@"replies"];
        if (retnReplys != nil && [retnReplys count] != 0) {
            NSMutableArray *replys = [NSMutableArray array];
            
            for (NSDictionary *rplItem in retnReplys) {
                HBReply *reply = [[HBReply alloc] init];
                reply.msgid =     [rplItem objectForKey:@"id"];
                //reply.content =  content;
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


/**************************************/
/**************   图片   ***************/
/**************************************/

- (void)writeMessageImage:(NSString *)imgName
{
    if (imgName == nil) {
        return;
    }
    
    _imageFolder = [_rootPath stringByAppendingPathComponent:@"/image/"];
    
    BOOL isDir = YES;
    NSError *error;
    if (![_fileManager fileExistsAtPath:_imageFolder isDirectory:&isDir])
    {
        [_fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //获取图片数据
    NSString *fullUrl = [MLOG_SERVER_URL stringByAppendingFormat:@"download.action?filename=%@", imgName];
    NSString* imageUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlstr = [NSURL URLWithString:imageUrl];
    NSData *imgData = [NSData dataWithContentsOfURL:urlstr];
    if (imgData == nil || imgData.length == 0) {
        return ;
    }
    
    //传入的图片路径包含服务器文件夹信息
    NSArray *array = [imgName componentsSeparatedByString:@"/"];
    NSString *imagePath = [_imageFolder stringByAppendingPathComponent:[array objectAtIndex:1]];
    
    if (![_fileManager fileExistsAtPath:imagePath]) {
        BOOL result = [_fileManager createFileAtPath:imagePath contents:imgData attributes:nil];
        if (!result) {
            NSLog(@"写入图片失败");
        }
    }
    
    return;
}

- (void)writeMessageImage:(NSData *)imgData withName:(NSString *)imgName
{
    if (imgName == nil || imgData == nil) {
        return;
    }
    
    _imageFolder = [_rootPath stringByAppendingPathComponent:@"/image/"];
    
    BOOL isDir = YES;
    NSError *error;
    if (![_fileManager fileExistsAtPath:_imageFolder isDirectory:&isDir])
    {
        [_fileManager createDirectoryAtPath:_imageFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //传入的图片路径包含服务器文件夹信息
    NSArray *array = [imgName componentsSeparatedByString:@"/"];
    NSString *imagePath = [_imageFolder stringByAppendingPathComponent:[array objectAtIndex:1]];
    
    if (![_fileManager fileExistsAtPath:imagePath]) {
        BOOL result = [_fileManager createFileAtPath:imagePath contents:imgData attributes:nil];
        if (!result) {
            NSLog(@"写入图片失败");
        }
    }
    
    return;
}

- (NSData *)getMessageImageData:(NSString *)imgName
{
    if (imgName == nil) {
        return nil;
    }
    
    _imageFolder = [_rootPath stringByAppendingPathComponent:@"/image/"];
    
    BOOL isDir = YES;
    if (![_fileManager fileExistsAtPath:_imageFolder isDirectory:&isDir])
    {
        return nil;
    }
    
    NSString *imageNameExist = nil;
    NSArray *imgList = [NSArray arrayWithArray:[_fileManager contentsOfDirectoryAtPath:_imageFolder error:nil]];
    if (imgList && [imgList count]) {
        for (NSString *name in imgList)
        {
            NSRange range = [imgName rangeOfString:name];
            if (range.length > 0) {
                imageNameExist = name;
                break;
            }
        }
    }
    
    if (!imageNameExist) {
        return nil;
    }

    NSString *imagePath = [_imageFolder stringByAppendingPathComponent:imageNameExist];
    NSData *imageData = [_fileManager contentsAtPath:imagePath];
    
    return imageData;
}

/**************************************/
/**************   日志   ***************/
/**************************************/

- (HBUserJournal *)getJournalFromFile:(NSString *)filePath
{
    NSData *fileData = [_fileManager contentsAtPath:filePath];
    HBUserJournal * userJournal = [[HBUserJournal alloc] init];
    
    NSDictionary *retnDic = [self parseLocalFileData:fileData];
    if (IS_NULL(retnDic) || [retnDic count] == 0) {
        return nil;
    }
    
    //获取消息信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *jnItem in retnRecords) {
        HBJournalInfo *jnInfo = [[HBJournalInfo alloc] init];
        jnInfo.journalId =[jnItem objectForKey:@"id"];
        NSString *userid =[jnItem objectForKey:@"userid"];
        jnInfo.userid =   userid;
        jnInfo.userName = [jnItem objectForKey:@"username"];
        jnInfo.content  = [jnItem objectForKey:@"content"];
        jnInfo.image =    [jnItem objectForKey:@"image"];
        NSString *jtime = [jnItem objectForKey:@"time"];
        jnInfo.time =     [HBCommonUtil processDate:jtime];
        jnInfo.longitude =[jnItem objectForKey:@"longitude"];
        jnInfo.latitude = [jnItem objectForKey:@"latitude"];
        jnInfo.address =  [jnItem objectForKey:@"address"];
        
        if (![userids containsObject:userid])
        {
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
                //reply.content =  content;
                reply.content   = [rplItem objectForKey:@"content"];
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
    userJournal.users = [userids copy];
    
    return userJournal;
}

- (void)writeUserJournal:(HBUserJournal *)userJnl
{
    if (userJnl == nil || userJnl.jsonData == nil) {
        return;
    }
    
    NSData *JnlData = userJnl.jsonData;
    
    _journalPath = [_rootPath stringByAppendingPathComponent:@"/userJournal"];
    
    if ([_fileManager fileExistsAtPath:_journalPath]) {
        NSError *error = nil;
        [_fileManager removeItemAtPath:_journalPath error:&error];
    }
    
    BOOL result = [_fileManager createFileAtPath:_journalPath contents:JnlData attributes:nil];
    if (!result) {
        NSLog(@"写入消息失败");
    }
}

- (HBUserJournal *)getLocalJournal
{
    _journalPath = [_rootPath stringByAppendingPathComponent:@"/userJournal"];
    
    if (![_fileManager fileExistsAtPath:_journalPath]) {
        return nil;
    }
    
    HBUserJournal * userJournal = [self getJournalFromFile:_journalPath];
    
    return userJournal;
}

- (void)writeTeamJournal:(HBUserJournal *)userJnl
{
    if (userJnl == nil || userJnl.jsonData == nil) {
        return;
    }
    
    NSData *JnlData = userJnl.jsonData;
    
    _journalPath = [_rootPath stringByAppendingPathComponent:@"/teamJournal"];
    
    if ([_fileManager fileExistsAtPath:_journalPath]) {
        NSError *error = nil;
        [_fileManager removeItemAtPath:_journalPath error:&error];
    }
    
    BOOL result = [_fileManager createFileAtPath:_journalPath contents:JnlData attributes:nil];
    if (!result) {
        NSLog(@"写入消息失败");
    }
}

- (HBUserJournal *)getTeamLocalJournal
{
    _journalPath = [_rootPath stringByAppendingPathComponent:@"/teamJournal"];
    
    if (![_fileManager fileExistsAtPath:_journalPath]) {
        return nil;
    }
    
    HBUserJournal * userJournal = [self getJournalFromFile:_journalPath];
    
    return userJournal;
}


//会议
- (void)writeUserMeetings:(HBUserMeeting *)userMeet
{
    if (userMeet == nil || userMeet.jsonData == nil) {
        return;
    }
    
    NSData *meetData = userMeet.jsonData;
    
    _meetingPath = [_rootPath stringByAppendingPathComponent:@"/meeting"];
    
    if ([_fileManager fileExistsAtPath:_meetingPath]) {
        NSError *error = nil;
        [_fileManager removeItemAtPath:_meetingPath error:&error];
    }
    
    BOOL result = [_fileManager createFileAtPath:_meetingPath contents:meetData attributes:nil];
    if (!result) {
        NSLog(@"写入会议数据失败");
    }
}

- (HBUserMeeting *)getLocalMeeting
{
    _meetingPath = [_rootPath stringByAppendingPathComponent:@"/meeting"];
    
    if (![_fileManager fileExistsAtPath:_meetingPath]) {
        return nil;
    }
    
    NSData *fileData = [_fileManager contentsAtPath:_meetingPath];
    HBUserMeeting * userMeeting = [[HBUserMeeting alloc] init];
    
    NSDictionary *retnDic = [self parseLocalFileData:fileData];
    if (IS_NULL(retnDic) || [retnDic count] == 0) {
        return nil;
    }
    
    //获取消息信息列表
    NSArray *retnRecords = [retnDic objectForKey:@"records"];
    if (retnRecords == nil || [retnRecords count] == 0) {
        return nil;
    }
    
    NSMutableArray *records = [NSMutableArray array];
    NSMutableArray *userids = [NSMutableArray array];
    for (NSDictionary *meetItem in retnRecords) {
        HBMeetingInfo *meet = [[HBMeetingInfo alloc] init];
        meet.meetid =    [meetItem objectForKey:@"id"];
        NSString *userid = [meetItem objectForKey:@"userid"];
        meet.userid =   userid;
        meet.username = [meetItem objectForKey:@"username"];
        meet.content = [meetItem objectForKey:@"content"];
        meet.meetingman = [meetItem objectForKey:@"meetingman"];
        meet.leavecount = [[meetItem objectForKey:@"leavecount"] integerValue];
        meet.signcount = [[meetItem objectForKey:@"signcount"] integerValue];
        meet.image =    [meetItem objectForKey:@"image"];
        NSString *time =[meetItem objectForKey:@"time"];
        meet.time =     [HBCommonUtil processDate:time];
        meet.longitude =[meetItem objectForKey:@"longitude"];
        meet.latitude = [meetItem objectForKey:@"latitude"];
        meet.address =  [meetItem objectForKey:@"address"];
        
        if (![userids containsObject:userid])
        {
            [userids addObject:userid];
        }
        
        //获取回复列表
        NSArray *retnReplys = [meetItem objectForKey:@"replies"];
        if (retnReplys != nil && [retnReplys count] != 0) {
            NSMutableArray *replys = [NSMutableArray array];
            
            for (NSDictionary *rplItem in retnReplys) {
                HBReply *reply = [[HBReply alloc] init];
                reply.msgid =     [rplItem objectForKey:@"id"];
                //reply.content =  content;
                reply.content =   [rplItem objectForKey:@"content"];
                reply.senderid =  [rplItem objectForKey:@"userid"];
                reply.sendername =[rplItem objectForKey:@"username"];
                NSString *rtime = [rplItem objectForKey:@"time"];
                reply.time =      [HBCommonUtil processDate:rtime];
                
                [replys addObject:reply];
            }
            meet.replies = replys;
        }
        
        
        [records addObject:meet];
    }
    
    userMeeting.meetingList = [records copy];
    userMeeting.users = [userids copy];
    
    return userMeeting;
}

- (UIImage *)getUserHeadImg:(NSString *)imageName
{
    if (IS_NULL(imageName)) {
        return nil;
    }
    
    UIImage *image = nil;
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    _headImagePath = [documentsDirectory stringByAppendingPathComponent:@"/heads/"];
    
    BOOL isDir = YES;
    if (![_fileManager fileExistsAtPath:_headImagePath isDirectory:&isDir]) {
        //[_fileManager createDirectoryAtPath:_headImagePath withIntermediateDirectories:YES attributes:nil error:&error];
        return nil;
    }
    
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", _headImagePath, imageName];
    if ([_fileManager fileExistsAtPath:imagePath])
    {
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return image;
}

- (void)writeUserHeadImg:(NSData *)imgData withName:(NSString *)imgName
{
    if (imgName == nil || imgData == nil) {
        return;
    }
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    _headImagePath = [documentsDirectory stringByAppendingPathComponent:@"/heads/"];
    
    BOOL isDir = YES;
    NSError *error = nil;
    if (![_fileManager fileExistsAtPath:_headImagePath isDirectory:&isDir]) {
        [_fileManager createDirectoryAtPath:_headImagePath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    //传入的图片路径包含服务器文件夹信息
    NSString *imagePath = [_headImagePath stringByAppendingPathComponent:imgName];
    
    if (![_fileManager fileExistsAtPath:imagePath]) {
        BOOL result = [_fileManager createFileAtPath:imagePath contents:imgData attributes:nil];
        if (!result) {
            NSLog(@"写入图片失败");
        }
    }
    
    return;
}

@end
