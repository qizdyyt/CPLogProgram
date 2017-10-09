//
//  HBLocationService.h
//  HebcaLog
//
//  Created by 周超 on 15/4/2.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>
#import "HBCommonUtil.h"

@protocol HBLocationServiceDelegate <NSObject>

@optional

- (void)currentPositionLocated:(HBLocation *)location;

@end

@interface HBLocationService : NSObject <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, retain) id<HBLocationServiceDelegate> lDelegate;
@property (nonatomic, assign) BOOL inLocating;

- (id)init;
+ (HBLocationService *)locationService;

- (void)startAutoLocating;
- (void)stopAutoLocating;

- (void)locateUserCurrentPosition;

@end
