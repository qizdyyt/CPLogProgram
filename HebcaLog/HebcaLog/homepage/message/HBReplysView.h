//
//  HBReplysView.h
//  HebcaLog
//
//  Created by 周超 on 15/3/18.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBServerInterface.h"

@interface HBReplysView : UIView

- (id)initWithReply:(NSArray *)replys;

- (id)initWithFrame:(CGRect)frame;
- (void)updateViewForReplys:(NSArray *)replys;
@end
