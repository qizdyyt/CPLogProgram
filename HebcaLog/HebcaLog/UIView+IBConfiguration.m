//
//  UIView+IBConfiguration.m
//  HebcaLog
//
//  Created by 祁子栋 on 2017/10/19.
//  Copyright © 2017年 hebca. All rights reserved.
//

#import "UIView+IBConfiguration.h"

@implementation UIView (IBConfiguration)

@dynamic cornerRadius;//borderColor,borderWidth,

//-(void)setBorderColor:(UIColor *)borderColor{
//    [self.layer setBorderColor:borderColor.CGColor];
//}
//
//-(void)setBorderWidth:(CGFloat)borderWidth{
//    [self.layer setBorderWidth:borderWidth];
//}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

@end
