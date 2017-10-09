//
//  HBLocationService.m
//  HebcaLog
//
//  Created by 周超 on 15/3/1.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBLocationService.h"
#import "HBCommonUtil.h"

@implementation HBLocationService
{
    HBLocation *_location;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.locationmanager = [[CLLocationManager alloc]init];
        self.geocoder = [[CLGeocoder alloc] init];
        
        //设置定位的精度
        [self.locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
        //位置移动最小通知距离
        self.locationmanager.distanceFilter = 500.f;

        //实现协议
        self.locationmanager.delegate = self;
        
        [self.locationmanager requestAlwaysAuthorization];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
        {
            self.locationmanager.pausesLocationUpdatesAutomatically = NO;
        }
    }
    
    return self;
}

- (void)startGpsLocating
{
    NSLog(@"开始定位");
    //开始定位
    [self.locationmanager startUpdatingLocation];
}

- (void)stopGpsLocating
{
    [self.locationmanager stopUpdatingLocation];
}

#pragma mark locationManager delegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //获取经度和纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSString *latitude  = [NSString stringWithFormat:@"%lf", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf", coordinate.longitude];
    __block NSString *address = nil;
    //反编地址位置名称
    [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) {
           address = LOCATION_RECODE_ERROR;
            return;
        }else{
            //显示最前面的地标信息
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            address = firstPlacemark.name;
        }
        
        _location = [[HBLocation alloc] init];
        _location.latitude  = latitude;
        _location.longitude = longitude;
        _location.address   = address;
        
        [HBCommonUtil updateLocation:_location];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            
            if ([self.locationmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                
                [self.locationmanager requestWhenInUseAuthorization];
                
            }
            
            break;
            
        default:  
            
            break;  
            
    }  
}

@end
