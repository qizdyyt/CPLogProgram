///Users/harisucici/Desktop/HebcaLog_iOS/HebcaLog.xcodeproj
//  HBSettingViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/15.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBDoorlistViewController.h"
//#import "HBPasswordViewController.h"
//#import "HBAboutViewController.h"
#import "HBMLogLoginViewController.h"
#import "HBInviteUserViewController.h"
#import "HBCommonUtil.h"
#import "HBFileManager.h"
#import "ToastUIView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "HBCommonUtil.h"
#import "HBServerInterface.h"
#import "AppDelegate.h"
#import "HBLocationService.h"
#import "ToastUIView.h"
#import "HBServerConfig.h"
#import "HBServerInterface.h"

@interface HBDoorlistViewController ()

@end

@implementation HBDoorlistViewController
{
    NSString *userid;
    NSString *updateUrlStr;
    HBServerConnect *serverConnect;
    HBLocationService *locationService;
    NSMutableArray *doorList;
    NSThread *myThread;
    NSTimer *countDownTimer;
    int secondsCountDown;
    HBLocation *location;
    HBSendDoorOpenInfo *sendDoorOpenInfo;
    HBDoorListInfo *tempDoorListInfo;
    MBProgressHUD *hud;
//    int *time;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    secondsCountDown = 5;
//    time = 0;
    userid = [UserDefaultTool getUserId];

    serverConnect = [[HBServerConnect alloc] init];
    [self doList];
    
    [self configNavigationBar];
    [self.setTabelView setSeparatorInset:UIEdgeInsetsZero];
    
//    if ([UIScreen mainScreen].bounds.size.height > 480) {
//        self.setTabelView.scrollEnabled = NO;
//        self.setTabelView.rowHeight = 60.0;
//    } else {
//        self.setTabelView.scrollEnabled = YES;
//        self.setTabelView.rowHeight = 48.0;
//    }
    
}

- (void)doList {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"获取列表...";
    [self.view addSubview:hud];
    
    __block HBDoorListInfo *errorMsg = nil;
    [hud showAnimated:YES whileExecutingBlock:^{
//        errorMsg = [self attendActCheckout];
        doorList = [self attendActCheckout];
    }completionBlock:^{
        [hud removeFromSuperview];
        self.setTabelView.reloadData;
        if (errorMsg) {
            [HBCommonUtil showAttention:errorMsg sender:self];
            return;
        }

        [HBCommonUtil updateAttendState:NO];
        [self.view makeToast:@"获取列表成功"];
    }];
}

- (NSMutableArray *)attendActCheckout
{
    NSMutableArray *serverAttend = [serverConnect getDoorListInfo:userid];

    return serverAttend;
}

- (void)doOpen:(HBDoorListInfo *)doorListInfo {
    
    //为保证打卡获取到最新位置，打卡时先获取一下最新位置
    [locationService locateUserCurrentPosition];
    while (locationService.inLocating) {
    }

    HBLocation *location = [HBCommonUtil getUserLocation];
        tempDoorListInfo = doorListInfo;
        hud = [[MBProgressHUD alloc] init];
//    if (time!=0) {
//        [self.view makeToast:@"请5秒后再试"];
//    }else{
//        hud.labelText = @"正在开门...";
//        [self.view addSubview:hud];
//        
//        __block NSString *errorMsg = nil;
//        [hud showAnimated:YES whileExecutingBlock:^{
//            errorMsg = [self sendDoorOpen:tempDoorListInfo];
//        }completionBlock:^{
//            [hud removeFromSuperview];
//            
//            if (errorMsg) {
//                [HBCommonUtil showAttention:errorMsg sender:self];
//                return;
//            }
//            
//            [HBCommonUtil updateAttendState:YES];
//            
//            [self.view makeToast:@"指令发送成功"];
//        }];  
//    }
//    myThread = [[NSThread alloc] initWithTarget:self selector:@selector(doTime)object:nil];
//    [myThread start];
    
    NSString *isOnline = tempDoorListInfo.Online;
    if ([isOnline isEqualToString:@"0"]) {
        [self.view makeToast:@"此门禁已离线"];
        
    }else{
        if(secondsCountDown==5){
            NSString *tempName = tempDoorListInfo.Iname;
            NSString *nameString  = @"机房";
            if ([tempName isEqualToString:nameString]) {
                
                [self showOkayCancelAlert];
                
            }else{
                hud.labelText = @"正在开门...";
                [self.view addSubview:hud];
                
                __block NSString *errorMsg = nil;
                [hud showAnimated:YES whileExecutingBlock:^{
                    errorMsg = [self sendDoorOpen:tempDoorListInfo];
                }completionBlock:^{
                    [hud removeFromSuperview];
                    
                    if (errorMsg) {
                        [HBCommonUtil showAttention:errorMsg sender:self];
                        return;
                    }
                    
                    [HBCommonUtil updateAttendState:YES];
                    
                    [self.view makeToast:@"指令发送成功"];
                }];
                
                countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            }
        }else{
            [self.view makeToast:@"请5秒后再试"];
        }

    }
 
}
-(void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown==0){
        secondsCountDown=5;
        [countDownTimer invalidate];
    }
}

//- (void)doTime
//{
//    [self.view makeToast:@"指令发送oooook"];
//    NSThread *theThread = [NSThread currentThread];
//    [NSThread exit];
//    
//}

- (NSString *)sendDoorOpen:(HBDoorListInfo *)doorListInfo
{
    tempDoorListInfo = doorListInfo;
    //按键开门时先获取一下最新位置
    [locationService locateUserCurrentPosition];
    while (locationService.inLocating) {
    }
    
    location = [HBCommonUtil getUserLocation];
    
    sendDoorOpenInfo = [[HBSendDoorOpenInfo alloc] init];
    sendDoorOpenInfo.userId = userid;
    sendDoorOpenInfo.longitude = location.longitude;
    sendDoorOpenInfo.latitude  = location.latitude;
    sendDoorOpenInfo.address   = location.address;
    sendDoorOpenInfo.CID   = tempDoorListInfo.CID;
    sendDoorOpenInfo.IID   = tempDoorListInfo.IID;
    sendDoorOpenInfo.IState   = @"1";
    NSInteger result = [serverConnect getDoorOpenInfo2:sendDoorOpenInfo];
    if (result != HM_OK) {
        return [serverConnect getLastErrorMessage];
    }
 
    return nil;
}

/////////////////////////


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [self showOkayCancelAlert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return doorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CertIdentifier = @"CellIdentifier";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CertIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    HBDoorListInfo *doorListInfo  = doorList[indexPath.row];
    
    
    NSString *tempOnline = @"";
    NSString *isOnline = doorListInfo.Online;
    
    if ([isOnline isEqualToString:@"0"]) {
        tempOnline = @"(离线)";
        cell.textLabel.textColor = [UIColor grayColor];
    }else{
        tempOnline = @"";
        cell.textLabel.textColor = [UIColor blackColor];
    }

    
    
    
    cell.textLabel.text = [doorListInfo.Iname stringByAppendingString:tempOnline];;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HBDoorListInfo *doorListInfo  = doorList[indexPath.row];
    NSString *tempCID = doorListInfo.CID;
    [self doOpen:doorListInfo];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 &&  buttonIndex == 1) {
        NSURL *downloadUrl = [NSURL URLWithString:updateUrlStr];
        //NSURL *downloadUrl = [NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://dn-hebca-kuaiban.qbox.me/kuaiban.plist"];
        [[UIApplication sharedApplication]openURL:downloadUrl];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) view;
            
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark - LeveyPopListView delegates


- (void)myPopListViewDidCancel
{
}


- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

- (void)showOkayCancelAlert {
    NSString *title = NSLocalizedString(@"注意", nil);
    NSString *message = NSLocalizedString(@"是否要开启机房门禁？", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        secondsCountDown = 5;
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        hud.labelText = @"正在开门...";
        [self.view addSubview:hud];
        
        __block NSString *errorMsg = nil;
        [hud showAnimated:YES whileExecutingBlock:^{
            errorMsg = [self sendDoorOpen:tempDoorListInfo];
        }completionBlock:^{
            [hud removeFromSuperview];
            
            if (errorMsg) {
                [HBCommonUtil showAttention:errorMsg sender:self];
                return;
            }
            
            [HBCommonUtil updateAttendState:YES];
            
            [self.view makeToast:@"指令发送成功"];
        }];
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
