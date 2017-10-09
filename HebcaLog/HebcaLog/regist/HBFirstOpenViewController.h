//
//  HBFirstOpenViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBLocationService.h"
@interface HBFirstOpenViewController : UIViewController

@property(nonatomic,weak) UIWindow *window;

- (IBAction)receivedBtnPressed:(id)sender;
- (IBAction)unreceivePressed:(id)sender;


@end
