//
//  HBUserConfig.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/22.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import "HBUserConfig.h"

@implementation HBUserConfig : NSObject

- (id)init
{
    self = [super init];
    if (self)
    {
        self.clientrole = 0;
        self.userId     = nil;
        self.userName   = nil;
        self.deptId     = nil;
        self.deptName   = nil;
        self.certCN     = nil;
        
        HBLocation *location = [[HBLocation alloc] init];
        self.location = location;
    }
    
    return self;
}

@end


