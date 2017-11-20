//
//  HBTracksViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/9.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "HBContactViewController.h"
#import "HBDatepickerView.h"
#import "MBProgressHUD.h"

@interface HBTracksViewController : UIViewController <BMKMapViewDelegate, BMKRouteSearchDelegate, UIActionSheetDelegate, HBContactSelectDelegate, HBDatepickerDelegate, MBProgressHUDDelegate>

@property (nonatomic, copy) NSArray *authUserList;

@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet BMKMapView *baidumapView;

- (IBAction)dateChoose:(id)sender;

@end
