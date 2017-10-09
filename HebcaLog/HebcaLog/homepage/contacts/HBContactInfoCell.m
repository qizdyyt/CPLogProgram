//
//  HBContactInfoCell.m
//  HebcaLog
//
//  Created by 周超 on 15/3/6.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBContactInfoCell.h"

@implementation HBContactInfoCell
{
    NSString *_phoneNum;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}

- (void)setupLayoutWithContact: (HBContact *)contact {
    self.userNameLabel.text = contact.username;
    self.phoneNumLabel.text = contact.phone == nil ? @"-" : contact.phone;
    
    NSString *phone = contact.telephone == nil ? @"-" : contact.telephone;
    NSString *extend = contact.extension == nil ? @"" : contact.extension;
    self.telephoneNumLabel.text = [NSString stringWithFormat:@"%@-%@", phone, extend];
}

- (IBAction)callPhone:(id)sender {
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *callUrl = [NSString stringWithFormat:@"tel://%@", self.phoneNumLabel.text];
    NSURL *telURL = [NSURL URLWithString:callUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self addSubview:callWebview];
}
@end
