//
//  HBMLogLoginViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

/////////************////////////////

//登录界面

////////////////////************/////////
#import <UIKit/UIKit.h>
#import "HBPopoverController.h"
#import "HBPopListView.h"
#import "MBProgressHUD.h"
#import "QMUIKit.h"

@interface HBMLogLoginViewController : UIViewController <UITextFieldDelegate, HBPopListViewDelegate, MBProgressHUDDelegate>
@property(nonatomic,weak) UIWindow *window;
@property (weak, nonatomic) IBOutlet QMUITextField *loginNameTF;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTF;//证书密码
//背景点击
- (IBAction)backGroundTouched:(id)sender;
//注册点击
- (IBAction)registBtnPressed:(id)sender;
//登录点击
- (IBAction)loginButtonPressed:(id)sender;
//忘记密码点击
- (IBAction)resetButtonPressed:(id)sender;


//选择证书，废弃
//- (IBAction)certChoose:(id)sender;
@end
