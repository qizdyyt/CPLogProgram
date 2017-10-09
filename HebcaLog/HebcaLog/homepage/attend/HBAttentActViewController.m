//
//  HBAttentActViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/4.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBAttentActViewController.h"
#import "HBCommonUtil.h"
#import "HBServerInterface.h"
#import "AppDelegate.h"
#import "HBLocationService.h"
#import "ToastUIView.h"

@interface HBAttentActViewController ()

@end

@implementation HBAttentActViewController
{
    NSString *_userId;
    HBServerConnect *_serverConnect;
    HBLocationService *locationService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar2];
    [self arrageViewItemsLayout];
    
    _serverConnect = [[HBServerConnect alloc] init];
    locationService = [HBLocationService locationService];
    
    _userId = [HBCommonUtil getUserId];
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(showCurrTime) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showCurrTime];
    BOOL onwork = [HBCommonUtil getAttendState:_userId];
    [self setCheckButtonStatus:onwork];
    
    //为节省时间，将点击按钮再定位，改为进入此界面后就开始执行定位
    [locationService locateUserCurrentPosition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCurrTime
{
    self.timeLabel.text = [self getTime];
    self.dateLabel.text = [HBCommonUtil getDateWithWeek:[NSDate date]];
}

- (NSString *)getTime {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    
    NSString *currTime = [timeFormatter stringFromDate:[NSDate date]];
    return currTime;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)arrageViewItemsLayout {
    self.title = @"考勤打卡";
    
    CGSize viewSize = [ UIScreen mainScreen].applicationFrame.size;
    
    self.timeLabelTopGap.constant = viewSize.height * 0.15;
    self.timeLabelWidth.constant  = viewSize.width * 0.6;
    
    self.dateLabelHeigh.constant = self.timeLabelHeight.constant *2/7; //保持time、date图标大小比例
    self.dateLabelWidth.constant = self.timeLabelWidth.constant *0.62; //保持time、date图标大小比例
    
    self.buttonBottomGap.constant = viewSize.height * 0.1;
    self.buttonWidth.constant     = viewSize.width * 0.7;
    
    if (viewSize.width > 320) {
        self.buttonHeight.constant = 40;
    }
}

- (IBAction)checkin:(id)sender {
    if (locationService.inLocating) {
        [self.view makeToast:@"正在获取您的位置，请稍后重试"];
        return;
    }
    
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"正在打卡...";
    [self.view addSubview:hud];
    
    __block NSString *errorMsg = nil;
    [hud showAnimated:YES whileExecutingBlock:^{
        errorMsg = [self attendActCheckin];
    }completionBlock:^{
        [hud removeFromSuperview];
        
        if (errorMsg) {
            [HBCommonUtil showAttention:errorMsg sender:self];
            return;
        }
        
        [self setCheckButtonStatus:YES];
        [HBCommonUtil updateAttendState:YES];
        
        //开始定位 上传位置
        [locationService startAutoLocating];
        
        [self.view makeToast:@"打卡成功"];
        [self.checkinBtn setTitle:@"已打卡" forState:UIControlStateNormal];

    }];
}

- (NSString *)attendActCheckin
{
    HBLocation *location = [HBCommonUtil getUserLocation];
    
    HBAttendInfo *attendInfo = [[HBAttendInfo alloc] init];
    attendInfo.userId = _userId;
    attendInfo.longitude = location.longitude;
    attendInfo.latitude  = location.latitude;
    attendInfo.address   = location.address;
    attendInfo.type      = 1; //上班打卡
    
    NSInteger result = [_serverConnect attendAct:attendInfo];
    if (result != HM_OK) {
        return [_serverConnect getLastErrorMessage];
    }
    
    return nil;
}

- (void)setCheckButtonStatus:(BOOL)attendState
{
    if (!attendState) { //还没有打卡
        [self.checkinBtn setTitle: @"未打卡" forState:UIControlStateNormal];
        [self.checkinBtn setBackgroundImage:[UIImage imageNamed:@"btn_checkout"] forState:UIControlStateNormal];
    }
    else {
        [self.checkinBtn setTitle: @"已打卡" forState:UIControlStateNormal];
        [self.checkinBtn setBackgroundImage:[UIImage imageNamed:@"btn_checkin"] forState:UIControlStateNormal];
    }
}


@end
