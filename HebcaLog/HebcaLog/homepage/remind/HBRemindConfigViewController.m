//
//  HBRemindConfigViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/10.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBRemindConfigViewController.h"
#import "HBCommonUtil.h"
#import "HBErrorCode.h"//去掉证书，HBCommonUtil.h不再包含errorcode
#import "ToastUIView.h"

#import <QuartzCore/QuartzCore.h>


@implementation HBRemindConfigViewController
{
    BOOL    _isReapt;
    BOOL    _textViewNull;  //提醒内容为空 -YES:textview显示placeholder效果，不要读取textView文本；
                            //           -NO:textView里面为真实提醒内容，此时方可读取textView文本
    CGFloat _configViewInitHeight;
    
    UIActionSheet   *_actionSheet;
    NSString        *_date;
    NSString        *_time;
    NSMutableArray  *_weeks;
    
    NSString        *repeatFirstRemindDate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    [self addNavigatorButton];
    
    _configViewInitHeight = self.configViewHeight.constant;
    repeatFirstRemindDate = nil;
    //数据初始化
    if (self.funcType == 0) {
        _remindInfo = [[HBRemindInfo alloc] init];
        
        NSDate *currdate = [NSDate date];
        _time = [HBCommonUtil getTimeHHmm:currdate];
        _date = [HBCommonUtil getDateWithYMD:currdate];
        
        NSMutableArray *selection = [[NSMutableArray alloc] init];
        _weeks = selection;
        
        _isReapt = NO; //默认不重复，显示日期选择界面，隐藏周几选择界面
        _textViewNull = YES;
        
    }
    else {
        _time = _remindInfo.time;
        _date = [HBCommonUtil translateDate:_remindInfo.date toCN:NO];
        _weeks = _remindInfo.weekSelection;
        
        _isReapt = _remindInfo.isRepeated;
        if (_remindInfo.content == nil || [_remindInfo.content length] == 0) {
            _textViewNull = YES;
        }else {
            _textViewNull = NO;
        }
    }
    
    //界面初始化
    [self arrageViewLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addNavigatorButton
{
    UIImage *image = [UIImage imageNamed:@"btn_accept"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finishRemindConfig) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *navibutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navibutton;
}

- (void)arrageViewLayout
{
    //显示刚进入时的时间
    [self.timeBtn setTitle:_time forState:UIControlStateNormal];
    
    //文本框显示
    if (_textViewNull) { //实现textView placeHolder效果
        [self.RemindTextView setTextColor:[UIColor grayColor]];
        self.RemindTextView.text = @"请输入提醒的内容...";
    } else {
        [self.RemindTextView setTextColor:[UIColor darkTextColor]];
        self.RemindTextView.text = _remindInfo.content;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name: UITextViewTextDidChangeNotification object:nil];

    CGFloat textHeight = self.RemindTextView.contentSize.height;
    if (textHeight > 33) {
        if (textHeight > 100) {
            textHeight = 100;
        }
        self.textViewHeight.constant = textHeight;
        self.configViewHeight.constant = _configViewInitHeight + textHeight - 33;
    }
    
    //重复与否页面的不同显示
    [self adjustRepeatSwitchLayout];
}

- (void)adjustRepeatSwitchLayout {
    UIImage *selectedImage = [UIImage imageNamed:@"checkbox_green_selected"];
    UIImage *unselectedImg = [UIImage imageNamed:@"checkbox_green"];
    
    if (!_isReapt) { //不重复 显示dateView 隐藏weekView
        [self.repeatBtn setImage:unselectedImg forState:UIControlStateNormal];
        
        self.dateView.hidden = NO;
        self.dateViewHeight.constant = 20;
        self.dateLabel.text = [HBCommonUtil translateDate:_date toCN:YES];
        
        self.weekdayView.hidden = YES;
        self.weekdayViewHeight.constant = 0;
    }
    else {  //重复提醒 显示weekView 隐藏dateView
        [self.repeatBtn setImage:selectedImage forState:UIControlStateNormal];
        
        self.dateView.hidden = YES;
        self.dateViewHeight.constant = 0;
        
        self.weekdayView.hidden = NO;
        self.weekdayViewHeight.constant = 20;
        
        for (NSNumber *weekday in _weeks)
        {
            UIButton *weekDayBtn = nil;
            switch ([weekday intValue]) {
                case 0:
                    weekDayBtn = self.SunBtn;
                    break;
                    
                case 1:
                    weekDayBtn = self.MondayBtn;
                    break;
                    
                case 2:
                    weekDayBtn = self.TueBtn;
                    break;
                    
                case 3:
                    weekDayBtn = self.WedBtn;
                    break;
                    
                case 4:
                    weekDayBtn = self.ThuBtn;
                    break;
                    
                case 5:
                    weekDayBtn = self.FriBtn;
                    break;
                    
                case 6:
                    weekDayBtn = self.SatBtn;
                    break;
                    
                default:
                    break;
            }
            
            UIColor *selectColor = [HBCommonUtil greenColor];
            
            [weekDayBtn setTitleColor:selectColor forState:UIControlStateNormal];
        }
    }
}



//---------------------------------------------------

//-------------------- 按钮响应 ----------------------

//---------------------------------------------------


#pragma mark - actions
- (IBAction)backgroundTouched
{
    [self.RemindTextView resignFirstResponder];
}

- (IBAction)timeConfig:(id)sender {
    [self.RemindTextView resignFirstResponder];
    /*
    _timePicker = [[UIDatePicker alloc] init];
    _timePicker.tag = 0;
    _timePicker.datePickerMode = UIDatePickerModeTime;
    
    [self showPickerActionView:_timePicker];
     */
    HBDatepickerView *datepicerView = [[HBDatepickerView alloc] initTimePickerView];
    datepicerView.pDelegate = self;
    [datepicerView showPickerView:self];
}

- (IBAction)dateConfig:(id)sender {
    [self.RemindTextView resignFirstResponder];
    
    _isReapt = NO;
    
    HBDatepickerView *datepicerView = [[HBDatepickerView alloc] initDatePickerView];
    datepicerView.pDelegate = self;
    datepicerView.minDateRequered = YES;
    [datepicerView showPickerView:self];
}

- (void)getBackSettedTime:(NSString *)settedTimeStr
{
    _time = settedTimeStr;
    [self.timeBtn setTitle:_time forState:UIControlStateNormal];
}

- (void)getBackSettedDate:(NSString *)settedDateStr
{
    NSString *dateStr = [HBCommonUtil translateDate:settedDateStr toCN:YES];
    _date = settedDateStr;
    self.dateLabel.text = dateStr;
}


- (IBAction)repeatRemind:(id)sender {
    [self.RemindTextView resignFirstResponder];
    
    _isReapt = !_isReapt;
    
    [self adjustRepeatSwitchLayout];
}

- (IBAction)weekdayTouched:(id)sender {
    [self.RemindTextView resignFirstResponder];
    
    _isReapt = YES;
    
    UIButton *weekdayBtn = (UIButton *)sender;
    NSInteger index = weekdayBtn.tag;
    
    BOOL selected = NO;
    for (NSNumber *num in _weeks) {
        if ([num integerValue] == index) {
            selected = YES;    //之前处于被选中状态
            [_weeks removeObject:num];
            break;
        }
    }
    if (!selected) { //未找到,之前处于未选中状态
        NSMutableArray *newWeeks = [NSMutableArray arrayWithArray:_weeks];
        [newWeeks addObject:[NSNumber numberWithInteger:index]];
        _weeks = newWeeks;
    }
    
    UIColor *selectColor = [HBCommonUtil greenColor];
    UIColor *unslctColor = [UIColor grayColor];
    
    [weekdayBtn setTitleColor:selected ? unslctColor : selectColor forState:UIControlStateNormal];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_textViewNull){  //输入文字时取消placeholder效果
        textView.text = nil;
        textView.textColor = [UIColor darkTextColor];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text == nil || [textView.text length] == 0)
    {
        _textViewNull = YES;
        
        [textView setTextColor:[UIColor grayColor]];
        textView.text = @"请输入提醒内容...";
    }
    else {
        _textViewNull = NO;
    }
}

- (void)textChanged
{
    CGFloat textHeight = self.RemindTextView.contentSize.height;
    if (textHeight > 33) {  //textView初始高度为33
        if (textHeight > 100) {
            textHeight = 100;
        }
        
        self.textViewHeight.constant = textHeight;
    }
    
    //configView的高度 加上textView的增量 即为configView新的高度
    self.configViewHeight.constant = _configViewInitHeight + self.textViewHeight.constant - 33;
}

//---------------------------------------------------

//---------------------提交推送-----------------------

//---------------------------------------------------

#pragma mark - submit remind

- (void)finishRemindConfig
{
    [self.RemindTextView resignFirstResponder];
    
    NSString *remindId = nil;
    //注册本地推送
    if (_isReapt == NO) {   //不重复提醒
        remindId = [self getNotifyId];
        NSString *notificationId = remindId;
        NSInteger result = [self createLocalNotification:notificationId];
        if (result != HB_OK) {
            return;
        }
        
        //保存推送消息，以便界面显示
        NSMutableDictionary *notificationDic = [[NSMutableDictionary alloc] initWithCapacity:6];
        
        //
        NSString *remindContent = _textViewNull ? @"" : self.RemindTextView.text;
        [notificationDic setObject:notificationId forKey:@"id"];
        [notificationDic setObject:[NSNumber numberWithBool:NO] forKey:@"repeated"];
        [notificationDic setObject:self.timeBtn.titleLabel.text forKey:@"time"];
        [notificationDic setObject:self.dateLabel.text forKey:@"date"];
        [notificationDic setObject:remindContent forKey:@"content"];
        
        [self recordNotificationToUerdefault:notificationDic];

    }
    else {
        //重复提醒
        if (_weeks.count == 0) {
            [self.view makeToast:@"请至少选择一天"];
            return;
        }

        remindId = [self getNotifyId];
        for (NSNumber *weekDay in _weeks) {
            //一个有重复提醒的remindInfo中，包含多个notification
            //notification id构建规则：“remindId&n” n取值0-6 表示周日到周一
            NSString *notificationId = [remindId stringByAppendingFormat:@"&%d", [weekDay intValue]];
            
            NSInteger result = [self createLocalNotification:notificationId];
            if (result != HB_OK) {
                return;
            }
            
            //保存推送消息，以便界面显示
            //TODO：取消用户默认配置中保存提醒信息，直接从本地提醒列表（schedueledlocalnotifications）中获取，以降低复杂度  并可实现按时间（提醒的nextfireDate）先后顺序对提醒进行排序
            NSMutableDictionary *notificationDic = [[NSMutableDictionary alloc] initWithCapacity:6];
            
            NSString *remindContent = _textViewNull ? @"" : self.RemindTextView.text;
            [notificationDic setObject:notificationId forKey:@"id"];
            [notificationDic setObject:[NSNumber numberWithBool:_isReapt] forKey:@"repeated"];
            [notificationDic setObject:self.timeBtn.titleLabel.text forKey:@"time"];
            [notificationDic setObject:self.dateLabel.text forKey:@"date"];
            [notificationDic setObject:remindContent forKey:@"content"];
            
            [self recordNotificationToUerdefault:notificationDic];
        }
    }
    
    _remindInfo.remindId = remindId;
    _remindInfo.isRepeated = _isReapt;
    _remindInfo.time  = _time;
    _remindInfo.date = _isReapt ? nil : _date;
    _remindInfo.content = _textViewNull ? nil : self.RemindTextView.text;
    _remindInfo.weekSelection = _weeks;
    
    
    NSString *fireDate = _isReapt ? repeatFirstRemindDate : _date;
    NSString *timeInterval = [HBCommonUtil calculateTimeIntervalSinceNow:fireDate withTime:_time];
    NSString *messge = [NSString stringWithFormat:@"收到！您将在%@后收到提醒！", timeInterval];
    [self.navigationController.view makeToast:messge];
    repeatFirstRemindDate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)createLocalNotification:(NSString *)notifyID {
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil) {
        // 设置推送时间
        NSDate *remindDate = nil;
        if (!_isReapt) {
            remindDate = [self getRemindDate];
            if (remindDate == nil || [remindDate compare:[NSDate date]] == NSOrderedAscending)
            {
                [self.view makeToast:@"提醒时间不能早于当前时间"];
                return HB_FAILED;
            }
        } else {
            int index = [[notifyID substringFromIndex:[notifyID length]-1] intValue]; //重复时，notifyID最后一位表示星期几 0—6:周日-周六
            remindDate = [self getRepeatRemindDate:index];
            if (repeatFirstRemindDate == nil) {
                repeatFirstRemindDate = [HBCommonUtil getDateWithYMD:remindDate];
            }
        }
        
        notification.fireDate = remindDate;
        
        // 设置时区
        notification.timeZone = [NSTimeZone localTimeZone];
        
        // 设置重复间隔
        notification.repeatInterval = _isReapt ? NSWeekCalendarUnit : 0;
        
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 推送内容
        notification.alertBody = _textViewNull?@"":self.RemindTextView.text;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        NSString *userid = [UserDefaultTool getUserId];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid", notifyID, @"id", nil];
        notification.userInfo = info;
        
        
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        
        [app scheduleLocalNotification:notification];
        
        return HB_OK;
    }
    
    return HB_FAILED;
}


- (NSDate *)getRemindDate
{
    NSString *remindDateStr = [_date stringByAppendingFormat:@" %@", _time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *remindDate = [formatter dateFromString:remindDateStr];
    
    return remindDate;
}

- (NSDate *)getRepeatRemindDate:(int)index
{
    //2015年3月1日是星期日，以这周的7天作为基准日期
    NSString *baseDateStr = nil;
    switch (index) {
        case 0:
            baseDateStr = @"2015-03-01";
            break;
        case 1:
            baseDateStr = @"2015-03-02";
            break;
        case 2:
            baseDateStr = @"2015-03-03";
            break;
        case 3:
            baseDateStr = @"2015-03-04";
            break;
        case 4:
            baseDateStr = @"2015-03-05";
            break;
        case 5:
            baseDateStr = @"2015-03-06";
            break;
        case 6:
            baseDateStr = @"2015-03-07";
            break;
            
        default:
            break;
    }
    
    NSString *dateStr = [baseDateStr stringByAppendingFormat:@" %@", _time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *baseDate = [formatter dateFromString:dateStr];
    
    return baseDate;
}

- (NSString *)getNotifyId
{
    if (self.funcType == 1) {
        return _remindInfo.remindId;
    }
    
    //新建提醒时，根据当前日期生成提醒ID
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return dateStr;
}


- (void)recordNotificationToUerdefault:(NSDictionary *)notificationDic
{
    NSString *certCN = [UserDefaultTool getCertCN];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *notifyRecords = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:USER_DEFAULTS_REMIND_INFO]];
    
    if (![[notifyRecords allKeys] containsObject:certCN]) {
        //不存在此证书对应的记录，则增加一条记录
        NSArray *userNotifyRecords = [NSArray arrayWithObject:notificationDic];
        [notifyRecords setObject:userNotifyRecords forKey:certCN];
        
        [defaults setObject:notifyRecords forKey:USER_DEFAULTS_REMIND_INFO];
        [defaults synchronize];
        return;
    }
    
    BOOL found = NO;
    NSMutableArray *userNotifyRecords = [[notifyRecords objectForKey:certCN] mutableCopy];
    NSArray *tempArray = [NSArray arrayWithArray:[userNotifyRecords copy]];
    for (NSDictionary *record in tempArray) {
        NSString *recordId = [record objectForKey:@"id"];
        NSString *notifyId = [notificationDic objectForKey:@"id"];
        if ([recordId isEqualToString:notifyId] ) {
            NSUInteger index = [userNotifyRecords indexOfObject:record];
            [userNotifyRecords replaceObjectAtIndex:index withObject:notificationDic];
            found = YES;
        }
        
    }
    if (!found) {
        [userNotifyRecords addObject:notificationDic];
    }
    
    [notifyRecords setObject:userNotifyRecords forKey:certCN];
    
    [defaults setObject:notifyRecords forKey:USER_DEFAULTS_REMIND_INFO];
    [defaults synchronize];
}

@end
