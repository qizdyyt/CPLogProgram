//
//  HBSettingViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/15.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPopListView.h"
#import "MBProgressHUD.h"

@interface HBSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HBPopListViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *divNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *setTabelView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)changeHeadImg:(id)sender;

- (IBAction)exitAccount:(id)sender;
- (void)passwordChanged;

@end
