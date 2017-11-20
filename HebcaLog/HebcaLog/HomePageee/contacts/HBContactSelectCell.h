//
//  HBContactSelectCell.h
//  HebcaLog
//
//  Created by 周超 on 15/3/22.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBContactSelectCell : UITableViewCell

@property (nonatomic, assign) BOOL checked;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

- (IBAction)checkBtnPressed:(id)sender;

@end
