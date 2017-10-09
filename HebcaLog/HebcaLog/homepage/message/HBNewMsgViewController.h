//
//  HBNewMsgViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/2/28.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPopListView.h"
#import "HBContactViewController.h"
#import "HBMessageViewController.h"
#import "HBLocationService.h"
#import "MBProgressHUD.h"

@interface HBNewMsgViewController : UIViewController <HBPopListViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HBContactSelectDelegate, HBLocationServiceDelegate, MBProgressHUDDelegate>
@property (nonatomic, assign)NSInteger type; //0-新建消息  1-新建日志  2-新建会议

@property (weak, nonatomic) IBOutlet UIImageView *locationLogo;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *textContentView;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (strong, nonatomic)HBMessageViewController* mesgVC;

- (IBAction)backGroundTouched:(id)sender;
- (IBAction)addImageBtnPressed:(id)sender;

@end
