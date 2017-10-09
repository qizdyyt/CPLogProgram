//
//  HBContactInfoCell.h
//  HebcaLog
//
//  Created by 周超 on 15/3/6.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBServerInterface.h"

@interface HBContactInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;        //手机号码label
@property (weak, nonatomic) IBOutlet UILabel *telephoneNumLabel;    //座机号码label
- (IBAction)callPhone:(id)sender;

- (void)setupLayoutWithContact: (HBContact *)contact;

@end
