//
//  HBContactTableViewCell.h
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBContactTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;     //是否为选中状态

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)checkBtnPressed:(id)sender;

@end
