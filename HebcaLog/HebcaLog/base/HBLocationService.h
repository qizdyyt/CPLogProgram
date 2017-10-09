//
//  HBLocationService.h
//  HebcaLog
//
//  Created by 周超 on 15/3/1.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#define LOCATION_RECODE_ERROR @"反编地理位置信息失败"

@interface HBLocationService : NSObject <CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager* locationmanager;
@property(nonatomic, strong)CLGeocoder *geocoder;

-(id)init;
- (void)startGpsLocating;
- (void)stopGpsLocating;

@end
