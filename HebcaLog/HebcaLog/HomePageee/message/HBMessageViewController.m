//
//  HBMessageViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBMessageViewController.h"
#import "HBMessageCell.h"
#import "HBServerInterface.h"
#import "HBNewMsgViewController.h"
#import "ToastUIView.h"
#import "HBFileManager.h"
#import <QuartzCore/QuartzCore.h>
#import "MJRefresh.h"

#import "HBCommonUtil.h"
#import "HBErrorCode.h"//由于去掉证书部分，HBCommonUtil.h不再包含这个文件

#define HB_GET_SERVER_MESSAGE_FAILED @"获取服务器消息记录失败"
#define HB_GET_SERVER_JOURNAL_FAILED @"获取服务器日志记录失败"
#define HB_GET_SERVER_MEETING_FAILED @"获取服务器会议记录失败"

#define HB_PAGE_SIZE 8
#define CELL_HEAD_GAP 86

static NSString *cellIdentifier = @"messageCellIdentifier";

@interface HBMessageViewController ()

@end

@implementation HBMessageViewController
{
    NSString *_userid;      //登录用户id
    NSString *_getUserId;   //被查询用户id
    NSArray *_userIdList;   //发消息、写日志的用户id
    NSString *_settedDate;  //查询的日期
    NSMutableDictionary *headImgDic;
    
    NSArray *_messageList;
    NSArray *_journalList;
    NSArray *_meetingList;
    NSMutableDictionary *_cellHeighList;
    NSMutableDictionary *_imageDic;
    
    HBUserMessage *userMsg;//消息
    HBUserJournal *userJnl;//日志
    HBUserMeeting *userMeet;//会议
    HBReplyContent *replyContent;//
    
    UIToolbar *_toolbar;
    HBCommentBarView *_commentBar;
    UIView *_searchView;
    CGRect _viewFrame;
    HBContactViewController *contactVC;
    
    HBServerConnect *serverConnect;
    HBFileManager *fm;
    UIImage *placeHolderImage;
    
    NSInteger _blockCount; //上拉到底后，新加载的块数统计
    BOOL  reachedEnd;   //消息列表获取完毕
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userid = [UserDefaultTool getUserId];
    _authUserList = nil;
    _blockCount = 1;
    reachedEnd = NO;
    _needRefresh  = YES;
    _loadLocalFlag = YES;
    _loadServerFlag = NO; //进入页面时，先从本地读取
    
    _cellHeighList = [[NSMutableDictionary alloc] init];
    _imageDic      = [[NSMutableDictionary alloc] init];
    placeHolderImage = [UIImage imageNamed:@"image_default.png"];
    
    fm = [[HBFileManager alloc] init];
    serverConnect = [[HBServerConnect alloc] init];
    _commentBar = nil;
    _viewFrame  = [UIScreen mainScreen].bounds;
    _settedDate = [HBCommonUtil getDateWithYMD:[NSDate date]];
    
    //在导航栏添加刷新、写消息按钮
    [self addNavigatorButton];
    if (self.hasTeamAuth) {
        [self configNavigationBar2];
    } else {
        [self configNavigationBar];
    }
    
    //初始化顶栏
    [self initHeadView];
    
    //隐藏工具栏
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    //IOS7、IOS8tableview绘制策略不同，IOS8使用estimatedRowHeight
    if SYSTEM_VERSION_HIGHER(8.0) {
        self.tableView.estimatedRowHeight = 160;
    }
    
    [self.activityIndicator stopAnimating];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreServerData)];
    
    
    if (self.type == 1 && self.isTeam == NO) {
        _getUserId = _userid;
    }
    else {
        _getUserId = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:recognizer];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getServerDataWithActivityIndicator];
}

- (void)getServerDataWithActivityIndicator {
    if (YES == _needRefresh) {
        [self.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger loadResult = [self loadUserData];
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                
                if (loadResult != HB_OK) {
                    //TODO 本地服务端获取数据均失败时，显示无消息界面
                    [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
                    
                    return;
                }
                //刷新数据
                [self.tableView reloadData];
            });
        });
        
        _needRefresh = NO;
    }
    
    //如果初始数据不是从服务器获取的，则后台异步重新加载数据
    if (!_loadServerFlag) {
        [self getServerDataAnsync];
    }
}

- (void)initHeadView
{
    [self initSearchView];
    
    if (self.type == 0 || self.type == 2) {  //消息、会议界面不显示dateView 显示搜索框
        self.dateView.hidden = YES;
        self.dateViewHeight.constant = 0;
        
        self.tableView.tableHeaderView = _searchView;
        self.activityTopDistance.constant = _searchView.frame.size.height; //(原有间隙8+searchView高度30)
    }
    else {   //日志界面显示dateView
        self.dateView.hidden = NO;
        self.dateViewHeight.constant = 40;
        
        NSDate *date = [NSDate date];
        self.dateLabel.text = [HBCommonUtil getDateWithWeek:date];
        
        if (self.isTeam) { //团队日志显示搜索栏
            self.tableView.tableHeaderView = _searchView;
            self.activityTopDistance.constant = 38; //(原有间隙8+searchView高度30)
        }
        
        return;
    }
}

- (void)initSearchView
{
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(0,0, _viewFrame.size.width, 30)];
    [_searchView setBackgroundColor:[UIColor lightGrayColor]];
    
    CGRect barFrame = CGRectMake(0, 3, _viewFrame.size.width, 24);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:barFrame];
    searchBar.delegate = self;
    searchBar.placeholder = @"请选择要查看的人员...                      ";
    searchBar.showsCancelButton = YES;
    
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTintColor:[UIColor blackColor]];
            [cancel.titleLabel setTextColor:[UIColor blackColor]];
            [cancel addTarget:self action:@selector(cleanSearchResult) forControlEvents:UIControlEventTouchDown];
        }
    }
    
    [_searchView addSubview:searchBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.type == 0) {
        count = _messageList.count;
    }
    else if (self.type == 1) {
        count = _journalList.count;
    }
    else if (self.type == 2) {
        count = _meetingList.count;
    }
    
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SYSTEM_VERSION_HIGHER(8.0)) {
        return [[_cellHeighList objectForKey:indexPath] floatValue];
    }
    else {
        CGFloat textHeight = [self getTextViewHeight:indexPath.row];
        CGFloat imageHeight = [self getImageViewHeight:indexPath.row];
        CGFloat replysHeight = [self getReplysHeight:indexPath.row];
        CGFloat staffHeight = (2 == self.type ? [self getMeetStaffHeigh:indexPath.row] + 30 : 0);
        
        return CELL_HEAD_GAP + textHeight +imageHeight +replysHeight +staffHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBMessageCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HBMessageCell" owner:self options:nil] lastObject];
    cell.mDelegate = self;
    cell.msgIndex = indexPath.row; //记录在消息列表里面的位置；
    cell.type = self.type;
    
    NSInteger replyCount = 0;
    NSString *textContent = nil;
    NSString *imageName = nil;
    NSString *msgUser = nil;
    CGFloat meetingStaffHeight = 0;
    
    if (0 == self.type) {   //消息
        cell.meetingView.hidden = YES;
        cell.meetingVeiwHeight.constant = 0;
        
        cell.meetingSetView.hidden = YES;
        cell.replySetView.hidden = NO;
        cell.locationLblWidth.constant = [UIScreen mainScreen].bounds.size.width - 24 - 75; //replysetview宽度75
        
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:indexPath.row];
        NSString *username = [msgInfo.userid isEqual:_userid]?@"我":msgInfo.username;
        cell.userNameLbl.text   = username;
        cell.timeLbl.text       = msgInfo.time;
        cell.locationLbl.text   = msgInfo.address;
        cell.replylist          = msgInfo.replies;
        replyCount =   [msgInfo.replies count];
        textContent =   msgInfo.content;
        imageName =     msgInfo.image;
        msgUser = msgInfo.userid;
    }
    else if (1 == self.type) {   //日志
        cell.meetingView.hidden = YES;
        cell.meetingVeiwHeight.constant = 0;
        
        cell.meetingSetView.hidden = YES;
        cell.replySetView.hidden = NO;
        cell.locationLblWidth.constant = [UIScreen mainScreen].bounds.size.width - 24 - 75; //replysetview宽度75
        
        HBJournalInfo *journalInfo = [_journalList objectAtIndex:indexPath.row];
        NSString *username = [journalInfo.userid isEqual:_userid]?@"我":journalInfo.userName;
        cell.userNameLbl.text   = username;
        cell.timeLbl.text       = journalInfo.time;
        
        NSString *address       = journalInfo.address;
        if (address.length == 0 || [address isEqualToString:@"null"]) {
            address = @"来自PC端";
        }
        cell.locationLbl.text   = address;
        cell.replylist          = journalInfo.replies;
        replyCount =  journalInfo.replies.count;
        textContent = journalInfo.content;
        imageName =   journalInfo.image;
        msgUser = journalInfo.userid;
    }
    else if (2 == self.type){
        cell.meetingSetView.hidden = NO;
        cell.replySetView.hidden = YES;
        cell.locationLblWidth.constant = [UIScreen mainScreen].bounds.size.width - 24 - 162; //meetingsetview宽度162
        
        HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:indexPath.row];
        NSString *userName = [meetingInfo.userid isEqual:_userid]?@"我":meetingInfo.username;
        cell.userNameLbl.text  = userName;
        cell.timeLbl.text      = meetingInfo.time;
        
        NSString *address       = meetingInfo.address;
        if (address.length == 0 || [address isEqualToString:@"null"]) {
            address = @"来自PC端";
        }
        cell.locationLbl.text = address;
        cell.leaveCountLabel.text = [NSString stringWithFormat:@"%ld人", (long)meetingInfo.leavecount];
        cell.attendCountLabel.text = [NSString stringWithFormat:@"%ld人", (long)meetingInfo.signcount];
        cell.replylist = meetingInfo.replies;
        
        cell.staffLabel.text = meetingInfo.meetingman;
        CGFloat staffLabelHeight = [self getMeetStaffHeigh:indexPath.row];
        cell.staffLabelHeight.constant = staffLabelHeight;
        cell.staffBackImgViewHeight.constant = staffLabelHeight + 10;
        cell.meetingVeiwHeight.constant = staffLabelHeight + 34;
        meetingStaffHeight = staffLabelHeight + 34;
        
        //添加带箭头边框
        UIImage *image = [UIImage imageNamed:@"bg_reply.9.jpg"];
        UIImage *scaledImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(36, 100, 10, 20)];
        [cell.staffBackImgView setImage:scaledImage];
        
        replyCount  = meetingInfo.replies.count;
        textContent = meetingInfo.content;
        imageName   = meetingInfo.image;
        msgUser     = meetingInfo.userid;
        
    }
    
    if (self.type != 2) {
        cell.replyBtn.tag = indexPath.row;
        [cell.replyBtn addTarget:self action:@selector(replyMessagePressed:) forControlEvents:UIControlEventTouchDown];
    }
    
    //头像显示
    UIImage *headImg = [headImgDic objectForKey:msgUser];
    if (headImg) {
        [cell.headImageView setImage:headImg];
    }
    
    // 1. 消息内容显示
    //处理url地址链接显示
    textContent = [HBCommonUtil transferUrlHtmlStr:textContent];
    //根据文本内容调整textView大小
    cell.messageText.text = textContent;
    cell.messageText.contentInset = UIEdgeInsetsMake(0, 0, -10, 0);
    CGFloat textHeight = [self getTextViewHeight:indexPath.row];
    cell.msgTextViewHeight.constant = textHeight;
    
    // 2. 图片显示
    CGFloat imgheight = 0;
    if (nil != imageName && [imageName length] > 0) {
        UIImage *image = [self getMessageImage:imageName];
        [cell.msgImageView setImage:image];
        
        CGSize imageSize = [self getStandardImageSize:image.size];
        
        cell.imageViewWidth.constant  = imageSize.width;
        cell.imageViewHeight.constant = imageSize.height;
        
        imgheight = imageSize.height;
        
    }
    cell.imageViewHeight.constant = imgheight;
    
    // 3. 回复列表显示
    CGFloat replysHeight = 0;
    
    //回复数量为0  不显示回复图标和计数
    if (replyCount == 0) {
        cell.replyImg.hidden = YES;
        cell.replyCount.hidden = YES;
        cell.replyHeight.constant = 0;
    } else {
        cell.replyImg.hidden = NO;
        cell.replyCount.hidden = NO;
        cell.replyCount.text = [NSString stringWithFormat:@"%ld", (unsigned long)replyCount];
        
        replysHeight = [self getReplysHeight:indexPath.row];
        cell.replyHeight.constant = replysHeight;
        cell.baseViewHeight.constant = replysHeight + 8;
        
        //添加带箭头边框
        UIImage *image = [UIImage imageNamed:@"bg_reply.9.jpg"];
        UIImage *scaledImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(36, 100, 10, 20)];
        [cell.replyBaseView setImage:scaledImage];
    }
    
    CGFloat cellHeight = CELL_HEAD_GAP + textHeight + imgheight +replysHeight + meetingStaffHeight;
    
    [_cellHeighList setObject:[NSNumber numberWithFloat:cellHeight] forKey:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)replyMessagePressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    
    NSString *username= @"";
    if (0 == self.type) {
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:index];
        username = msgInfo.username;
    }
    else if (1 == self.type) {
        HBJournalInfo *journalInfo = [_journalList objectAtIndex:index];
        username = journalInfo.userName;
    }
    
    
    [self initCommentBar];
    
    _commentBar.idTag = index;
    _commentBar.toUserName = username;
    [_commentBar showCommentBar:self Delegate:self];
}


- (CGFloat)getTextViewHeight:(NSInteger)index
{
    NSString *textContent = nil;
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:index];
        textContent = msgInfo.content;
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        textContent = jnlInfo.content;
    }
    else if (2 == self.type) {
        HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:index];
        textContent = meetingInfo.content;
    }
    
    //处理url地址链接显示
    textContent = [HBCommonUtil transferUrlHtmlStr:textContent];
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    CGSize textSize = CGSizeMake(viewSize.width-10, 8000);
    CGFloat fontsize = SYSTEM_VERSION_HIGHER(8.0) ? 14.6 : 14.2;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontsize] forKey: NSFontAttributeName];
    
    CGRect bound =  [textContent boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    
    CGFloat boundheight = ceilf(bound.size.height) + 20; //增加附加值，不然多行字符显示不全
    
    return boundheight;
}

- (CGFloat)getImageViewHeight:(NSInteger)index
{
    NSString *imageName = nil;
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:index];
        imageName = msgInfo.image;
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        imageName = jnlInfo.image;
    }
    else if (2 == self.type) {
        HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:index];
        imageName = meetingInfo.image;
    }
    if (imageName == nil || [imageName length] == 0) {
        return 0;
    }
    
    UIImage *msgImage = [self getMessageImage:imageName];
    CGSize imageSize = [self getStandardImageSize:msgImage.size];
    
    return imageSize.height;
}

- (CGFloat)getReplysHeight:(NSInteger)index
{
    NSArray *replies;
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:index];
        replies = msgInfo.replies;
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        replies = jnlInfo.replies;
    }
    else if (2 == self.type) {
        HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:index];
        replies = meetingInfo.replies;
    }
    if (replies.count == 0) {
        return 0;
    }
    
    CGFloat heightCount = 0;
    for (HBReply *reply in replies) {
        heightCount += [HBMessageCell getReplyCellHeight:reply];
    }
    
    return ceilf(heightCount);
}

- (CGFloat)getMeetStaffHeigh:(NSInteger)index
{
    HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:index];

    NSString *attendStaff = meetingInfo.meetingman;
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    CGSize textSize = CGSizeMake(viewSize.width-10, 8000);
    CGFloat fontsize = 14.0;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontsize] forKey: NSFontAttributeName];
    CGRect bound =  [attendStaff boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    
    CGFloat boundheight = ceilf(bound.size.height); //增加附加值，不然多行字符显示不全
    
    return boundheight;
}

-(void)addNavigatorButton
{
    UIBarButtonItem *segButton = nil;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIImage *freshImage  = [UIImage imageNamed:@"btn_refresh"];
    UIImage *newMsgImage = [UIImage imageNamed:@"btn_add"];
    
    
    UIButton *freshButton  = [[UIButton alloc] initWithFrame:CGRectMake(2, 10, 24, 24)];
    UIButton *newMsgButton = [[UIButton alloc] initWithFrame:CGRectMake(36, 10, 24, 24)];
    
    [freshButton setImage:freshImage forState:UIControlStateNormal];
    [newMsgButton setImage:newMsgImage forState:UIControlStateNormal];
    
    [freshButton addTarget:self action:@selector(refreshMessageList) forControlEvents:UIControlEventTouchDown];
    [newMsgButton addTarget:self action:@selector(newMessage) forControlEvents:UIControlEventTouchDown];
    
    [customView addSubview:freshButton];
    [customView addSubview:newMsgButton];
    segButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.rightBarButtonItem = segButton;
    
}


#pragma mark  消息、日志数据获取
//进入界面后加载数据
- (NSInteger)loadUserData
{
    if (self.isTeam == YES && _hasTeamAuth == YES && _authUserList == nil) {
        _authUserList = [serverConnect getAuthContacts:_userid opType:2];
    }
    
    if (0 == self.type) //消息
    {
        if (_loadLocalFlag) {
            userMsg = [fm getLocalMesage];//从本地读取消息，
            if (!userMsg)   //本地不存在则从服务器读取
            {
                _loadServerFlag = YES;
            }
        }
        if (_loadServerFlag) {
            userMsg = [self getServerMessage];
            if (userMsg == nil) {
                return [serverConnect getLastError];
            }
            if (!_authUserList || _authUserList.count == 0) { //筛选指定联系人的消息不写入本地
                [fm writeUserMessage:userMsg];  //写入本地
            }
        }
        
        _messageList = userMsg.messageList;
        _userIdList = userMsg.users;
    }
    else if(1 == self.type){ //日志
        userJnl = [self getServerJournal];
        if (userJnl == nil) {
            return [serverConnect getLastError];
        }
        
        _journalList = userJnl.journalList;
        _userIdList = userJnl.users;
    }
    else if (2 == self.type) { //会议
        if (_loadLocalFlag) {
            userMeet = [fm getLocalMeeting];//从本地读取会议数据
            if (!userMeet)   //本地不存在则从服务器读取
            {
                _loadServerFlag = YES;
            }
        }
        if (_loadServerFlag) {
            userMeet = [self getServerMeeting];
            if (userMeet == nil) {
                return [serverConnect getLastError];
            }
            if (!_authUserList || _authUserList.count == 0) { //筛选指定联系人的会议数据不写入本地
                [fm writeUserMeetings:userMeet];  //写入本地
            }
        }
        
        _meetingList = userMeet.meetingList;
        _userIdList = userMeet.users;
        
    }
    
    [self getUsersHeadImage];
    
    return HB_OK;
}

- (void)loadServerData   //加载服务器数据，并写入本地
{
    if (0 == self.type){
        userMsg = [self getServerMessage];
        if (userMsg == nil) {
            return;
        }
        [fm writeUserMessage:userMsg];  //写入本地
        
        _messageList = userMsg.messageList;
        _userIdList = userMsg.users;
    }
    else if(1 == self.type){
        userJnl = [self getServerJournal];
        if (userJnl == nil) {
            return;
        }
//        self writeLocalJournal:userJnl];
        
        _journalList = userJnl.journalList;
        _userIdList = userJnl.users;
    }
    else if (2 == self.type) {
        userMeet = [self getServerMeeting];
        if (!userMeet) {
            return;
        }
        [fm writeUserMeetings:userMeet];
        
        _meetingList = userMeet.meetingList;
        _userIdList = userMeet.users;
    }
    
    [self getUsersHeadImage];
}

- (void)loadMoreServerData
{
    _blockCount ++;
    if (0 == self.type){
        HBMsgRequestInfo *request = [[HBMsgRequestInfo alloc] init];
        request.userid = _userid;
        request.getuserid = @"";
        request.pagenum = _blockCount;
        request.pagesize = HB_PAGE_SIZE;
        
        HBUserMessage *userMessage = [serverConnect getMsgList:request];
        if (!userMessage) {
            //[self.view makeToast:HB_GET_SERVER_MESSAGE_FAILED];
            reachedEnd = YES;
            return;
        }
        if (userMessage.messageList && userMessage.messageList.count > 0) {
            NSMutableArray *messageNewList = [_messageList mutableCopy];
            [messageNewList addObjectsFromArray:userMessage.messageList];
            
            NSMutableArray *newUserids = [_userIdList mutableCopy];
            [newUserids addObjectsFromArray:userMessage.users];
            
            _messageList = [messageNewList copy];
            _userIdList = [newUserids copy];
        }
    }
    else if(1 == self.type){
        HBJournalRequestInfo *request = [[HBJournalRequestInfo alloc] init];
        request.userid = _userid;
        request.getuserid = _getUserId;
        request.pagenum = _blockCount;
        request.pagesize = HB_PAGE_SIZE;
        request.date =_settedDate;
        
        HBUserJournal *userJournal = [serverConnect getJournalList:request];
        if (!userJournal) {
            //[self.view makeToast:HB_GET_SERVER_JOURNAL_FAILED];
            reachedEnd = YES;
            return;
        }
        if (userJournal.journalList && userJournal.journalList.count) {
            NSMutableArray *journalNewList = [_journalList mutableCopy];
            [journalNewList addObjectsFromArray:userJournal.journalList];
            
            NSMutableArray *newUserids = [_userIdList mutableCopy];
            [newUserids addObjectsFromArray:userJournal.users];
            
            _journalList = [journalNewList copy];
            _userIdList = [newUserids copy];
        }
    }
    else if (2 == self.type){
        HBMeetRequestInfo *request = [[HBMeetRequestInfo alloc] init];
        request.userid = _userid;
        request.getuserid = @"";
        request.pagenum = _blockCount;
        request.pagesize = HB_PAGE_SIZE;
        
        HBUserMeeting *userMeeting = [serverConnect getMeetingList:request];
        if (!userMeeting) {
            //[self.view makeToast:HB_GET_SERVER_MESSAGE_FAILED];
            reachedEnd = YES;
            return;
        }
        if (userMeeting.meetingList && userMeeting.meetingList.count > 0) {
            NSMutableArray *meetingNewList = [_meetingList mutableCopy];
            [meetingNewList addObjectsFromArray:userMeeting.meetingList];
            
            NSMutableArray *newUserids = [_userIdList mutableCopy];
            [newUserids addObjectsFromArray:userMeeting.users];
            
            _meetingList = [meetingNewList copy];
            _userIdList = [newUserids copy];
        }
    }
    
    [self getUsersHeadImage];
    
    [self.tableView reloadData];
    [self.tableView footerEndRefreshing];
}

- (void)getServerDataAnsync
{
    if (self.type == 1) { //日志就不重新获取了
        return;
    }
    
    [self.activityIndicator startAnimating]; //显示活动指示器
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.type == 0) {//消息
            userMsg = [self getServerMessage];
            if (userMsg == nil) {
                return;
            }
            [fm writeUserMessage:userMsg];  //写入本地
            _messageList = userMsg.messageList;
            _userIdList = userMsg.users;
        }
//        else if (self.type == 1) //日志
//        {
//            userJnl = [self getServerJournal];
//            if (userJnl == nil) {
//                return;
//            }
//            [self writeLocalJournal:userJnl];
//            _journalList = userJnl.journalList;
//            _userIdList = userJnl.users;
//        }
        else if (2 == self.type) //会议
        {
            userMeet = [self getServerMeeting];
            if (!userMeet) {
                return;
            }
            [fm writeUserMeetings:userMeet];
            _meetingList = userMeet.meetingList;
            _userIdList = userJnl.users;
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}

- (HBUserMessage *)getServerMessage
{
    HBMsgRequestInfo *request = [[HBMsgRequestInfo alloc] init];
    request.userid = _userid;
    request.getuserid = _getUserId;
    request.pagenum = 1;
    request.pagesize = HB_PAGE_SIZE;
    
    HBUserMessage *message = [serverConnect getMsgList:request];
    if (message == nil) {
        if ([serverConnect getLastError] == HM_SERVER_DATA_NULL) {
            [HBCommonUtil showAttention:@"服务端尚未有消息数据" sender:self];
        } else {
            [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
            //[self.view makeToast:[serverConnect getLastErrorMessage]];
        }
    }
    
    return message;
}

- (HBUserJournal *)getServerJournal
{
    HBJournalRequestInfo *request = [[HBJournalRequestInfo alloc] init];
    request.userid = _userid;
    request.getuserid = _getUserId;
    request.pagenum = 1;
    request.pagesize = HB_PAGE_SIZE;
    request.date =_settedDate;
    
    HBServerConnect *connect = [[HBServerConnect alloc] init];
    HBUserJournal *jounal = [connect getJournalList:request];
    if (jounal == nil) {
        if ([connect getLastError] == HM_SERVER_DATA_NULL) {
            //[self.view makeToast:@"服务端尚未有日志数据"];
            [HBCommonUtil showAttention:@"服务端尚未有日志数据" sender:self];
        } else {
            //[self.view makeToast:[serverConnect getLastErrorMessage]];
            NSString *errorMessage;
            if ([connect getLastError] == HM_NETWORK_UNREACHABLE) {
                errorMessage = @"网络请求超时，请点击刷新按钮";
            }
            else {
                errorMessage = [connect getLastErrorMessage];
            }
            [HBCommonUtil showAttention:errorMessage sender:self];
        }
    }
    
    return jounal;
}

- (HBUserMeeting *)getServerMeeting
{
    HBMeetRequestInfo *request = [[HBMeetRequestInfo alloc] init];
    request.userid = _userid;
    request.getuserid = _getUserId;
    request.pagenum = 1;
    request.pagesize = HB_PAGE_SIZE;
    
    HBUserMeeting *meeting = [serverConnect getMeetingList:request];
    if (meeting == nil) {
        if ([serverConnect getLastError] == HM_SERVER_DATA_NULL) {
            [HBCommonUtil showAttention:@"服务端尚未有会议数据" sender:self];
        } else {
            [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
            //[self.view makeToast:[serverConnect getLastErrorMessage]];
        }
    }
    
    return meeting;
}

//- (HBUserJournal *)getLocalJournal
//{
//    HBUserJournal *journal = [[HBUserJournal alloc] init];
//    
//    if (self.isTeam) {
//        journal = [fm getTeamLocalJournal];
//        
//    } else {
//        journal = [fm getLocalJournal];
//    }
//    
//    return journal;
//}
//
//- (void)writeLocalJournal:(HBUserJournal *)journal
//{
//    if (self.isTeam) {
//        [fm writeTeamJournal:journal];
//    } else {
//        [fm writeUserJournal:journal];
//    }
//}

- (void)getUsersHeadImage
{
    [_cellHeighList removeAllObjects];
    
    headImgDic = [[NSMutableDictionary alloc] init];
    
    for (NSString *userid in _userIdList)
    {
        if ([[headImgDic allKeys] containsObject:userid]) {
            break;
        }
        
        UIImage *headImage = [HBCommonUtil getUserHead:userid];
        if (headImage) {
            [headImgDic setObject:headImage forKey:userid];
        }
    }
}

-(void)refreshMessageList
{
    reachedEnd = NO;
//    self.tableView.canPullUp = YES;
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        [self loadServerData];
    }completionBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)newMessage
{
    HBNewMsgViewController *newMesgView = [[HBNewMsgViewController alloc] init];
    NSString *title = nil;
    if (0 == self.type) {
        title = @"写消息";
    }
    else if (1 == self.type) {
        title = @"写日志";
    }
    else if (2 == self.type) {
        title = @"创建会议";
    }
    
    newMesgView.title = title;
    newMesgView.type  = self.type;
    newMesgView.mesgVC = self;
    [self.navigationController pushViewController:newMesgView animated:YES];
}

- (IBAction)configDate:(id)sender
{
    HBDatepickerView *datepicerView = [[HBDatepickerView alloc] initDatePickerView];
    datepicerView.pDelegate = self;
    [datepicerView showPickerView:self];
}

- (void)getBackSettedDate:(NSString *)settedDateStr
{
    _settedDate = settedDateStr;
    self.dateLabel.text = [HBCommonUtil translateDate:settedDateStr toCN:YES];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    [self.view addSubview:hud];
    
    [hud showWhileExecuting:@selector(getServerJournal) onTarget:self withObject:nil animated:YES];
}

#pragma mark UISearchBarDelegate

//点击搜索栏，弹出联系人多选列表
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    contactVC = [[HBContactViewController alloc] init];
    contactVC.funcType = 1;
    contactVC.selectDelegate = self;
    
    if (self.type == 1) {
        contactVC.authUserIds = _authUserList;
        contactVC.hidesBottomBarWhenPushed = YES;
    }
    
    [self.navigationController pushViewController:contactVC animated:YES];
    
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


//TODO 取消筛选
- (void)cleanSearchResult
{
    
}

- (void)sendCommentText:(UITextView *)textView
{
    NSString *textContent = textView.text;
    if (IS_NULL_STRING(textContent)) {
        return;
    }
    NSRange found = [textContent rangeOfString:@"回复："];
    if (found.length) return;  //如果是placeholder消息，则不发送
    
    NSInteger  result = 0;
    
    if (replyContent == nil) //评论日志、消息
    {
        NSInteger index = textView.tag;
        
        replyContent = [[HBReplyContent alloc] init];
        
        if (self.type == 0) {
            HBMessageInfo *message = [_messageList objectAtIndex:index];
            
            replyContent.replyid = message.msgid;
            replyContent.userid  = _userid;
            replyContent.replyto = @"";
            replyContent.content = textView.text;
            
            result = [serverConnect replyMsg:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"回复消息成功"];
            }
            
        }
        else if (1 == self.type){
            HBJournalInfo *journal = [_journalList objectAtIndex:index];
            
            replyContent.replyid = journal.journalId;
            replyContent.userid  = _userid;
            replyContent.replyto = @"";
            replyContent.content = textView.text;
            
            result = [serverConnect replyJournal:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"回复日志成功"];
            }
        }
        else if (2 == self.type) {
            HBMeetingInfo *meeting = [_meetingList objectAtIndex:index];
            
            replyContent.replyid = meeting.meetid;
            replyContent.userid  = _userid;
            replyContent.replyto = @"";
            replyContent.content = [@"未参加会议，请假原因：" stringByAppendingFormat:@"%@", textView.text];
            
            result = [serverConnect replyMeeting:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"会议请假成功!"];
            }
        }
    }
    else {
        if (self.type == 0) {
            replyContent.content = textView.text;
            result = [serverConnect replyMsg:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"回复消息成功"];
            }
        }
        else if (1 == self.type){
            replyContent.content = textView.text;
            result = [serverConnect replyJournal:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"回复日志成功"];
            }
        }
        else if(2 == self.type) {
            replyContent.content = [@"未参加会议，请假原因：" stringByAppendingFormat:@"%@", textView.text];
    
            result = [serverConnect replyMeeting:replyContent];
            if (result == HB_OK) {
                [self.view makeToast:@"会议请假成功!"];
            }
        }
    }
    
    if (result != HB_OK) {
        [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
        return;
    }
    
    replyContent = nil;
    //刷新数据
    [self.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadServerData];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}


- (void)initCommentBar
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    CGRect barFrame;
    if (self.hasTeamAuth == YES) {
        barFrame = CGRectMake(0, viewSize.height - 144, viewSize.width, 40);
    }else {
        barFrame = CGRectMake(0, viewSize.height - 100, viewSize.width, 40);
    }
    
    _commentBar = [[HBCommentBarView alloc] initWithFrame:barFrame];
    _commentBar.funcType = self.type;
}

- (void)didSelectReplyCell:(HBReplyCell *)cell
{
    NSInteger msgIndex = cell.msgIndex;  //消息/日志index --> HBMessageCell.msgIndex --> HBReplyCell.msgIndex
    NSInteger rplIndex = cell.rplIndex;  //回复列表index
    
    replyContent = [[HBReplyContent alloc] init];
    replyContent.userid  = _userid;
    
    HBReply *reply = nil;
    if (self.type == 0) {
        HBMessageInfo *message = [_messageList objectAtIndex:msgIndex];
        reply = [message.replies objectAtIndex:rplIndex];
        
        replyContent.replyid = message.msgid;
        replyContent.replyto = reply.senderid;
    } else if (1 == self.type) {
        HBJournalInfo *journal = [_journalList objectAtIndex:msgIndex];
        reply = [journal.replies objectAtIndex:rplIndex];
        
        replyContent.replyid = journal.journalId;
        replyContent.replyto = reply.senderid;
    }
    
    [self initCommentBar];
    _commentBar.toUserName = reply.sendername;
    _commentBar.idTag = msgIndex;
    
    [_commentBar showCommentBar:self Delegate:self];
}


- (void)meetingLeaveOut:(NSInteger)msgIndex
{
    [self initCommentBar];
    _commentBar.idTag = msgIndex;
    
    [_commentBar showCommentBar:self Delegate:self];
}

- (void)meetingAttendIn:(NSInteger)msgIndex
{
    HBMeetingInfo *meeting = [_meetingList objectAtIndex:msgIndex];
    
    HBReplyContent *reply = [[HBReplyContent alloc] init];
    reply.userid = _userid;
    reply.replyid = meeting.meetid;
    reply.replyto = @"";
    reply.content = @"签到！";
    
    NSInteger result = [serverConnect replyMeeting:reply];
    if (result != HM_OK) {
        [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
        return;
    }
    
    [self.view makeToast:@"会议签到成功"];
    
    //刷新数据
    [self.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        userMeet = [self getServerMeeting];
        if (!userMeet) {
            return;
        }
        [fm writeUserMeetings:userMeet];
        
        _meetingList = userMeet.meetingList;
        _userIdList = userMeet.users;
        [self getUsersHeadImage];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}


- (void)getBackSelectContacts:(NSMutableArray *)contacts
{
    [contactVC popContactViewController];
    
    NSMutableArray *getUserIds = [[NSMutableArray alloc] init];
    
    for (HBContact *contact in contacts) {
        NSString *userId = [NSString stringWithFormat:@"%ld", (long)[contact.userid integerValue]];
        
        [getUserIds addObject:userId];
    }
    
    self.authUserList = [getUserIds copy];
    _getUserId = [self.authUserList componentsJoinedByString:@","];
    
    _loadServerFlag = YES;
    _loadLocalFlag  = NO;
}

//获取顺序：内存-》无则磁盘文件-》无则网络获取
- (UIImage *)getMessageImage:(NSString *)imageName
{
    if (IS_NULL_STRING(imageName)) {
        return nil;
    }
    UIImage *msgImg = nil;
    
    //首先读内存缓存
    msgImg = [_imageDic objectForKey:imageName];
    if (msgImg) {
        return msgImg;
    }
    
    //本地存在便读取本地，不存在则网络获取
    NSData *imgData = [fm getMessageImageData:imageName];
    if (!imgData) {
        NSString *fullUrl = [MLOG_SERVER_URL stringByAppendingFormat:@"download.action?filename=%@", imageName];
        NSString* imageUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *urlstr = [NSURL URLWithString:imageUrl];
        imgData = [NSData dataWithContentsOfURL:urlstr];
        if (imgData == nil || imgData.length == 0) {
            return placeHolderImage;
        }
        
        [fm writeMessageImage:imgData withName:imageName];
    }
    
    msgImg = [UIImage imageWithData:imgData];
    
    UIImage *newImage = [HBCommonUtil compressImage:msgImg toLevel:1];
    //CGSize imageSize = [self getStandardImageSize:msgImg.size];
    //UIImage *resizeImage = [HBCommonUtil scaleToSize:msgImg size:imageSize];
    
    //存入内存
    [_imageDic setObject:newImage forKey:imageName];
    
    return newImage;
}

- (CGSize)getStandardImageSize:(CGSize)imageSize
{
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat orgWidth = imageSize.width;
    CGFloat orgHeight = imageSize.height;
    
    CGFloat newWidth, newHeight = 0.0;
    
    //纵向图片，固定宽度为屏幕一半
    if (orgHeight >= orgWidth) {
        if (orgWidth > viewWidth*0.5) { //宽度大于屏幕一半，则宽度缩小至屏幕一半
            newWidth = viewWidth*0.5;
            newHeight = newWidth * orgHeight / orgWidth;
        }
        else { //宽度小于屏幕一半，宽高保持原有
            newWidth = orgWidth;
            newHeight = orgHeight;
        }
    }
    //横向图片，宽度固定位屏幕70%
    else {
        if (orgWidth >= viewWidth*0.7) {
            newWidth = viewWidth*0.7;
            newHeight = newWidth * orgHeight / orgWidth;
        }
        else {
            newWidth = orgWidth;
            newHeight = orgHeight;
        }
    }
    
    return CGSizeMake(newWidth, newHeight);
}

- (void)handleSwipe
{
    if (_commentBar) {
        [_commentBar dismissCommentBar];
        _commentBar = nil;
    }
}
/*
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state
{
    if (state == PullUpLoadState) {
        [self performSelector:@selector(PullUpLoadEnd) withObject:nil afterDelay:3];
    }
}


- (void)PullUpLoadEnd
{
    [self loadMoreServerData];
    
    if (reachedEnd) {
        self.tableView.canPullUp = NO;
    }
    
    [_tableView stopLoadWithState:PullUpLoadState];
}
 */

//点击头像，筛选联系人
- (void)msgUserFilterCellAtIndex:(NSInteger)index
{
    NSString *fliterUserid = nil;
    NSMutableArray *newList = [[NSMutableArray alloc] init];
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_messageList objectAtIndex:index];
        fliterUserid = [NSString stringWithFormat:@"%@", msgInfo.userid];
        
        for (HBMessageInfo *msgItem in _messageList) {
            if ([fliterUserid isEqualToString:[NSString stringWithFormat:@"%@", msgItem.userid]]) {
                [newList addObject:msgInfo];
            }
        }
        
        _messageList = [newList copy];
    }
    else if (self.type == 1) {
        HBJournalInfo *journalInfo = [_journalList objectAtIndex:index];
        fliterUserid = [NSString stringWithFormat:@"%@", journalInfo.userid];
        
        for (HBJournalInfo *jnlItem in _journalList) {
            if ([fliterUserid isEqualToString:[NSString stringWithFormat:@"%@", jnlItem.userid]]) {
                [newList addObject:jnlItem];
            }
        }
        
        _journalList = [newList copy];
    }
    else if (self.type == 2) {
        HBMeetingInfo *meetingInfo = [_meetingList objectAtIndex:index];
        fliterUserid = [NSString stringWithFormat:@"%@", meetingInfo.userid];
        
        for (HBMeetingInfo *meetItem in _journalList) {
            if ([fliterUserid isEqualToString:[NSString stringWithFormat:@"%@", meetItem.userid]]) {
                [newList addObject:meetItem];
            }
        }
        
        _meetingList = [newList copy];
    }
    
    _getUserId = fliterUserid;
    
    //TODO：搜索栏显示筛选联系人
    
    [self.tableView reloadData];
}

@end
