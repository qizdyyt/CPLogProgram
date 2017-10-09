//
//  HBTracksViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/9.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBTracksViewController.h"
#import "HBCommonUtil.h"
#import "HBServerInterface.h"
#import "HBMiddleWare.h"
#import "ToastUIView.h"
#import "HBAuthorityUtil.h"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface HBTracksViewController ()

@end

@implementation HBTracksViewController
{
    HBServerConnect *_serverConnect;
    NSString *_setDate;
    NSArray *_positionArr;
    BMKLocationViewDisplayParam* _testParam;
    BMKMapView *_mapView;
    BMKRouteSearch *_searcher;
    NSString *_userName;
    NSString *_userid;
    NSString *_settedUser;
    NSMutableArray *_track;
    NSInteger _searchCount;
    
    UIDatePicker *_datePicker;
    UIActionSheet *_actionSheet;
    UIAlertController *_alertControl;
    
    HBContactViewController *_contactVC;
    HBContact *_selectContact;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    
    //百度地图初始化
    _mapView = self.baidumapView;
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 13;
    _mapView.showsUserLocation = NO;    //先关闭显示的定位图层
    _mapView.showsUserLocation = YES;   //显示定位图层
    
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    
    _searcher = [[BMKRouteSearch alloc] init];
    _searcher.delegate = self;
    
    _serverConnect = [[HBServerConnect alloc] init];
    _setDate = [HBCommonUtil getDateWithYMD:[NSDate date]];
    _userid  = [HBCommonUtil getUserId];
    _userName = [HBCommonUtil getUserName];
    _settedUser = _userid;
    self.dateLabel.text = [HBCommonUtil getDateWithWeek:[NSDate date]];
    
    
    //如果有权限查看其他人员的轨迹，在右上角增加按钮
    HB_AUTHOR_STATUS status = [HBAuthorityUtil getTeamAuthority:HB_LOCATION];
    if (status == HB_AUTHORIZED) {
        UIImage *image = [UIImage imageNamed:@"btn_person"];
        UIButton *contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        [contactBtn setImage:image forState:UIControlStateNormal];
        [contactBtn addTarget:self action:@selector(openContactChooseView) forControlEvents:UIControlEventTouchDown];
        
        UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc] initWithCustomView:contactBtn];
        self.navigationItem.rightBarButtonItem = naviBtn;
    }
    
    _searchCount = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
}


- (void)openContactChooseView
{
    _contactVC = [[HBContactViewController alloc] init];
    _contactVC.selectDelegate = self;
    _contactVC.funcType = 2; //打开联系人单选界面
    _contactVC.authUserIds = _authUserList;
    
    [self.navigationController pushViewController:_contactVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - baiduMapDelegate


- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    //最近一次上传的地理位置，作为地图显示中心
    NSString *latitude = nil;
    NSString *longitude = nil;
    //NSString *time = nil;
    NSString *userId  = [NSString stringWithFormat:@"%@", [HBCommonUtil getUserId]];
    NSArray *requestUsers = [NSArray arrayWithObject:userId];
    NSMutableArray *positions = [_serverConnect getPositions:userId requestUsers:requestUsers];
    if ([positions count] == 0) {
        //获取上传位置失败，则使用当前位置
        HBLocation *location = [HBCommonUtil getUserLocation];
        latitude  = location.latitude;
        longitude = location.longitude;
        //time = [HBCommonUtil getTimeHHmm:[NSDate date]];
    }else {
        HBPosition *position = [positions objectAtIndex:0];
        if ([userId intValue] == [position.userid intValue]) {
            latitude = position.latitude;
            longitude = position.longitude;
            //time = position.time;
        }
    }
    
    CLLocationCoordinate2D coordinate = {[latitude floatValue], [longitude floatValue]};
    _mapView.centerCoordinate = coordinate;
    
    [self refreshUserTrack];
}

- (void)getBackSingleSelect:(HBContact *)contact
{
    [_contactVC popContactViewController];
    
    _selectContact = contact;
    _settedUser = _selectContact.userid;
    
    _userName = [_selectContact.userid isEqual:[HBCommonUtil getUserId]] ? @"我" : _selectContact.username;
    
    self.title = [NSString stringWithFormat:@"%@的轨迹", _userName];
    
    [self refreshUserTrack];
}

- (IBAction)dateChoose:(id)sender {
    HBDatepickerView *datepicerView = [[HBDatepickerView alloc] initDatePickerView];
    datepicerView.pDelegate = self;
    datepicerView.maxDateRequered = YES;
    [datepicerView showPickerView:self];
}


- (void)getBackSettedDate:(NSString *)settedDateStr
{
    _setDate = settedDateStr;
    self.dateLabel.text = [HBCommonUtil translateDate:_setDate toCN:YES];
    
    [self refreshUserTrack];
}

- (void)refreshUserTrack
{
    //清除原有标注点及轨迹
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    
    [self.view addSubview:hud];
    [hud showAnimated:YES whileExecutingBlock:^{
        _track = [_serverConnect getTrack:_userid requstUser:_settedUser date:_setDate];
    }completionBlock:^{
        NSUInteger  count = [_track count];
        if (count <= 1) {
            [self.view makeToast:@"获取用户轨迹失败"];
            return;
        }
        
        HBPosition *firstPosition = [_track objectAtIndex:0];
        CLLocationCoordinate2D firstCoordinate  = {[firstPosition.latitude doubleValue],  [firstPosition.longitude doubleValue]};
        
        NSString *timeStr = firstPosition.time;
        NSString *date = [[timeStr componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *time = [[timeStr componentsSeparatedByString:@" "] objectAtIndex:1];
        
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        item.coordinate = firstCoordinate;
        item.title = date;
        item.subtitle = time;
        item.type = 0;
        [_mapView addAnnotation:item];
        [_mapView selectAnnotation:item animated:YES];
        
        if (count < 2) return;
        
        for (int i = 1; i < count; i++) {
            _searchCount = i;
            HBPosition *prevPosition = [_track objectAtIndex:i-1];
            HBPosition *currPosition = [_track objectAtIndex:i];
            
            CLLocationCoordinate2D prevCoordinate  = {[prevPosition.latitude doubleValue],  [firstPosition.longitude doubleValue]};
            CLLocationCoordinate2D currCoordinate = {[currPosition.latitude doubleValue], [currPosition.longitude doubleValue]};
            
            //距上一位置点太近，则不重新创建位置点，不计算路径 0.001 《===》 88米
            if ([prevPosition.latitude doubleValue] - [currPosition.latitude doubleValue] <= 0.002 &&
                [prevPosition.longitude doubleValue] - [currPosition.longitude doubleValue] <= 0.002)
            {
                //合并时间
                NSArray *annotArr = [_mapView annotations];
                RouteAnnotation *lastAnnot = [annotArr lastObject];
                NSString *lastTime = lastAnnot.subtitle;
                NSString *currTime = [[currPosition.time componentsSeparatedByString:@" "] objectAtIndex:1];
                NSString *combinedTime = [self combineTimeA:lastTime TimeB:currTime];
                
                lastAnnot.subtitle = combinedTime;
                
                continue;
            }
            
            //显示新位置点
            NSString *timeStr = currPosition.time;
            NSString *date = [[timeStr componentsSeparatedByString:@" "] objectAtIndex:0];
            NSString *time = [[timeStr componentsSeparatedByString:@" "] objectAtIndex:1];
            
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = currCoordinate;
            item.title = date;
            item.subtitle = time;
            item.type = 5;
            [_mapView addAnnotation:item];
            [_mapView selectAnnotation:item animated:YES];
            
            //计算路径
            BMKPlanNode *first  = [[BMKPlanNode alloc] init];
            BMKPlanNode *second = [[BMKPlanNode alloc] init];
            first.pt = prevCoordinate;
            second.pt = currCoordinate;
            
            BMKWalkingRoutePlanOption *walkRouteSearchOption = [[BMKWalkingRoutePlanOption alloc] init];
            walkRouteSearchOption.from = first;
            walkRouteSearchOption.to   = second;
            
            BOOL flag = [_searcher walkingSearch:walkRouteSearchOption];
            if (!flag) NSLog(@"%d路线检索失败", i);
        }
    }];
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (BMK_SEARCH_NO_ERROR == error) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        int routeCount = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < routeCount; i++)
        {
            BMKWalkingStep *walkStep = [plan.steps objectAtIndex:i];
            //HBPosition *position = [_track objectAtIndex:_searchCount];
            /*
            if (i == 0) {
                RouteAnnotation *item = [[RouteAnnotation alloc] init];
                item.coordinate = plan.starting.location;
                item.title = position.username;
                item.subtitle = position.time;
                item.type = 0;
                [_mapView addAnnotation:item];
            }
            else if(i == routeCount-1){
                if (_searchCount == [_track count]-2 ) { //只为获取到的最后一个位置点添加标注（因为之前的每个结束点都是起点，这样可以避免重复创建注释A）
                    RouteAnnotation* item = [[RouteAnnotation alloc]init];
                    item.coordinate = plan.terminal.location;
                    item.title = position.username;
                    item.subtitle = position.time;
                    item.type = 1;
                    [_mapView addAnnotation:item]; // 添加终点标注
                }
            }
             */
            //添加annotation节点
            /*
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = walkStep.entrace.location;
            item.title = position.username;
            item.subtitle = position.time;
            item.degree = walkStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            */
            //轨迹点总数累计
            planPointCounts += walkStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < routeCount; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
    }
}


- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKAnnotationView *annotView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"walk"];
    annotView.image = [UIImage imageNamed:@"marker"];
    annotView.centerOffset = CGPointMake(0, -(annotView.frame.size.height * 0.5));
    annotView.canShowCallout = TRUE;
    annotView.annotation = annotation;
				
    return annotView;
}

- (NSString *)combineTimeA:(NSString *)timestrA TimeB:(NSString *)timestrB
{
    /*
     * timestrA的时间格式 “9:20” 或 “9:20-14:46”
     */
    NSString *timeA = timestrA;
    NSString *timeB = timestrB;
    
    //如果timeA已经是复合时间，则取其中较早的时间
    NSRange range = [timeA rangeOfString:@"-"];
    if (range.length){
        NSArray *array = [timeA componentsSeparatedByString:@"-"];
        timeA = [array objectAtIndex:0];
    }
    
    NSString *combinedTime = combinedTime = [NSString stringWithFormat:@"%@-%@", timeA, timeB];
    
    return combinedTime;
}
@end
