//
//  HBAttentActViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/4.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "HBLocationService.h"

@interface HBAttentActViewController : UIViewController <MBProgressHUDDelegate, HBLocationServiceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkinBtn;


//时间日期约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelTopGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelHeigh;

//打卡按钮约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomGap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;


- (IBAction)checkin:(id)sender;

@end
