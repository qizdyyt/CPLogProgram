//
//  HBDatepickerView.m
//  HebcaLog
//
//  Created by 周超 on 15/4/13.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBDatepickerView.h"
#import "ToastUIView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HBDatepickerView
{
    RBCustomDatePickerView *rbDatePickerView;
    NSInteger funcType;
    CGRect viewFrame;
    UIViewController *baseViewController;
}


- (id)initDatePickerView
{
    self = [super init];
    if (self) {
        [self initBaseView];
        
        funcType = HBDatePickType;
        rbDatePickerView = [[RBCustomDatePickerView alloc] initWithDatePicker:viewFrame];
        rbDatePickerView.funcType = HBDatePickType;
        
        [self addSubview:rbDatePickerView];
    }
    
    return self;
}

- (id)initTimePickerView
{
    self = [super init];
    if (self) {
        [self initBaseView];
        
        funcType = HBTimePickType;
        rbDatePickerView = [[RBCustomDatePickerView alloc] initWithTimePicker:viewFrame];
        rbDatePickerView.funcType = HBTimePickType;
        [self addSubview:rbDatePickerView];
    }
    
    return self;
}

- (void)initBaseView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    viewFrame = CGRectMake(8, 70, screenSize.width-16, 280);
    self.frame = viewFrame;
    
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 4;
    //底部阴影效果
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4, 6);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 6;
    
    //ok按钮
    CGRect btnFrame = CGRectMake(viewFrame.size.width/2-25, viewFrame.size.height-35, 50, 30);
    UIButton *okButton = [[UIButton alloc] initWithFrame:btnFrame];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    [okButton setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:okButton];
    
    //透明背景  点击背景picker消失
    /*
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(-8, -70, screenSize.width, screenSize.height)];
    control.backgroundColor = RGBA(0, 0, 0, 0.5);
    [control addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchDown];
    [self addSubview:control];
    [self sendSubviewToBack:control];
     */
}

- (void)showPickerView:(id)sender
{
    rbDatePickerView.minDateRequered = self.minDateRequered;
    rbDatePickerView.maxDateRequered = self.maxDateRequered;

    baseViewController = (UIViewController *)sender;
    [baseViewController.view addSubview:self];
}

- (void)dismissView
{
    [self removeFromSuperview];
}

- (void)okButtonPressed
{
    if (rbDatePickerView.selectedError == NO) {
        NSString *settedDate = nil;
        if (funcType == HBDatePickType) {
            settedDate = rbDatePickerView.selectedDate;
            [self.pDelegate getBackSettedDate:settedDate];
        } else {
            settedDate = rbDatePickerView.selectedTime;
            [self.pDelegate getBackSettedTime:settedDate];
        }
        
        [self removeFromSuperview];
    }
    else {
        if (self.minDateRequered) {
            [baseViewController.view makeToast:@"所选日期不能早于当前日期"];
        }
        else if (self.maxDateRequered) {
            [baseViewController.view makeToast:@"所选日期不能晚于当前日期"];
        }
    }
}

@end
