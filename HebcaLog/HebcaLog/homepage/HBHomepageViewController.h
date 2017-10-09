//
//  HBHomepageViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/1/25.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBHomepageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIButton *attendBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UIButton *remindBtn;
@property (weak, nonatomic) IBOutlet UIButton *meetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *doorlistBtn;

@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *logLbl;
@property (weak, nonatomic) IBOutlet UILabel *attendLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet UILabel *contactLbl;
@property (weak, nonatomic) IBOutlet UILabel *remindLbl;
@property (weak, nonatomic) IBOutlet UILabel *meetingLbl;
@property (weak, nonatomic) IBOutlet UILabel *settingLbl;
@property (weak, nonatomic) IBOutlet UILabel *doorsLbl;

- (IBAction)msgBtnPressed:(id)sender;
- (IBAction)logBtnPressed:(id)sender;
- (IBAction)attendBtnPressed:(id)sender;
- (IBAction)locationBtnPressed:(id)sender;
- (IBAction)contactBtnPressed:(id)sender;
- (IBAction)remindBtnPressed:(id)sender;
- (IBAction)setBtnPressed:(id)sender;
- (IBAction)meetingBtnPressed:(id)sender;
- (IBAction)doorlistBtnPressed:(id)sender;

@end
