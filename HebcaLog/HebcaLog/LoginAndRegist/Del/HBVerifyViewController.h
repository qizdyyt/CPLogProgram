//
//  HBVerifyViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/2/3.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HBVerifyViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>

@property (nonatomic, copy)NSString *acceptNumber;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *divid;
@property (nonatomic, copy)NSString *deviceId;

@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *reSendMsgBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

- (IBAction)backgroundTaped:(id)sender;
- (IBAction)reSendBtnPressed:(id)sender;
- (IBAction)secondBtnPressed:(id)sender;

@end
