//
//  HBLocationViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "HBContactViewController.h"

@interface HBLocationViewController : UIViewController <BMKMapViewDelegate,BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, UISearchBarDelegate, HBContactSelectDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
