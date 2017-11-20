//
//  HBInviteUserViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HBInviteUserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)inviteBtnPressed:(id)sender;

@end


@interface HBAddressContact : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL checked;

@end