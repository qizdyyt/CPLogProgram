//
//  HBRemindViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/10.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBRemindInfo : NSObject

@property (nonatomic, copy)NSString *remindId;
@property (nonatomic, assign)BOOL isRepeated;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSMutableArray* weekSelection; //从周日开始 日一二三四五六

//-(id)init;

@end


@interface HBRemindViewController : UIViewController //<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign)NSInteger funType;  //type： 0 - 从主页进入；1 - 新建提醒； 2 - 修改提醒；

- (void)configingFinshed:(NSString *)timeInterval;

@end
