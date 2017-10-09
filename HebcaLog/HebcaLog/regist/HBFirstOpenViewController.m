//
//  HBFirstOpenViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBFirstOpenViewController.h"
#import "HBRegistViewController.h"
#import "HBAdminViewController.h"

@interface HBFirstOpenViewController ()

@end

@implementation HBFirstOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
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

- (IBAction)receivedBtnPressed:(id)sender {
    HBRegistViewController *registVC = [[HBRegistViewController alloc] init];
    [self presentViewController:registVC animated:YES completion:nil];
}

- (IBAction)unreceivePressed:(id)sender {
    HBAdminViewController *adminVC = [[HBAdminViewController alloc] init];
    adminVC.window = self.window;
    [self presentViewController:adminVC animated:YES completion:nil];
}
@end
