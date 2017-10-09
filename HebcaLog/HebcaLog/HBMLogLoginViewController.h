//
//  HBMLogLoginViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPopoverController.h"
#import "HBPopListView.h"
#import "MBProgressHUD.h"


@interface HBMLogLoginViewController : UIViewController <UITextFieldDelegate, HBPopListViewDelegate, MBProgressHUDDelegate>
@property(nonatomic,weak) UIWindow *window;
@property (weak, nonatomic) IBOutlet UITextField *loginNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;   //证书密码

- (IBAction)backGroundTouched:(id)sender;

- (IBAction)registBtnPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)certChoose:(id)sender;

- (IBAction)testFunc:(id)sender;
@end