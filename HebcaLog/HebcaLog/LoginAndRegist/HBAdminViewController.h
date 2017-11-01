//
//  HBAdminViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "QMUIKit.h"

@protocol HBAdminViewControllerDelegate <NSObject>

@required // 必须实现的
-(void) handleRegist: (HBUserConfig *)user;
@end

@interface HBAdminViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MBProgressHUDDelegate>


@property(nonatomic,weak) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)registBtnPressed:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@property (nonatomic, weak) id<HBAdminViewControllerDelegate> delegate;

@end
