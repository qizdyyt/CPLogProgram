//
//  HBReplyCell.h
//  HebcaLog
//
//  Created by 周超 on 15/2/28.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBReplyCell : UITableViewCell
@property (nonatomic, assign)NSInteger msgIndex;
@property (nonatomic, assign)NSInteger rplIndex;

@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *replyContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightCS;

@end
