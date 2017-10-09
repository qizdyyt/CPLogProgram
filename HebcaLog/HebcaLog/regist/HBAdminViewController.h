//
//  HBAdminViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HBAdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate>

@property(nonatomic,weak) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)registBtnPressed:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
