//
//  HBAttendInfoViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/4.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBContactViewController.h"
#import "HBDatepickerView.h"
#import "MBProgressHUD.h"

@interface HBAttendInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HBContactSelectDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, HBDatepickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendExceptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendExceptionCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *staticView;

- (IBAction)calendarChoose:(id)sender;

@end
