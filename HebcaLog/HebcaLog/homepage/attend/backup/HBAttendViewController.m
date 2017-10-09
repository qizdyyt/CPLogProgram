//
//  HBAttendViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/28.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBAttendViewController.h"
#import "HBAttendActViewController.h"
#import "HBAttendInfoTableViewController.h"

@interface HBAttendViewController ()

@end

@implementation HBAttendViewController
{
    UIButton *_attendActBtn;
    UIButton *_attendInfoBtn;
    
    HBAttendActViewController *attendActView;
    HBAttendInfoTableViewController *attendInfoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    attendActView = [[HBAttendActViewController alloc] init];
    attendActView.title = @"考勤打卡";
    
    attendInfoView = [[HBAttendInfoTableViewController alloc] init];
    attendInfoView.title = @"考勤查询";
    
    self.viewControllers = [NSArray arrayWithObjects:attendActView, attendInfoView, nil];
    
    
    /*
    //定制自定义的tabbar
    CGRect viewFrame = self.view.frame;
    CGRect tabbarFrame = CGRectMake(0, viewFrame.size.height-40, viewFrame.size.width, 40);
    UIView *attendTabbar = [[UIView alloc] initWithFrame:tabbarFrame];
    
    _attendActBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tabbarFrame.size.width/2, 40)];
    _attendActBtn.titleLabel.text = @"考勤打卡";
    [_attendActBtn addTarget:self action:@selector(showAttendActView) forControlEvents:UIControlEventTouchUpInside];
    
    _attendInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(attendTabbar.frame.size.width/2, 0, attendTabbar.frame.size.width/2, attendTabbar.frame.size.height)];
    _attendActBtn.titleLabel.text = @"考勤查询";
    [_attendInfoBtn addTarget:self action:@selector(showAttendInfoView) forControlEvents:UIControlEventTouchUpInside];
    
    [attendTabbar addSubview:_attendActBtn];
    [attendTabbar addSubview:_attendInfoBtn];
    attendTabbar.userInteractionEnabled = YES;
    
    self.tabBar.hidden = YES;
    [self.view addSubview:attendTabbar];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
