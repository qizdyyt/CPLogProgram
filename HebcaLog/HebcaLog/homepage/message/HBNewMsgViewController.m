//
//  HBNewMsgViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/2/28.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBNewMsgViewController.h"
#import "HBServerInterface.h"
#import "HBCommonUtil.h"
#import "ToastUIView.h"
#import "HBContactViewController.h"
#import "HBLocationService.h"

@interface HBNewMsgViewController ()

@end

@implementation HBNewMsgViewController
{
    HBLocation *_location;
    HBLocationService *locationService;
    NSString *_imagePath;
    NSString *_sendtoUsers;
    HBContactViewController *contactVC;
    HBServerConnect *serverConnect;
    BOOL imageSetted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    [self addOkbuttonToNavi];
    
    locationService = [HBLocationService locationService];
    locationService.lDelegate = self;
    
    serverConnect = [[HBServerConnect alloc] init];
    imageSetted = NO;
    
    //获取之前位置
    _location = nil;
    self.locationLabel.text = @"正在定位中，请稍后...";
    
    UIImage *image = [UIImage imageNamed:@"icon_locating"];
    [self.locationLogo setImage:image];
    
    //获取最新位置
    [locationService locateUserCurrentPosition];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (void)currentPositionLocated:(HBLocation *)location
{
    self.locationLabel.text = location.address;
    
    UIImage *image = [UIImage imageNamed:@"icon_located"];
    [self.locationLogo setImage:image];
    
    _location = location;
}



- (IBAction)backGroundTouched:(id)sender {
    [self.textContentView resignFirstResponder];
}

- (IBAction)addImageBtnPressed:(id)sender {
    [self.textContentView resignFirstResponder];
    
    NSArray *popViewOptions = [NSArray arrayWithObjects:@{@"text":@"照相机"}, @{@"text":@"本地相册"}, nil];
    
    HBPopListView *lplv = [[HBPopListView alloc] initWithTitle:@"请选择" options:popViewOptions];
    lplv.canCancelFlag = YES;
    lplv.delegate = self;
    
    [lplv showInView:self.view animated:YES];
}

-(void)addOkbuttonToNavi
{
    UIBarButtonItem *segButton = nil;
    UIImage *finishImage = [UIImage imageNamed:@"btn_accept"];
    UIButton *finishButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [finishButton setImage:finishImage forState:UIControlStateNormal];
    
    [finishButton addTarget:self action:@selector(finishBtnPressed) forControlEvents:UIControlEventTouchDown];
    
    segButton = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    self.navigationItem.rightBarButtonItem = segButton;
}

- (void)finishBtnPressed
{
    if (!imageSetted && (self.textContentView.text == nil || [self.textContentView.text length] == 0))
    {
        [self.textContentView resignFirstResponder];
        NSString *warnMsg = nil;
        if (0 == self.type) {
            warnMsg = @"消息内容不能为空";
        }
        else if (1 == self.type) {
            warnMsg = @"日志内容不能为空";
        }
        else if (2 == self.type) {
            warnMsg = @"会议内容不能为空";
        }
        
        [self.view makeToast:warnMsg];
        return;
    }
    
    if (!_location) {
        [self.view makeToast:@"正在定位您的当前位置，请稍后"];
        return;
    }
    
    [self.textContentView resignFirstResponder];
    
    //消息：新建消息点击完成按钮需要先打开联系人选择界面
    if (self.type == 0 || self.type == 2) {
        contactVC = [[HBContactViewController alloc] init];
        contactVC.title = @"通讯录";
        contactVC.funcType = 1; //联系人多选
        contactVC.selectDelegate = self;
        [self.navigationController pushViewController:contactVC animated:YES];
        return;
    }
    
    //日志：新建日志上传处理：
    [self sendNewJournal];
}


-(void)sendNewJournal
{
    //新建日志完成后直接返回日志列表界面
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"正在发送";
    [self.view addSubview:hud];
    __block NSInteger result;
    [hud showAnimated:YES whileExecutingBlock:^{
        NSString *longitude = _location.longitude;
        NSString *latitude  = _location.latitude;
        NSString *address   = _location.address;
        NSString *userId = [HBCommonUtil getUserId];
        NSString *userName = [HBCommonUtil getUserName];
        NSString *content = self.textContentView.text;
        
        HBJournalInfo *journal = [[HBJournalInfo alloc] init];
        journal.userid = userId;
        journal.userName = userName;
        journal.content = IS_NULL_STRING(content) ? @"这家伙很懒，除了图片什么也没留下！" : content;
        journal.image = _imagePath; //TODO
        journal.longitude = longitude;
        journal.latitude = latitude;
        journal.address = address;
        
        result = [serverConnect writeJournal:journal];
    }completionBlock:^{
        [hud removeFromSuperview];
        
        if (result != HM_OK) {
            [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
            return;
        }
        
        self.mesgVC.needRefresh = YES;
        self.mesgVC.loadLocalFlag = NO;
        self.mesgVC.loadServerFlag = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)getBackSelectContacts:(NSMutableArray *)contacts
{
    if (SYSTEM_VERSION_HIGHER(8.0)) {
        [contactVC popContactViewController];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    hud.labelText = @"正在发送";
    [self.view addSubview:hud];
    __block NSInteger result;
    [hud showAnimated:YES whileExecutingBlock:^{
        //获取联系人id列表
        NSMutableArray *receiversID = [[NSMutableArray alloc] init];
        for (HBContact *contact in contacts) {
            [receiversID addObject:contact.userid];
        }
        
        NSString *longitude = _location.latitude;
        NSString *latitude  = _location.latitude;
        NSString *address   = _location.address;
        NSString *userId = [HBCommonUtil getUserId];
        NSString *userName = [HBCommonUtil getUserName];
        NSString *content = self.textContentView.text;
        
        if (0 == self.type) {
            HBMessageInfo *message = [[HBMessageInfo alloc] init];
            message.userid = userId;
            message.username = userName;
            message.content = IS_NULL_STRING(content) ? @"这家伙很懒，除了图片什么也没留下！" : content;
            message.image = _imagePath;
            message.longitude = longitude;
            message.latitude = latitude;
            message.address = address;
            message.receivers = [receiversID componentsJoinedByString:@","];
            
            result = [serverConnect sendMsg:message];
        }
        else if (2 == self.type) {
            HBMeetingInfo *meeting = [[HBMeetingInfo alloc] init];
            meeting.userid = userId;
            meeting.username = userName;
            meeting.content = IS_NULL_STRING(content) ? @"这家伙很懒，除了图片什么也没留下！" : content;
            meeting.image = _imagePath;
            meeting.longitude = longitude;
            meeting.latitude  = latitude;
            meeting.address = address;
            meeting.receivers = [receiversID componentsJoinedByString:@","];
            
            result = [serverConnect createMeeting:meeting];
        }
        
    }completionBlock:^{
        [hud removeFromSuperview];
        
        if (result != HM_OK) {
            [HBCommonUtil showAttention:[serverConnect getLastErrorMessage] sender:self];
            return;
        }
               
        self.mesgVC.needRefresh = YES;
        self.mesgVC.loadLocalFlag = NO;
        self.mesgVC.loadServerFlag = YES;
        
        [self.navigationController popToViewController:self.mesgVC animated:YES];
    }];
}

#pragma mark - LeveyPopListView delegates
- (void)myPopListView:(HBPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    if (0 == anIndex)
    {
        [self openCamera];
    }
    else
    {
        [self openLocalPhoto];
    }
}

- (void)myPopListViewDidCancel
{
}

- (void)openCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [self.view makeToast:@"启动照相机失败"];
    }
}

- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *imageNew = [HBCommonUtil compressImage:image toLevel:1]; 
        
        NSData *imageData = UIImagePNGRepresentation(imageNew);
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imageData attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        _imagePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        [self displayImage:imageNew];
        
        imageSetted = YES;
    }
}

- (void)displayImage:(UIImage *)image
{
    [self.addImageBtn setImage:image forState:UIControlStateNormal];
    
    CGRect textFrame = self.textContentView.frame;
    CGRect btnFrame = CGRectMake(0, 0, 100, 100);
    CGFloat btnWidth  = btnFrame.size.width * 2;
    
    CGSize imgSize = image.size;
    CGFloat imgWidth  = imgSize.width;
    CGFloat imgHeight = imgSize.height;
    
    btnFrame.size.width  = btnWidth;
    btnFrame.size.height = btnWidth * imgHeight / imgWidth;
    btnFrame.origin.x = textFrame.origin.x;
    btnFrame.origin.y = textFrame.origin.y + textFrame.size.height + textFrame.origin.x;
    
    UIButton *imgButton = [[UIButton alloc] initWithFrame:btnFrame];
    [imgButton setImage:image forState:UIControlStateNormal];
    
    [imgButton addTarget:self action:@selector(addImageBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:imgButton];
    
    self.addImageBtn.hidden = YES;
}

- (void)backButtonPressed
{
    self.mesgVC.loadLocalFlag = NO;
    self.mesgVC.loadServerFlag = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
