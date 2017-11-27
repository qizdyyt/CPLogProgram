//
//  HBSettingViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/15.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBSettingViewController.h"
#import "HBPasswordViewController.h"
#import "HBAboutViewController.h"
#import "HBMLogLoginViewController.h"
#import "HBInviteUserViewController.h"
#import "HBServerInterface.h"
#import "HBCommonUtil.h"
#import "HBFileManager.h"
#import "ToastUIView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>

@interface HBSettingViewController ()

@end

@implementation HBSettingViewController
{
    NSString *userid;
    NSString *updateUrlStr;
    HBServerConnect *serverConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userid = [UserDefaultTool getUserId];
    
    [self configNavigationBar];
    [self.setTabelView setSeparatorInset:UIEdgeInsetsZero];
    
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        self.setTabelView.scrollEnabled = NO;
        self.setTabelView.rowHeight = 60.0;
    } else {
        self.setTabelView.scrollEnabled = YES;
        self.setTabelView.rowHeight = 48.0;
    }
    
    [self showUserHeadImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *userName = [UserDefaultTool getUserName];
    NSString *deptName = [UserDefaultTool getDeptName];
    
    self.userNameLabel.text = userName;
    self.divNameLabel.text = deptName;
    
    self.userHeadImg.layer.cornerRadius = 1.0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showUserHeadImage
{
    UIImage *image = [HBCommonUtil getUserHead:userid];
    if (image) {
        [self.userHeadImg setImage:image forState:UIControlStateNormal];
    }
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CertIdentifier = @"CellIdentifier";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CertIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"检测更新";
            break;
            
        case 1:
            cell.textLabel.text = @"更改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 2:
        {
            cell.textLabel.text = @"通知栏提醒";
            CGRect switchFrame = CGRectMake(260, 8, 51, 24);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:switchFrame];
            switchView.on = YES;
            [switchView addTarget:self action:@selector(setNotificationEnabled:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchView];
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"错误反馈";
            CGRect switchFrame = CGRectMake(260, 8, 51, 24);
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:switchFrame];
            switchView.on = YES;
            [switchView addTarget:self action:@selector(setBugReport:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:switchView];
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"邀请新用户";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"关于";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0: {
            [self checkVersionUpdate];
            
            break;
        }
        case 1: {
            HBPasswordViewController *passwordVC = [[HBPasswordViewController alloc] init];
            passwordVC.title = @"更改密码";
            passwordVC.setVC = self;
            [self.navigationController pushViewController:passwordVC animated:YES];
            break;
        }
        case 2:
        case 3:
            break;
        case 4:
        {
            HBInviteUserViewController *inviteVC = [[HBInviteUserViewController alloc] init];
            inviteVC.title = @"邀请用户";
            [self.navigationController pushViewController:inviteVC animated:YES];
            
            break;
        }
            
        case 5: {
            HBAboutViewController *aboutVC = [[HBAboutViewController alloc] init];
            aboutVC.title = @"关于";
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeHeadImg:(id)sender {
    
    NSArray *popViewOptions = [NSArray arrayWithObjects:@{@"text":@"照相机"}, @{@"text":@"本地相册"}, nil];
    
    HBPopListView *lplv = [[HBPopListView alloc] initWithTitle:@"请选择" options:popViewOptions];
    lplv.canCancelFlag = YES;
    lplv.delegate = self;
    
    [lplv showInView:self.view animated:YES];

}

- (IBAction)exitAccount:(id)sender {
    //上班状态 不能退出登录
//    if ([HBCommonUtil getAttendState:userid]) {
//        [self.view makeToast:@"您现在为上班状态，请打卡下班再退出登录"];
//        return;
//    }
    
    //更改登录状态
    [HBCommonUtil upDateUserLoginState:[UserDefaultTool getCertCN] state:NO];
    [UserDefaultTool recordUSerConfigToDefaults];
    
    //停止定位
    [g_mapManager stop];
    HBMLogLoginViewController *loginViewController = [[HBMLogLoginViewController alloc] init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loginViewController.window = appDelegate.window;
    appDelegate.window.rootViewController = loginViewController;
}

- (void)checkVersionUpdate {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"正在检测";
    [self.view addSubview:hud];
    
    __block HBUpdateInfo *update;
    [hud showAnimated:YES whileExecutingBlock:^{
        serverConnect = [[HBServerConnect alloc] init];
        
        NSString *currVersion = [HBCommonUtil getAppBuildVersion];
        
        update = [serverConnect checkUpdate:currVersion];
    }completionBlock:^{
        if (!update) {
            [HBCommonUtil showAttention:@"获取服务器信息失败，请检查网络连接状态" sender:self];
            return;
        }
        
        if (!update.isupdate) {
            [self.view makeToast:@"当前程序已经是最新版本"];
            return;
        }
        else {
            updateUrlStr = update.downloadurl;
            [self showUpdateAlert:update.updateDesc];
        }
        
    }];
}

- (IBAction)setNotificationEnabled:(id)sender {
}



- (IBAction)setBugReport:(id)sender {
    
}

- (void)passwordChanged
{
    [self.view makeToast:@"密码修改成功，请牢记您的新密码"];
}

- (void)showUpdateAlert:(NSString *)updateMsg
{
    NSString *message = [NSString stringWithFormat:@"发现新版本，是否现在升级？\n更新说明：\n%@", updateMsg];
    if (SYSTEM_VERSION_HIGHER(8.0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSURL *downloadUrl = [NSURL URLWithString:updateUrlStr];
            [[UIApplication sharedApplication]openURL:downloadUrl];
            
            [HBCommonUtil recordConfiguration];
            
            [self exitApplication];
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"升级提示"
                                                                      message:message
                                                                     delegate:self
                                                            cancelButtonTitle:@"以后再说"
                                                            otherButtonTitles:@"升级", nil];
        alertView.tag = 100;
        
        for( UIView * view in alertView.subviews )
        {
            if( [view isKindOfClass:[UILabel class]] )
            {
                UILabel* label = (UILabel*) view;
                
                label.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        [alertView show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 &&  buttonIndex == 1) {
        NSURL *downloadUrl = [NSURL URLWithString:updateUrlStr];
        //NSURL *downloadUrl = [NSURL URLWithString:@"itms-services://?action=download-manifest&amp;url=https://dn-hebca-kuaiban.qbox.me/kuaiban.plist"];
        [[UIApplication sharedApplication]openURL:downloadUrl];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for( UIView * view in alertView.subviews )
    {
        if( [view isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) view;
            
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark - LeveyPopListView delegates
- (void)myPopListView:(HBPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if (0 == anIndex) //照相机
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }else
        {
            [self.view makeToast:@"启动照相机失败"];
        }   
    }
    else //相册
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];;
    }
}

- (void)myPopListViewDidCancel
{
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //保存配置
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.userConfig.hasHeadImg = YES;
        [UserDefaultTool updateUserConfig:appDelegate.userConfig];
        
        //获取图片并压缩
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage *imageNew = [HBCommonUtil compressImage:image toLevel:2];
        NSData *imageData = UIImagePNGRepresentation(imageNew);
        
        
        //这里将图片保存为 -/Documents/heads/head.png
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString * headFolder = [DocumentsPath stringByAppendingPathComponent:@"/heads"];
        BOOL isDir = YES;
        NSError *error = nil;
        if (![fileManager fileExistsAtPath:headFolder isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:headFolder withIntermediateDirectories:YES attributes:nil error:&error];
        }
         
        NSString *imagePath = [headFolder stringByAppendingString:@"/head.png"];
        if ([fileManager fileExistsAtPath:imagePath]) {
            [fileManager removeItemAtPath:imagePath error:nil];
        }
        [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
        
        //上传头像
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        hud.labelText = @"正在设置，请稍后";
        [self.view addSubview:hud];
        
        __block NSString *errorMsg = nil;
        [hud showAnimated:YES whileExecutingBlock:^{
            errorMsg = [self uploadUserHeadImage:imagePath];
        }completionBlock:^{
            if (errorMsg) {
                [self.navigationController.view makeToast:errorMsg];
                return;
            }
            //设置页面头像
            [self.userHeadImg setImage:imageNew forState:UIControlStateNormal];
            
            [self.navigationController.view makeToast:@"设置成功"];
        }];
    }
}

- (NSString *)uploadUserHeadImage:(NSString *)imagePath
{
    if (IS_NULL_STRING(imagePath)) {
        return nil;
    }
    
    //上传头像 保存配置
    HBCustomConfig *config = [[HBCustomConfig alloc] init];
    serverConnect = [[HBServerConnect alloc] init];
    
    config.userid = userid;
    config.key    = @"head";
    config.value  = @"";
    config.attachment = imagePath;
    config.descript = @"用户头像";
    
    NSInteger result = [serverConnect uploadCustomConfig:config];
    if (result != HM_OK) {
        return [serverConnect getLastErrorMessage];
    }
    
    return nil;
}

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


@end
