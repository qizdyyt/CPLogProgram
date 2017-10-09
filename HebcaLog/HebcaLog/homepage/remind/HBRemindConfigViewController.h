//
//  HBRemindConfigViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/10.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBRemindViewController.h"
#import "HBDatepickerView.h"

@interface HBRemindConfigViewController : UIViewController <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, HBDatepickerDelegate>

//@property (strong, nonatomic)HBRemindViewController* remindViewControl;
@property (nonatomic, retain)HBRemindInfo *remindInfo;
@property (nonatomic, assign)NSInteger funcType;        //0-新建  1-配置


@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UITextView *RemindTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateViewHeight;

@property (weak, nonatomic) IBOutlet UIView *weekdayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekdayViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *configViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *MondayBtn;
@property (weak, nonatomic) IBOutlet UIButton *TueBtn;
@property (weak, nonatomic) IBOutlet UIButton *WedBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThuBtn;
@property (weak, nonatomic) IBOutlet UIButton *FriBtn;
@property (weak, nonatomic) IBOutlet UIButton *SatBtn;
@property (weak, nonatomic) IBOutlet UIButton *SunBtn;


- (IBAction)timeConfig:(id)sender;
- (IBAction)dateConfig:(id)sender;
- (IBAction)weekdayTouched:(id)sender;

- (IBAction)repeatRemind:(id)sender;

- (IBAction)backgroundTouched;

@end
