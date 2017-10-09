//
//  HBLocationService.m
//  HebcaLog
//
//  Created by 周超 on 15/4/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBLocationService.h"
#import "HBServerInterface.h"
#import "AppDelegate.h"

@implementation HBLocationService
{
    BOOL attendIn;     //上班状态 根据上班状态判断是否继续定位
    BOOL requireReply; //需要返回位置
    
    HBServerConnect *_serverConnect;
    BMKGeoCodeSearch *_geocodesearch;
    BMKLocationService *_locService;
}


- (id)init
{
    self = [super init];
    if (self) {
        _locService = [[BMKLocationService alloc] init];
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        
        _locService.delegate = self;
        _geocodesearch.delegate = self;
        
        //定位精度
        [BMKLocationService setLocationDesiredAccuracy:10.0];
        //定位距离过滤器
        [BMKLocationService setLocationDistanceFilter:100.0];
        
        self.inLocating = NO; //初始状态
        requireReply = NO;
    }
    
    return self;
}

+ (HBLocationService *)locationService {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return [appDelegate getLocationService];
}

- (void)startLocateTask:(NSTimer *)timer
{
    if (attendIn) {
        self.inLocating = YES;
        [_locService startUserLocationService];
    } else {
        self.inLocating = NO;
        [timer invalidate];
    }
    
}

- (void)startAutoLocating
{
    attendIn = YES;
    [_locService startUserLocationService];
    
    [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(startLocateTask:) userInfo:nil repeats:YES];
}

- (void)stopAutoLocating
{
    attendIn = NO;
    self.inLocating = NO;
}


- (void)locateUserCurrentPosition
{
    [_locService startUserLocationService];
    self.inLocating = YES;
    requireReply = YES;
}


- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
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
    if (error == 0) {
        CLLocationCoordinate2D coordinate = result.location;
        HBLocation *location = [[HBLocation alloc] init];
        location.latitude  = [NSString stringWithFormat:@"%lf", coordinate.latitude];
        location.longitude = [NSString stringWithFormat:@"%lf", coordinate.longitude];
        location.address = result.address;
        
        _serverConnect = [[HBServerConnect alloc] init];
        
        //上传用户位置信息
        HBPosition *positionInfo = [[HBPosition alloc] init];
        positionInfo.userid = [HBCommonUtil getUserId];
        positionInfo.latitude = location.latitude;
        positionInfo.longitude = location.longitude;
        positionInfo.address = location.address;
        positionInfo.forcesend = requireReply?1:0; //上班状态后台定位时，非强制上传；查询位置时，强制上传
        
        NSInteger type = [_serverConnect sendPosition:positionInfo];
        if (type == 2) {
            attendIn = NO;
        }
        
        [HBCommonUtil updateLocation:location];
        [HBCommonUtil updateAttendState:attendIn];
        
        [_locService stopUserLocationService];
        
        if (requireReply) {
            if (_lDelegate != nil) {
                [self.lDelegate currentPositionLocated:location];
            }
            requireReply = NO;
        }
        
        self.inLocating = NO;
    }
}

@end
