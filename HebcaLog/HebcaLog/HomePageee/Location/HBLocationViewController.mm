//
//  HBLocationViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBLocationViewController.h"
#import "BMapKit.h"
#import "HBCommonUtil.h"
#import "HBTracksViewController.h"
#import "HBServerInterface.h"
#import "ToastUIView.h"
#import "HBAuthorityUtil.h"

@interface HBLocationViewController ()

@end

@implementation HBLocationViewController
{
    BMKLocationService* _locService;
    BMKLocationViewDisplayParam* _testParam;
    BMKGeoCodeSearch *_geocodesearch;
    
    HBContactViewController *contactVC;
    NSArray *_authUserList;
    
    HBServerConnect *serverConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBar];
    [self addTrackButton];
    [self initSearchBar];
    
    _mapView.showMapScaleBar = YES;
    _mapView.zoomLevel = 13;
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.delegate = self;
    
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    serverConnect = [[HBServerConnect alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    HBLocation *location = [HBCommonUtil getUserLocation];
    NSString *longitude = location.longitude;
    NSString *latitude  = location.latitude;
    CLLocationCoordinate2D coordinate = {[latitude floatValue], [longitude floatValue]};
    _mapView.centerCoordinate = coordinate;
    
    [_locService startUserLocationService];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _geocodesearch.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.15, 0.15));
    BMKCoordinateRegion adjustRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustRegion animated:YES];
    
    [_mapView updateLocationData:userLocation];
    
    [self updateUserLocation:coordinate];
}

- (void)updateUserLocation:(CLLocationCoordinate2D)coordinate
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(!flag)
    {
        NSLog(@"反geo检索发送失败");
    }
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (0 == error) {
        CLLocationCoordinate2D coordinate = result.location;
        NSString *latitude  = [NSString stringWithFormat:@"%lf", coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%lf", coordinate.longitude];
        
        NSString *address = result.address;
        
        HBLocation *location = [[HBLocation alloc] init];
        location.latitude = latitude;
        location.longitude = longitude;
        location.address   = address;
        [HBCommonUtil updateLocation:location];
    }
}

- (void)addTrackButton
{
    UIBarButtonItem *naviButton = nil;
    
    UIImage *trackImage  = [UIImage imageNamed:@"btn_track"];
    UIButton *trackButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    [trackButton setImage:trackImage forState:UIControlStateNormal];
    
    [trackButton addTarget:self action:@selector(openTrackRecordsView) forControlEvents:UIControlEventTouchDown];
    
    naviButton = [[UIBarButtonItem alloc] initWithCustomView:trackButton];
    
    self.navigationItem.rightBarButtonItem = naviButton;
}

- (void)openTrackRecordsView
{
    HBTracksViewController *tracksVC = [[HBTracksViewController alloc] init];
    tracksVC.title = @"我的轨迹";
    tracksVC.authUserList = _authUserList;
    [self.navigationController pushViewController:tracksVC animated:YES];
}


- (void)initSearchBar
{
    HB_AUTHOR_STATUS status = [HBAuthorityUtil getTeamAuthority:HB_LOCATION];
    if (status == HB_AUTHORIZED) {
        [self.searchBar setBackgroundImage:[UIImage new]];
        self.searchBar.hidden = NO;
        return;
    }
    
    self.searchBar.hidden = YES;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    contactVC = [[HBContactViewController alloc] init];
    contactVC.funcType = 1;
    contactVC.selectDelegate = self;
    contactVC.authUserIds = _authUserList;
    
    [self.navigationController pushViewController:contactVC animated:YES];
    
    return NO;
}


- (void)getBackSelectContacts:(NSMutableArray *)contacts
{
    [contactVC popContactViewController];
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    NSMutableArray *getUserIds = [[NSMutableArray alloc] init];
    
    for (HBContact *contact in contacts) {
        NSString *userId = [NSString stringWithFormat:@"%ld", (long)[contact.userid integerValue]];
        
        [getUserIds addObject:userId];
    }
    
    NSMutableArray *userPositions = [serverConnect getPositions:[UserDefaultTool getUserId] requestUsers:[getUserIds copy]];
    if (!userPositions || ![userPositions count]) {
        [self.view makeToast:@"获取用户位置失败"];
        return;
    }
    
    //清除之前位置信息
    [_mapView removeAnnotations:_mapView.annotations];
    
    for (int i = 0; i < [userPositions count]; i++) {
        HBPosition *position = [userPositions objectAtIndex:i];
        if (position == nil || position.username == nil || position.username.length == 0) {
            return;
        }
        
        CLLocationCoordinate2D coordinate = {[position.latitude floatValue], [position.longitude floatValue]};
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = coordinate;
        HBContact *contact = [contacts objectAtIndex:i];
        annotation.title = contact.username;    //TODO:改为使用用户id查找用户名
        annotation.subtitle = position.time;
        
        [_mapView addAnnotation:annotation];
        [_mapView selectAnnotation:annotation animated:YES];
    }
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

@end
