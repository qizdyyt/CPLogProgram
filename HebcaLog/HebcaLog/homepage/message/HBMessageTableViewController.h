//
//  HBMessageTableViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HBMessageTableViewController : UITableViewController <MBProgressHUDDelegate>

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, assign) NSInteger type; //0-消息  1-日志

@end
