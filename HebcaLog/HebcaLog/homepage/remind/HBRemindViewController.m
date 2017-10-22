//
//  HBRemindViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/10.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBRemindViewController.h"
#import "HBCommonUtil.h"
#import "HBRemindConfigViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ToastUIView.h"

#define BASE_TAG 12012

@implementation HBRemindInfo
@end


@implementation HBRemindViewController
{
    NSMutableArray *_remindRecords;
    NSInteger _remindCount;
    CGFloat _lastViewBottom; //保存上一个remindview的bottom纵坐标
    
    UIImageView *emptyRemindView;
    UIImageView *indicatorView;
    UILabel *emptyDescription;
    CGSize viewsize;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    [self addNavigatorButton];
    [self initEmptyViews];
    
    viewsize = [UIScreen mainScreen].bounds.size;
    
    self.scrollView.contentSize = CGSizeMake(viewsize.width, viewsize.height*4);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _lastViewBottom = 0;
    
    _remindRecords = [self getRemindRecordsFromDefault];
    _remindCount = [_remindRecords count];
    
    if (_remindCount == 0) {
        [self showEmptyDescription];    //提醒为空的时候，显示为空界面
        return;
    }
    [self dismissEmptyDescription];     //有提醒时，取消为空提示
    
    if (self.funType)
    {
        [self deleteOldItemView];
    }
    
    for (int i = 0; i < _remindCount; i++) {    //逐个添加remindItemView
        [self addSubViewWithRemindIndex:i];
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
     NSString *userid = [HBCommonUtil getUserId];
     
     UIApplication *app = [UIApplication sharedApplication];
     NSArray *localArray = [app scheduledLocalNotifications];
     
     if (localArray && [localArray count]) {
     for (UILocalNotification *noti in localArray) {
     NSDictionary *dict = noti.userInfo;
     if (dict && dict.count) {
     NSString *thisuserId = [dict objectForKey:@"userid"];
     
     if ([userid isEqual:thisuserId]) {
     [app cancelLocalNotification:noti];
     }
     }
     }
     }
     */
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)addNavigatorButton
{
    UIImage *image  = [UIImage imageNamed:@"btn_add"];
    UIButton *newButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [newButton setImage:image forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(newRemind) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *naviButton = [[UIBarButtonItem alloc] initWithCustomView:newButton];
    self.navigationItem.rightBarButtonItem = naviButton;
}

- (void)newRemind
{
    self.funType = 1;
    HBRemindConfigViewController *remindConfig = [[HBRemindConfigViewController alloc] init];
    remindConfig.title = @"设置提醒";
    remindConfig.funcType = 0;  //新建
    //remindConfig.remindViewControl = self;
    [self.navigationController pushViewController:remindConfig animated:YES];
}

//从userDefault里面读取notigication记录，构建remindInfo列表
- (NSMutableArray *)getRemindRecordsFromDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *notifyRecords = [defaults objectForKey:USER_DEFAULTS_REMIND_INFO];
    if (notifyRecords == nil || [notifyRecords count] == 0) {
        return nil;
    }
    
    NSString *certCN = [UserDefaultTool getCertCN];
    NSArray *userNotifyList = [notifyRecords objectForKey:certCN];
    if (userNotifyList == nil || [userNotifyList count] == 0) {
        return nil;
    }
    
    NSMutableArray *remindRecords = [[NSMutableArray alloc] init];
    NSMutableDictionary *repeatGroup = [[NSMutableDictionary alloc] init]; //记录多组 "remindId" = remindInfo对象 键值对
    
    for (NSDictionary *notifyInfo in userNotifyList)
    {
        NSString *notifyId = [notifyInfo objectForKey:@"id"];
        BOOL  repeated    = [[notifyInfo objectForKey:@"repeated"] boolValue];
        
        if (!repeated) { //不是重复提醒时，notifyId = remind.remindId;
            HBRemindInfo *remind = [[HBRemindInfo alloc] init];
            
            remind.remindId = notifyId;
            remind.time = [notifyInfo objectForKey:@"time"];
            remind.date = [notifyInfo objectForKey:@"date"];
            remind.content = [notifyInfo objectForKey:@"content"];
            remind.isRepeated = NO;
            
            [remindRecords addObject:remind];
        }//非重复提醒
        else { //重复提醒时，一个remind下包含多个notification，remindId = “notifyId&n” n取值0-6 表示周日到周六
            NSArray *dic = [notifyId componentsSeparatedByString:@"&"];
            NSString *remindId = [dic objectAtIndex:0];
            int week = [[dic objectAtIndex:1] intValue];
            
            HBRemindInfo *remind = [repeatGroup objectForKey:remindId];
            if (remind == nil) {
                remind = [[HBRemindInfo alloc] init];
                
                remind.remindId = remindId;
                remind.time =  [notifyInfo objectForKey:@"time"];
                remind.content = [notifyInfo objectForKey:@"content"];
                remind.isRepeated = YES;
            }
            
            NSMutableArray *weekdays = [remind.weekSelection mutableCopy];
            if (weekdays == nil) {
                weekdays = [[NSMutableArray alloc] init];
            }
            NSNumber *weekday  = [NSNumber numberWithInt:week];
            [(NSMutableArray *)weekdays addObject:weekday];
            remind.weekSelection = [weekdays mutableCopy];
            
            [repeatGroup setObject:remind forKey:remindId];
        }//重复提醒
        
    }//遍历userDefault中该用户的通知列表完毕
    if (repeatGroup && [repeatGroup count]) {
        [remindRecords addObjectsFromArray:[repeatGroup allValues]];
    }
    
    return remindRecords;
}

- (void)initEmptyViews
{
    CGSize emptyImgSize = CGSizeMake(120, 120);
    CGSize emptyDesSize = CGSizeMake(200, 24);
    CGSize indicatorSize = CGSizeMake(40, 60);
    
    CGRect viewFrame = [[UIScreen mainScreen] bounds];
    
    CGRect emptyImgFrame = CGRectMake(viewFrame.size.width/2 - emptyImgSize.width/2, viewFrame.size.height/2 - emptyImgSize.height/2 - 30, emptyImgSize.width, emptyImgSize.height);
    CGRect emptyDesFrame = CGRectMake(viewFrame.size.width/2 - emptyDesSize.width/2, emptyImgFrame.origin.y + emptyImgFrame.size.height + 20, emptyDesSize.width, emptyDesSize.height);
    CGRect indicatorFrame = CGRectMake(viewFrame.size.width - indicatorSize.width - 20, 10, indicatorSize.width, indicatorSize.height);
    
    UIImage *emptyImg = [UIImage imageNamed:@"emp_remind"];
    UIImage *indicatorImage = [UIImage imageNamed:@"emp_new"];
    
    emptyRemindView = [[UIImageView alloc] initWithFrame:emptyImgFrame];
    [emptyRemindView setImage:emptyImg];
    
    indicatorView = [[UIImageView alloc] initWithFrame:indicatorFrame];
    [indicatorView setImage:indicatorImage];
    
    emptyDescription = [[UILabel alloc] initWithFrame:emptyDesFrame];
    emptyDescription.text = @"点击+号，添加提醒";
    emptyDescription.textAlignment = NSTextAlignmentCenter;
    emptyDescription.font = [UIFont systemFontOfSize:19];
    emptyDescription.textColor = [UIColor lightGrayColor];
}

- (void)showEmptyDescription
{
    [self.scrollView addSubview:emptyRemindView];
    [self.scrollView addSubview:indicatorView];
    [self.scrollView addSubview:emptyDescription];
}

- (void)dismissEmptyDescription
{
    [emptyRemindView removeFromSuperview];
    [emptyDescription removeFromSuperview];
    [indicatorView removeFromSuperview];
}


- (void)addSubViewWithRemindIndex:(NSInteger)index
{
    HBRemindInfo *remind = [_remindRecords objectAtIndex:index];
    
    //提醒时间lable
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 100, 24)];
    timeLabel.textColor = [UIColor colorWithRed:20.0f/255.0 green:98.0f/255.0 blue:166.0f/255.0 alpha:1.0];
    timeLabel.font = [UIFont systemFontOfSize:20];
    timeLabel.text = remind.time;
    
    //提醒日期Label
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 36, 200, 20)];
    dateLabel.textColor = [HBCommonUtil greenColor];
    dateLabel.font = [UIFont systemFontOfSize:12];
    if (!remind.isRepeated) {
        dateLabel.text = remind.date;
    }
    else{
        NSArray *weekSelection = [remind.weekSelection copy];
        dateLabel.text = [self getWeekStringFromRemind:weekSelection];
    }
    
    //提醒内容Label
    UILabel *contentTextView = [[UILabel alloc] init];
    contentTextView.textColor = [UIColor darkTextColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.text = remind.content;
    contentTextView.numberOfLines = 0;
    contentTextView.userInteractionEnabled = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:contentTextView.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect labelFrame = [contentTextView.text boundingRectWithSize:CGSizeMake(300, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGSize labelsize = labelFrame.size;
    [contentTextView setFrame:CGRectMake(8, 60, labelsize.width, labelsize.height)];
    
    CGRect itemFrame = CGRectMake(8, _lastViewBottom+5, viewsize.width-16, 72 + labelsize.height);
    
    //添加删除按钮
    UIImage *image = [UIImage imageNamed:@"icon_delete"];
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(itemFrame.size.width-40, 26, 40, 40)];
    deleteBtn.tag = index;
    [deleteBtn setImage:image forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchDown];
    
    //添加control，实现点击view打开编辑视图
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, itemFrame.size.width, itemFrame.size.height)];
    control.backgroundColor = [UIColor clearColor];
    control.tag = index;
    [control addTarget:self action:@selector(configRemindItemIndex:) forControlEvents:UIControlEventTouchDown];
    
    //每个提醒的view
    UIView *remindItemView = [[UIView alloc]initWithFrame:itemFrame];
    remindItemView.tag = BASE_TAG +index;
    remindItemView.layer.borderWidth = 1.0;
    remindItemView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    remindItemView.layer.cornerRadius = 4.0;
    
    [remindItemView addSubview:timeLabel];
    [remindItemView addSubview:dateLabel];
    [remindItemView addSubview:contentTextView];
    [remindItemView addSubview:deleteBtn];
    [remindItemView addSubview:control];
    [remindItemView sendSubviewToBack:control];
    
    
    [self.scrollView addSubview:remindItemView];
    [self.scrollView sendSubviewToBack:remindItemView];
    
    _lastViewBottom = itemFrame.origin.y + itemFrame.size.height;
    
    //如果最后一个提醒框下边线超出了当前视图高度，则自动扩展scrollView的contentSize
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    self.scrollView.contentSize = CGSizeMake(viewSize.width, _lastViewBottom + 10);
}

- (NSString *)getWeekStringFromRemind:(NSArray *)weekSelection
{
    NSString *weekGroupStr = @" ";
    for (NSNumber *week in weekSelection) {
        switch ([week intValue]) {
            case 0:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周日  "];
                break;
            case 1:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周一  "];
                break;
            case 2:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周二  "];
                break;
            case 3:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周三  "];
                break;
            case 4:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周四  "];
                break;
            case 5:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周五  "];
                break;
            case 6:
                weekGroupStr = [weekGroupStr stringByAppendingString:@"周六  "];
                break;
                
            default:
                break;
        }
    }
    
    return weekGroupStr;
}

- (void)deleteOldItemView
{
    for (UIView *subView in self.scrollView.subviews)
    {
        if (subView.tag >= 1212) {
            [subView removeFromSuperview];
        }
    }
}


- (IBAction)configRemindItemIndex:(UIControl *)control
{
    self.funType = 2;
    NSInteger index = control.tag;
    
    HBRemindInfo *remind = [_remindRecords objectAtIndex:index];
    
    HBRemindConfigViewController *remindConfigVC = [[HBRemindConfigViewController alloc] init];
    remindConfigVC.remindInfo = remind;
    remindConfigVC.funcType = 1;
    remindConfigVC.title = @"设置提醒";
    //remindConfigVC.remindViewControl = self;
    [self.navigationController pushViewController:remindConfigVC animated:YES];
}

- (IBAction)deleteBtnPressed:(id)sender
{
    UIButton *deleteBtn = (UIButton *)sender;
    NSInteger index = deleteBtn.tag;
    
    //删除前 弹框确认
    if (!SYSTEM_VERSION_HIGHER(8.0)) { //ios7使用UIActionSheet，
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认要删除这条提醒吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = 100;
        [alertView show];
    }
    else     //ios8使用UIAlertView（Action样式）
    {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示"  message:@"您确认要删除这条提醒吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self deleteRemindItem:index];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertControl addAction:cancleAction];
        [alertControl addAction:okAction];
        
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 && buttonIndex == 1) {
        [self deleteRemindItem:buttonIndex];
    }
}

- (void)deleteRemindItem:(NSInteger)index
{
    HBRemindInfo *remind = [_remindRecords objectAtIndex:index];
    NSString *notifyID = nil;
    
    //取消本地推送 //删除默认配置里面的记录 列表里面的记录
    if (!remind.isRepeated) //非重复提醒
    {
        notifyID = remind.remindId;
        
        [self removeFromUserDefault:notifyID];
        [self removeLocalNotification:notifyID];
    }
    else {
        //构造notifyID
        for (NSNumber *number in remind.weekSelection) {
            NSString *notifyId = [remind.remindId stringByAppendingFormat:@"&%d", [number intValue]];
            
            [self removeFromUserDefault:notifyId];
            [self removeLocalNotification:notifyId];
        }
    }
    
    [_remindRecords removeObjectAtIndex:index];
    _remindCount = [_remindRecords count];
    
    _lastViewBottom = 0;
    
    //删除旧的
    for (UIView *view in [self.scrollView subviews])
    {
        [view removeFromSuperview];
    }
    
    
    if (_remindRecords.count == 0) {
        [self showEmptyDescription];    //提醒为空的时候，显示为空界面
    }
    else {
        for (int i = 0; i < _remindCount; i++) {    //逐个添加remindItemViews
            [self addSubViewWithRemindIndex:i];
        };
    }
}

- (void)removeFromUserDefault:(NSString *)notifyId
{
    NSString *certCN = [UserDefaultTool getCertCN];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *notifyRecords = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:USER_DEFAULTS_REMIND_INFO]];
    
    if (!notifyRecords || !notifyRecords.count) {
        return;
    }
    
    if (![[notifyRecords allKeys] containsObject:certCN]) {
        return;
    }
    
    NSMutableArray *userNotifyRecords = [[notifyRecords objectForKey:certCN] mutableCopy];
    
    NSArray *tempArray = [notifyRecords objectForKey:certCN];
    int count = [tempArray count];
    for (int i = 0; i < count; i++)
    {
        NSDictionary *remindItem = [tempArray objectAtIndex:i];
        
        if ([[remindItem objectForKey:@"id"] isEqualToString:notifyId])
        {
            [userNotifyRecords removeObjectAtIndex:i];
            [notifyRecords setObject:userNotifyRecords forKey:certCN];
            break;
        }
    }
    
    [defaults setObject:notifyRecords forKey:USER_DEFAULTS_REMIND_INFO];
    [defaults synchronize];
}

- (void)removeLocalNotification:(NSString *)notifyId
{
    NSString *userid = [UserDefaultTool getUserId];
    
    //获取本地推送数组
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *localArray = [app scheduledLocalNotifications];
    
    UILocalNotification *localNotification = nil;
    
    if (localArray && [localArray count]) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict && dict.count) {
                NSString *thisuserId = [dict objectForKey:@"userid"];
                NSString *thisnotifyId = [dict objectForKey:@"id"];
                
                
                if ([userid isEqual:thisuserId] && [notifyId isEqualToString:thisnotifyId]) {
                    localNotification = noti;
                    break;
                }
            }
        }
        
        //判断是否找到已经存在的相同key的推送
        if (localNotification) {
            //不推送 取消推送
            [app cancelLocalNotification:localNotification];
            return;
        }
    }
}

/*
- (void)configingFinshed:(NSString *)timeInterval
{
    NSString *messge = [NSString stringWithFormat:@"收到！您将在%@后收到提醒！", timeInterval];
    [self.view makeToast:messge];
}
 */


@end
