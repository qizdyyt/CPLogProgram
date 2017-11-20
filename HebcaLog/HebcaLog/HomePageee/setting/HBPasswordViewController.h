//
//  HBPasswordViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/16.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBSettingViewController.h"

@interface HBPasswordViewController : UIViewController

@property (strong, nonatomic)HBSettingViewController *setVC;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *neewPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;

- (IBAction)backgroundTouched:(id)sender;

- (IBAction)changePassword:(id)sender;

@end
