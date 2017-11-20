//
//  HBAttendInfoViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/4.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HBAttendInfoViewController.h"
#import "HBAttendInfoTableViewCell.h"
#import "HBCommonUtil.h"
#import "HBAuthorityUtil.h"
#import "HBServerInterface.h"

@interface HBAttendInfoViewController ()

@end

@implementation HBAttendInfoViewController
{
    NSArray *_attendList;
    NSString *_settedDate;
    NSString *_userId;
    HBServerConnect *_serverConnect;
    HBContactViewController *_contactVC;
    HBContact *_selectContact;
    NSArray *_authUserList;
    NSString *queryUserId;
    
    HBAttendStatisticInfo *_attendStatisticInfo;
    //NSArray *_attendInfoList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar2];
    
    _serverConnect = [[HBServerConnect alloc] init];
    _userId = [UserDefaultTool getUserId];
    queryUserId = _userId;
    
    [self initViewItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getAttendStatisticInfo:queryUserId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_attendList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBAttendRecord *attendRecord = [_attendList objectAtIndex:indexPath.row];
    NSArray *attendList = attendRecord.attendlist;
    
    CGFloat baseHeight = 130.0;
    CGFloat cellHeight = baseHeight;
    
    if ([attendList count] > 2) {
        cellHeight += ([attendList count] - 2)*48;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *cellIdentifier = @"attendInfoCell";
    
    HBAttendInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HBAttendInfoTableViewCell" owner:self options:nil] lastObject];
    }
     */
    HBAttendInfoTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HBAttendInfoTableViewCell" owner:self options:nil] lastObject];
    
    //考勤数据
    HBAttendRecord *attendRecord = [_attendList objectAtIndex:indexPath.row];
    cell.attendDateLabel.text = attendRecord.date;
    NSString *worktime = [self getWorkTimeNum:attendRecord.worktime];
    cell.worktimeLabel.text   = worktime;
    if ([worktime floatValue] >= 8.0) {
        cell.worktimeLabel.textColor = [HBCommonUtil greenColor];
    }else {
        cell.worktimeLabel.textColor = [UIColor redColor];
    }
    
    
    //构建考勤信息列表
    CGSize viewSize = [ UIScreen mainScreen].applicationFrame.size;
    CGFloat listHeight = 96;
    NSInteger count = attendRecord.attendlist.count;
    if (count > 4) {
        listHeight += (count - 4) * 48;
    }
    
    CGRect listFrame = CGRectMake(-1, 32, viewSize.width-64+2, listHeight);
    UIView *attendListView = [[UIView alloc] initWithFrame:listFrame];
    attendListView.layer.borderWidth = 1;   //边框线条宽度
    attendListView.layer.borderColor = [[UIColor darkGrayColor] CGColor];  //边框颜色
    
    if (count < 2) {    //至少显示4条记录
        count = 2;
    }
    for (int i = 0; i < count; i++) {
        CGRect attendItemFrame = CGRectMake(0, i*48, listFrame.size.width, 48);
        UIView *attendItemView = [[UIView alloc] initWithFrame:attendItemFrame];
        attendItemView.layer.borderWidth = 0.5;
        attendItemView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        UIColor *textColor = i%2 ? [HBCommonUtil greenColor] : [UIColor orangeColor];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 20)];
        timeLabel.textColor = textColor;
        timeLabel.font    = [UIFont systemFontOfSize:14];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, attendItemFrame.size.width - 70, 38)];
        addrLabel.textColor = textColor;
        addrLabel.font = [UIFont systemFontOfSize:14];
        addrLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addrLabel.numberOfLines = 0;
        addrLabel.textAlignment = NSTextAlignmentNatural;
        
        //考勤数据
        NSString *attendTime = @"无";
        NSString *attendAddr = @" ";
        if (i < [attendRecord.attendlist count]) {
            HBAttendInfo *attendInfo = [attendRecord.attendlist objectAtIndex:i];
            attendTime = [self getTimeFromDate:attendInfo.time];
            attendAddr = attendInfo.address;
            if ([attendAddr isEqualToString:@"null"]) {
                attendAddr = @" ";
            }
        }
        timeLabel.text = attendTime;
        addrLabel.text = attendAddr;
        
        [attendItemView addSubview:timeLabel];
        [attendItemView addSubview:addrLabel];
        [attendListView addSubview:attendItemView];
    }
    
    [cell addSubview:attendListView];
    
    return cell;
}


- (IBAction)calendarChoose:(id)sender {
    HBDatepickerView *datepicerView = [[HBDatepickerView alloc] initDatePickerView];
    datepicerView.pDelegate = self;
    datepicerView.maxDateRequered = YES;
    [datepicerView showPickerView:self];
}


- (void)getBackSettedDate:(NSString *)settedDateStr
{
    _settedDate = settedDateStr;
    self.dateLabel.text = [HBCommonUtil translateDate:_settedDate toCN:YES];
    
    [self getUserAttendStatistic];
}

- (void)initViewItems
{
    self.title = @"考勤查询";
    
    self.nameLabel.text = [UserDefaultTool getUserName];
    _settedDate =   [HBCommonUtil getDateWithYMD:[NSDate date]];
    self.dateLabel.text = _settedDate;
    
    self.attendExceptionLabel.hidden = YES;
    self.attendExceptionCount.hidden = YES;
    
    //如果有权限查看其他人员的考勤，在右上角增加按钮
    HB_AUTHOR_STATUS teamAuthorStatus = [HBAuthorityUtil getTeamAuthority:HB_ATTEND];
    if (teamAuthorStatus == HB_AUTHORIZED) {
        UIImage *image = [UIImage imageNamed:@"btn_person"];
        UIButton *contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [contactBtn setImage:image forState:UIControlStateNormal];
        [contactBtn addTarget:self action:@selector(openContactChooseView) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc] initWithCustomView:contactBtn];
        self.navigationItem.rightBarButtonItem = naviBtn;
    }
}

- (void)openContactChooseView
{
    _contactVC = [[HBContactViewController alloc] init];
    _contactVC.selectDelegate = self;
    _contactVC.funcType = 2; //联系人单选界面
    _contactVC.authUserIds = _authUserList;
    _contactVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_contactVC animated:YES];
}

- (void)getBackSingleSelect:(HBContact *)contact
{
    [_contactVC popContactViewController];
    
    _selectContact = contact;
    self.nameLabel.text = _selectContact.username;
    
    queryUserId = _selectContact.userid;
    [self getAttendStatisticInfo:queryUserId];
}

- (void)getUserAttendStatistic
{
    if (_selectContact) {
        queryUserId = _selectContact.userid;
    }
    
    [self getAttendStatisticInfo:queryUserId];
}

- (void)getAttendStatisticInfo:(NSString *)userId
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"正在查询...";
    [self.view addSubview:hud];
    
    __block NSString *errorMsg = nil;
    [hud showAnimated:YES whileExecutingBlock:^{
        
        HBAttendRequesInfo *request = [[HBAttendRequesInfo alloc] init];
        request.userid = _userId;
        request.getuserid = userId;
        request.date = _settedDate;
        request.badonly = NO;
        request.pagenum = 1;
        request.pagesize = 20;
        
        _attendStatisticInfo = nil;
        _attendStatisticInfo = [_serverConnect getAttendStatistics:request];
        if (!_attendStatisticInfo) {
            errorMsg = @"获取考勤记录失败";
        }
    }completionBlock:^{
        [hud removeFromSuperview];
        if (errorMsg) {
            [HBCommonUtil showAttention:errorMsg sender:self];
            return;
        }
        
        _attendList = _attendStatisticInfo.records;
        self.attendExceptionLabel.hidden = NO;
        self.attendExceptionCount.hidden = NO;
        self.attendExceptionCount.text = [NSString stringWithFormat:@"%ld", (long)_attendStatisticInfo.baddays];
        
        [self.tableView reloadData];
    }];
}
/*
- (NSString *)getMMDDdateFromDate:(NSString *)date
{
    NSArray *dateDic = [date componentsSeparatedByString:@"-"];
    
    NSString *month = [dateDic objectAtIndex:1];
    NSString *day   = [dateDic objectAtIndex:2];
    
    return [NSString stringWithFormat:@"%@月%@日", month, day];
}
*/
- (NSString *)getTimeFromDate:(NSString *)date
{
    if (IS_NULL_STRING(date) || [date isEqualToString:@"null"]) {
        return @"无";
    }
    
    NSArray *dateArr = [date componentsSeparatedByString:@" "];
    if (IS_NULL(dateArr) || dateArr.count < 2) {
        return @"无";
    }
    NSString *timeDetail = [dateArr objectAtIndex:1];
    NSRange timeRange = NSMakeRange(0, 5);
    
    NSString *timeStr = [timeDetail substringWithRange:timeRange];
    
    return timeStr;
}

- (NSString *)getWorkTimeNum:(NSString *)worktime
{
    //worktime 格式：08:39:08
    //将其转化为8.5形式
    NSArray *timeArr = [worktime componentsSeparatedByString:@":"];
    
    NSInteger hour = [[timeArr objectAtIndex:0] integerValue];
    NSInteger minute = [[timeArr objectAtIndex:1] integerValue];
    NSInteger totalMunites = hour*60 + minute;
    
    float decimalHour = (float)totalMunites / 60;
    
    return [NSString stringWithFormat:@"%.01f", decimalHour];
}

@end
