//
//  RBCustomDatePickerView.h
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSCycleScrollView.h"

@interface RBCustomDatePickerView : UIView <MXSCycleScrollViewDatasource,MXSCycleScrollViewDelegate>

@property (nonatomic, assign) BOOL maxDateRequered;
@property (nonatomic, assign) BOOL minDateRequered;
@property (nonatomic, assign) NSInteger funcType;   //0：datepicker  1：timepicker
@property (nonatomic, copy) NSString *taskDateString;
@property (nonatomic, copy) NSString *selectedDate; //设置的日期
@property (nonatomic, copy) NSString *selectedTime; //设置的时间
@property (nonatomic, assign) BOOL   selectedError; //设置错误

- (id)initWithDatePicker:(CGRect)baseFrame;
- (id)initWithTimePicker:(CGRect)baseFrame;

@end

