//
//  HBContactTableViewCell.m
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBContactTableViewCell.h"
#import "HBCommonUtil.h"

@implementation HBContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.textColor  = [HBCommonUtil greenColor];
    self.phoneLabel.textColor = [UIColor orangeColor];
    self.checked = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

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
