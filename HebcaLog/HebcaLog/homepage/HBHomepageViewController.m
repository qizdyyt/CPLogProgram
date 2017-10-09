//
//  HBHomepageViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBHomepageViewController.h"
#import "HBMessageViewController.h"
#import "HBAttentActViewController.h"
#import "HBAttendInfoViewController.h"
#import "HBLocationViewController.h"
#import "HBContactViewController.h"
#import "HBRemindViewController.h"
#import "HBSettingViewController.h"
#import "HBDoorlistViewController.h"
#import "HBCommonUtil.h"
#import "HBServerInterface.h"
#import "AppDelegate.h"
#import "HBFileManager.h"
#import "HBLocationService.h"
#import "ToastUIView.h"
#import "HBAuthorityUtil.h"


@interface HBHomepageViewController ()

@end

@implementation HBHomepageViewController
{
    NSString *_userId;
    HBServerConnect *_serverConnect;
    HBFileManager *fm;
    
    BOOL  firstLogin;
    HB_AUTHOR_STATUS journalTeamAuthorStatus;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self userNewNavigatorBar];
    
    firstLogin = YES;
    _userId = [HBCommonUtil getUserId];
    journalTeamAuthorStatus = HB_UNDETERMINED;
    
    // 要使用百度地图，请先启动BaiduMapManager
    if (g_mapManager == nil) {
        g_mapManager = [[BMKMapManager alloc]init];
    }
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [g_mapManager start:@"gGFUFzheGbWF9MdZjCw7OZEE"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    fm = [[HBFileManager alloc] init];
    _serverConnect = [[HBServerConnect alloc] init];
    
    //获取上班状态
    BOOL  attendStatus = [HBCommonUtil getAttendState:_userId];
    [HBCommonUtil updateAttendState:attendStatus];
    //上班状态启动自动定位
    if (attendStatus) {
        HBLocationService *location = [HBLocationService locationService];
        [location startAutoLocating];
    }
    
    [self getServerDataAsync];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)userNewNavigatorBar
{
    //导航栏位置状态
    if (SYSTEM_VERSION_HIGHER(7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationController.navigationBar.hidden = NO;
    
    //标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    //导航栏颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20.0f/255.0 green:98.0f/255.0 blue:166.0f/255.0 alpha:1.0]];
    
    self.title = @"主页";
}

- (void)getServerDataAsync
{
    [self getContactInfoAsync];
    [self getTeamAuthorityAsync];
}

- (void) getContactInfoAsync {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //检查服务端联系人是否需要更新，是则将联系人写入本地文件
        HBCert *cert = nil;
        NSArray *certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
        for (HBCert *item in certList) {
            NSString *certCN = [item getSubjectItem:HB_DN_GIVEN_NAME];
            if ([certCN isEqualToString:[HBCommonUtil getCertCN]]) {
                cert = item;
                break;
            }
        }
        
        [HBCommonUtil loginCert:cert];
        NSString *signCert = [cert getBase64CertData];
        [cert signDataInit:HB_SHA1];
        NSString *signStr = [NSString stringWithFormat:@"%@", _userId];
        NSData *signedData = [cert signData:[signStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        HBContactRequest *request = [[HBContactRequest alloc] init];
        request.userid = _userId;
        request.signcert = signCert;
        request.signdata = signedData;
        request.lastupdated = [HBCommonUtil getLastUpdateTime];
        
        HBContactInfo *contactInfo = [_serverConnect getContacts:request];
        if (contactInfo) {
            if (contactInfo.modified) {    //需要更新时，写入本地
                [fm writeUserContacts:contactInfo];
            }
        }
        //更新上次更新日期
        NSString *updateDate = [HBCommonUtil getDateWithYMD:[NSDate date]];
        [HBCommonUtil refreshLastUpdateTime:updateDate];
    });
}

//获取团队考勤权限 :1
//获取团队日志权限 :2
//获取团队位置权限 :3
- (void)getTeamAuthorityAsync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HBAuthorityUtil getServerTeamAuthority:HB_ATTEND];
        journalTeamAuthorStatus = [HBAuthorityUtil getServerTeamAuthority:HB_JOURNAL];
        [HBAuthorityUtil getServerTeamAuthority:HB_LOCATION];
    });
}

- (IBAction)msgBtnPressed:(id)sender {
    HBMessageViewController *messageView = [[HBMessageViewController alloc] init];
    messageView.title = @"消息列表";
    messageView.type = 0;
    messageView.isTeam = NO;
    messageView.hasTeamAuth = NO;
    [self.navigationController pushViewController:messageView animated:YES];
}

- (IBAction)logBtnPressed:(id)sender {
    if (journalTeamAuthorStatus == HB_UNDETERMINED) {
        [self.view makeToast:@"正在同步服务器数据，请稍后"];
        return;
    }
    
    //获取有权限查看日志的用户列表
    NSInteger optype = 2; //查看日志
    
    if (journalTeamAuthorStatus == HB_NONE_AUTHOR) {
        HBMessageViewController *journalView = [[HBMessageViewController alloc] init];
        journalView.title = @"我的日志";
        journalView.type = 1;
        journalView.isTeam = NO;
        journalView.hasTeamAuth = NO;
        [self.navigationController pushViewController:journalView animated:YES];
    }
    else if (journalTeamAuthorStatus == HB_AUTHORIZED) {
        UIImage *singleImage = [UIImage imageNamed:@"btn_journal_user_unselect"];
        UIImage *singleSlctImg = [UIImage imageNamed:@"btn_journal_user_select"];
        
        UIImage *teamImage  = [UIImage imageNamed:@"btn_journal_team_unselect"];
        UIImage *teamSlctImg = [UIImage imageNamed:@"btn_journal_team_select"];
        
        HBMessageViewController *myJournalView = [[HBMessageViewController alloc] init];
        myJournalView.title = @"我的日志";
        myJournalView.type = 1;
        myJournalView.isTeam = NO;
        myJournalView.hasTeamAuth = YES;
        myJournalView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的日志" image:singleImage selectedImage:singleSlctImg];
        UINavigationController *myJnNavi = [[UINavigationController alloc] initWithRootViewController:myJournalView];
        myJnNavi.title = @"我的日志";
        
        HBMessageViewController *teamJournalView = [[HBMessageViewController alloc] init];
        teamJournalView.title = @"团队日志";
        teamJournalView.type = 1;
        teamJournalView.isTeam = YES;
        teamJournalView.hasTeamAuth = YES;
        teamJournalView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"团队日志" image:teamImage selectedImage:teamSlctImg];
        UINavigationController *teamJnNavi = [[UINavigationController alloc] initWithRootViewController:teamJournalView];
        teamJnNavi.title = @"团队日志";
        
        UITabBarController *tabbarVC = [[UITabBarController alloc] init];
        [tabbarVC setViewControllers:[NSArray arrayWithObjects:myJnNavi, teamJnNavi, nil]];
        
        //[self.navigationController pushViewController:tabbarVC animated:YES];
        [self presentViewController:tabbarVC animated:YES completion:nil];
    }
}

- (IBAction)attendBtnPressed:(id)sender {
    UIImage *actImg = [UIImage imageNamed:@"icon_attend_act.png"];
    UIImage *actSlctImg = [UIImage imageNamed:@"icon_attend_act_selected.png"];
    UIImage *infoImg = [UIImage imageNamed:@"icon_attend_query"];
    UIImage *infoSlctImg = [UIImage imageNamed:@"icon_attend_query_selected"];
    
    HBAttentActViewController *attendActView = [[HBAttentActViewController alloc] init];
    attendActView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"考勤打卡" image:actImg selectedImage:actSlctImg];
    UINavigationController *actNavi = [[UINavigationController alloc] initWithRootViewController:attendActView];
    actNavi.title = @"考勤打卡";
    
    HBAttendInfoViewController *attendInfoView = [[HBAttendInfoViewController alloc] init];
    attendInfoView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"考勤查询" image:infoImg selectedImage:infoSlctImg];
    UINavigationController *infoNavi = [[UINavigationController alloc] initWithRootViewController:attendInfoView];
    infoNavi.title = @"考勤查询";
    
    NSArray *viewArray = [NSArray arrayWithObjects:actNavi, infoNavi, nil];
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    [tabbarVC setViewControllers:viewArray];
    
    [self presentViewController:tabbarVC animated:YES completion:nil];
}

- (IBAction)locationBtnPressed:(id)sender {
    HBLocationViewController *locationView = [[HBLocationViewController alloc] init];
    locationView.title = @"我的位置";
    [self.navigationController pushViewController:locationView animated:YES];
}

- (IBAction)contactBtnPressed:(id)sender {
    HBContactViewController *contactControl = [[HBContactViewController alloc] init];
    contactControl.funcType = 0;
    contactControl.title = @"通讯录";
    [self.navigationController pushViewController:contactControl animated:YES];
}

- (IBAction)remindBtnPressed:(id)sender {
    HBRemindViewController *remindVC = [[HBRemindViewController alloc] init];
    remindVC.title = @"提醒事项";
    remindVC.funType = 0;
    [self.navigationController pushViewController:remindVC animated:YES];
}

- (IBAction)meetingBtnPressed:(id)sender {
    HBMessageViewController *meetingVC = [[HBMessageViewController alloc] init];
    meetingVC.title = @"会议中心";
    meetingVC.type = 2;
    meetingVC.isTeam = NO;
    meetingVC.hasTeamAuth = NO;
    [self.navigationController pushViewController:meetingVC animated:YES];
}

- (IBAction)doorlistBtnPressed:(id)sender {
    HBDoorlistViewController *doorlistVC = [[HBDoorlistViewController alloc] init];
    doorlistVC.title = @"门禁列表";
    [self.navigationController pushViewController:doorlistVC animated:YES];
}

- (IBAction)setBtnPressed:(id)sender {
    HBSettingViewController *settingVC = [[HBSettingViewController alloc] init];
    settingVC.title = @"个人设置";
    [self.navigationController pushViewController:settingVC animated:YES];
}




@end
