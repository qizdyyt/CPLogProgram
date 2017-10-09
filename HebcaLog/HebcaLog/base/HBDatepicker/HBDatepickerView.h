//
//  HBDatepickerView.h
//  HebcaLog
//
//  Created by 周超 on 15/4/13.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBCustomDatePickerView.h"

enum HBDatePickerFuncType
{
    HBDatePickType = 0,
    HBTimePickType = 1
};


@protocol HBDatepickerDelegate <NSObject>

@optional

- (void)getBackSettedDate:(NSString *)settedDateStr;
- (void)getBackSettedTime:(NSString *)settedTimeStr;

@end


@interface HBDatepickerView : UIView

@property (nonatomic, weak)id <HBDatepickerDelegate> pDelegate;
@property (nonatomic, assign) BOOL maxDateRequered;
@property (nonatomic, assign) BOOL minDateRequered;

- (id)initDatePickerView;
- (id)initTimePickerView;

- (void)showPickerView:(id)sender;
- (void)dismissView;

@end
