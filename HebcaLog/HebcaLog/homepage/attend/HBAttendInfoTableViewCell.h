//
//  HBAttendInfoTableViewCell.h
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBAttendInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *attendDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *worktimeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tailSpace;

@end
