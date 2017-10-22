//
//  RBCustomDatePickerView.m
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import "RBCustomDatePickerView.h"

@interface RBCustomDatePickerView()
{
    UIView                      *timeBroadcastView;//定时播放显示视图
    MXSCycleScrollView          *yearScrollView;//年份滚动视图
    MXSCycleScrollView          *monthScrollView;//月份滚动视图
    MXSCycleScrollView          *dayScrollView;//日滚动视图
    MXSCycleScrollView          *hourScrollView;//时滚动视图
    MXSCycleScrollView          *minuteScrollView;//分滚动视图
    UILabel                     *nowPickerShowTimeLabel;//当前picker显示的时间
    UILabel                     *selectTimeIsNotLegalLabel;//所选时间是否合法
    CGSize viewSize;
}
@end

@implementation RBCustomDatePickerView

- (id)initWithDatePicker:(CGRect)baseFrame
{
    CGSize basesize = baseFrame.size;
    viewSize = CGSizeMake(basesize.width - 10, 240);
    self = [super initWithFrame:CGRectMake(5, 0, viewSize.width, viewSize.height)];
    if (self) {
        [self initDatePickerView];
        self.funcType = 0;
        self.maxDateRequered = NO;
        self.minDateRequered = NO;
        _selectedError = NO;
    }
    return self;
}

- (id)initWithTimePicker:(CGRect)baseFrame
{
    CGSize basesize = baseFrame.size;
    viewSize = CGSizeMake(basesize.width - 10, 240);
    self = [super initWithFrame:CGRectMake(5, 0, viewSize.width, viewSize.height)];
    if (self) {
        [self initTimePickerView];
        self.funcType = 1;
        self.maxDateRequered = NO;
        self.minDateRequered = NO;
    }
    return self;
}

#pragma mark -custompicker
- (void)initDatePickerView
{
    [self initCommonView];
    
    [nowPickerShowTimeLabel setTextAlignment:NSTextAlignmentCenter];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSString *weekString = [self fromDateToWeek:dateString];
    NSInteger monthInt = [dateString substringWithRange:NSMakeRange(5, 2)].integerValue;
    NSInteger dayInt = [dateString substringWithRange:NSMakeRange(8, 2)].integerValue;
    nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%@年%ld月%ld日 %@",[dateString substringWithRange:NSMakeRange(0, 4)],(long)monthInt,(long)dayInt,weekString];
    [self addSubview:nowPickerShowTimeLabel];
    
    //显示时间
    [self setYearScrollView];
    [self setMonthScrollView];
    [self setDayScrollView];
    
    //时间设置非法提示
    selectTimeIsNotLegalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 225, viewSize.width-10, 15)];
    [selectTimeIsNotLegalLabel setBackgroundColor:[UIColor clearColor]];
    [selectTimeIsNotLegalLabel setFont:[UIFont systemFontOfSize:12.0]];
    [selectTimeIsNotLegalLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:selectTimeIsNotLegalLabel];
    
    _selectedDate = [dateFormatter stringFromDate:now];
}

- (void)initTimePickerView
{
    [self initCommonView];
    
    nowPickerShowTimeLabel.text = @"设置时间";
    [self addSubview:nowPickerShowTimeLabel];
    
    [self setHourScrollView];
    [self setMinuteScrollView];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    _selectedTime = [dateFormatter stringFromDate:now];
}

- (void)initCommonView
{
    nowPickerShowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, viewSize.width-10, 18)];
    [nowPickerShowTimeLabel setBackgroundColor:[UIColor clearColor]];
    [nowPickerShowTimeLabel setFont:[UIFont systemFontOfSize:18.0]];
    [nowPickerShowTimeLabel setTextColor:RGBA(51, 51, 51, 1)];
    
    //timeBroadcastView
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(5, 32, viewSize.width-10, 190.0)];
    timeBroadcastView.layer.cornerRadius = 8;//设置视图圆角
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 2.0;
    [self addSubview:timeBroadcastView];
    
    UIView *beforeSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39, viewSize.width-10, 1.5)];
    [beforeSepLine setBackgroundColor:RGBA(237.0, 237.0, 237.0, 1.0)];
    [timeBroadcastView addSubview:beforeSepLine];
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, viewSize.width-10, 38)];
    [middleSepView setBackgroundColor:RGBA(249.0, 138.0, 20.0, 1.0)];
    [timeBroadcastView addSubview:middleSepView];
    UIView *bottomSepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 150.5, viewSize.width-10, 1.5)];
    [bottomSepLine setBackgroundColor:RGBA(237.0, 237.0, 237.0, 1.0)];
    [timeBroadcastView addSubview:bottomSepLine];
}

//设置年月日时分的滚动视图
- (void)setYearScrollView
{
    yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(60, 0, 73.0, 190.0)];
    NSInteger yearint = [self setNowTimeShow:0];
    [yearScrollView setCurrentSelectPage:(yearint-2002)];
    yearScrollView.delegate = self;
    yearScrollView.datasource = self;
    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:yearScrollView];
}
//设置年月日时分的滚动视图
- (void)setMonthScrollView
{
    monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(133.0, 0, 40.5, 190.0)];
    NSInteger monthint = [self setNowTimeShow:1];
    [monthScrollView setCurrentSelectPage:(monthint-3)];
    monthScrollView.delegate = self;
    monthScrollView.datasource = self;
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}
//设置年月日时分的滚动视图
- (void)setDayScrollView
{
    dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(173.5, 0, 46.0, 190.0)];
    NSInteger dayint = [self setNowTimeShow:2];
    [dayScrollView setCurrentSelectPage:(dayint-3)];
    dayScrollView.delegate = self;
    dayScrollView.datasource = self;
    [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:dayScrollView];
}
//设置年月日时分的滚动视图
- (void)setHourScrollView
{
    hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(100.0, 0, 39.0, 190.0)];
    NSInteger hourint = [self setNowTimeShow:3];
    [hourScrollView setCurrentSelectPage:(hourint-2)];
    hourScrollView.delegate = self;
    hourScrollView.datasource = self;
    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:hourScrollView];
}
//设置年月日时分的滚动视图
- (void)setMinuteScrollView
{
    minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(140.0, 0, 37.0, 190.0)];
    NSInteger minuteint = [self setNowTimeShow:4];
    [minuteScrollView setCurrentSelectPage:(minuteint-2)];
    minuteScrollView.delegate = self;
    minuteScrollView.datasource = self;
    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:minuteScrollView];
}


- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:14]];
    [oneLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:16]];
    [twoLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont systemFontOfSize:18]];
    [currentLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:16]];
    [threeLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:14]];
    [fourLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
}
#pragma mark mxccyclescrollview delegate
#pragma mark mxccyclescrollview databasesource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == yearScrollView) {
        return 99;
    }
    else if (scrollView == monthScrollView)
    {
        return 12;
    }
    else if (scrollView == dayScrollView)
    {
        return 31;
    }
    else if (scrollView == hourScrollView)
    {
        return 24;
    }
    else if (scrollView == minuteScrollView)
    {
        return 60;
    }
    return 60;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/5)];
    l.tag = index+1;
    if (scrollView == yearScrollView) {
        l.text = [NSString stringWithFormat:@"%d年",2000+index];
    }
    else if (scrollView == monthScrollView)
    {
        l.text = [NSString stringWithFormat:@"%d月",1+index];
    }
    else if (scrollView == dayScrollView)
    {
        l.text = [NSString stringWithFormat:@"%d日",1+index];
    }
    else if (scrollView == hourScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    else if (scrollView == minuteScrollView)
    {
        if (index < 10) {
            l.text = [NSString stringWithFormat:@"0%ld",(long)index];
        }
        else
            l.text = [NSString stringWithFormat:@"%ld",(long)index];
    }
    
    l.font = [UIFont systemFontOfSize:12];
    l.textAlignment = NSTextAlignmentCenter;
    l.backgroundColor = [UIColor clearColor];
    return l;
}
//设置现在时间
- (NSInteger)setNowTimeShow:(NSInteger)timeType
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    switch (timeType) {
        case 0:
        {
            NSRange range = NSMakeRange(0, 4);
            NSString *yearString = [dateString substringWithRange:range];
            return yearString.integerValue;
        }
            break;
        case 1:
        {
            NSRange range = NSMakeRange(4, 2);
            NSString *monthString = [dateString substringWithRange:range];
            return monthString.integerValue;
        }
            break;
        case 2:
        {
            NSRange range = NSMakeRange(6, 2);
            NSString *dayString = [dateString substringWithRange:range];
            return dayString.integerValue;
        }
            break;
        case 3:
        {
            NSRange range = NSMakeRange(8, 2);
            NSString *hourString = [dateString substringWithRange:range];
            return hourString.integerValue;
        }
            break;
        case 4:
        {
            NSRange range = NSMakeRange(10, 2);
            NSString *minuteString = [dateString substringWithRange:range];
            return minuteString.integerValue;
        }
            break;
        default:
            break;
    }
    return 0;
}
//选择设置的播报时间
/*
 - (void)selectSetBroadcastTime
 {
 UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
 UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
 UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
 UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
 UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
 
 NSInteger yearInt = yearLabel.tag + 1999;
 NSInteger monthInt = monthLabel.tag;
 NSInteger dayInt = dayLabel.tag;
 NSInteger hourInt = hourLabel.tag - 1;
 NSInteger minuteInt = minuteLabel.tag - 1;
 NSString *taskDateString = [NSString stringWithFormat:@"%d%02d%02d%02d%02d",yearInt,monthInt,dayInt,hourInt,minuteInt];
 NSLog(@"Now----%@",taskDateString);
 }
 */
//滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber
{
    if (self.funcType == 0) {
        UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        
        NSInteger yearInt = yearLabel.tag + 1999;
        NSInteger monthInt = monthLabel.tag;
        NSInteger dayInt = dayLabel.tag;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *selectDateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)yearInt,(long)monthInt,(long)dayInt];
        NSDate *selectDate = [dateFormatter dateFromString:selectDateString];
        NSDate *nowDate = [NSDate date];
        NSString *nowString = [dateFormatter stringFromDate:nowDate];
        NSDate *nowStrDate = [dateFormatter dateFromString:nowString];
        
        [selectTimeIsNotLegalLabel setTextColor:RGBA(155, 155, 155, 1)];
        if (self.minDateRequered  && NSOrderedAscending == [selectDate compare:nowStrDate]) {
            selectTimeIsNotLegalLabel.text = @"温馨提示：所选时间不能早于当前时间，请重新选择";
            _selectedError = YES;
            return;
        }
        else if (self.maxDateRequered &&  NSOrderedDescending == [selectDate compare:nowStrDate]) {
            selectTimeIsNotLegalLabel.text = @"温馨提示：所选时间不能晚于当前时间，请重新选择";
            _selectedError = YES;
            return;
        }
        
        NSString *dateString = [NSString stringWithFormat:@"%ld%02ld%02ld",(long)yearInt,(long)monthInt,(long)dayInt];
        NSString *weekString = [self fromDateToWeek:dateString];
        nowPickerShowTimeLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",(long)yearInt,(long)monthInt,(long)dayInt,weekString];
        
        _selectedError = NO;
        selectTimeIsNotLegalLabel.text = @"";
        
        _selectedDate = selectDateString;
    } else {
        UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        
        NSInteger hourInt = hourLabel.tag - 1;
        NSInteger minuteInt = minuteLabel.tag - 1;
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld", (long)hourInt,(long)minuteInt];
        
        _selectedTime = timeString;
    }
}

//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].integerValue;
    NSInteger c = 20;//世纪
    NSInteger y = yearInt -1;//年
    NSInteger d = dayInt;
    NSInteger m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}

@end
