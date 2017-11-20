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

@interface HBDoorlistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HBPopListViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *setTabelView;

@end
