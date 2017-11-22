////
////  HBMessageViewController_Ori.h
////  HebcaLog
////
////  Created by 祁子栋 on 2017/11/21.
////  Copyright © 2017年 hebca. All rights reserved.
////
//
////
////  HBMessageViewController.h
////  HebcaLog
////
////  Created by 周超 on 15/3/17.
////  Copyright (c) 2015年 hebca. All rights reserved.
////
//
//#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"
//#import "HBMessageCell.h"
//#import "HBCommentBarView.h"
//#import "HBContactViewController.h"
//#import "HBDatepickerView.h"
//
//@interface HBMessageViewController : UIViewController <MBProgressHUDDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, HBCommentBarDelegate, HBMessageCellDelegate, HBContactSelectDelegate, HBDatepickerDelegate>
//
//@property (nonatomic, assign) NSInteger type;   //0-消息  1-日志  3-会议
//@property (nonatomic, assign) BOOL hasTeamAuth; //是否有团队日志权限
//@property (nonatomic, assign) BOOL isTeam;      //是否为团队日志
////@property (nonatomic, assign) BOOL needRefresh; //需要更新
//@property (nonatomic, copy) NSArray *authUserList; //有权限查看的用户列表
//@property (nonatomic, assign) BOOL loadLocalFlag;   //是否要读取本地数据
//@property (nonatomic, assign) BOOL loadServerFlag;  //是否要读取服务器数据
//@property (nonatomic, assign) BOOL needRefresh;
//
//@property (weak, nonatomic) IBOutlet UIView *dateView;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateViewHeight;
//
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityTopDistance;
//
//- (IBAction)configDate:(id)sender;
//
//@end
//
