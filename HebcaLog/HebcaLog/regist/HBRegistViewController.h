//
//  HBRegistViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HBRegistViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UITextField *passswordTF;  //登录密码
@property (weak, nonatomic) IBOutlet UITextField *unitIdTF;

- (IBAction)backGroundTouched:(id)sender;
- (IBAction)loginBtnPressed:(id)sender;
@end
