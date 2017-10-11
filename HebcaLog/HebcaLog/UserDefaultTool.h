//
//  UserDefaultTool.h
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/11.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultTool : NSObject<NSCopying, NSMutableCopying>

+(instancetype) shareUserDefaultTool;
+ (NSNumber *)getUserLoginState;
@end
