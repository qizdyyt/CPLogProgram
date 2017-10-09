//
//  HBContactSelectCell.m
//  HebcaLog
//
//  Created by 周超 on 15/3/22.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBContactSelectCell.h"

@implementation HBContactSelectCell

- (void)awakeFromNib {
    // Initialization code
    self.checked = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)checkBtnPressed:(id)sender {
    UIImage *uncheckImage = [UIImage imageNamed:@"list_checkbox"];
    UIImage *checkedImage = [UIImage imageNamed:@"list_checkbox_selected"];
    
    if (self.checked == NO) {
        [self.checkBtn setImage:checkedImage forState:UIControlStateNormal];
        self.checked = YES;
    }
    else {
        [self.checkBtn setImage:uncheckImage forState:UIControlStateNormal];
        self.checked = NO;
    }
}

@end
