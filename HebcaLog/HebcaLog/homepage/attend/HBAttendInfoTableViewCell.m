//
//  HBAttendInfoTableViewCell.m
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBAttendInfoTableViewCell.h"
#import "HBCommonUtil.h"

@implementation HBAttendInfoTableViewCell

//注意：如果tableView没有上下框线的话  尝试使用 tabelview.layer.borderline 设置


- (void)awakeFromNib {
    // Initialization code
    /*
    self.attendLogTableView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.attendLogTableView.layer.borderWidth = 0.5;
    */
    if (SYSTEM_VERSION_HIGHER(8.0)) {
        self.tailSpace.constant = -16;
    }
    else {
        self.tailSpace.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
