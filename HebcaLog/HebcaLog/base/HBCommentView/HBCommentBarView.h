//
//  HBCommentBarView.h
//  HebcaLog
//
//  Created by 周超 on 15/3/19.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBCommentBarDelegate <NSObject>

@optional
- (void)sendCommentText:(UITextView *)textView;

@end


@interface HBCommentBarView : UIView <UITextViewDelegate>

@property (nonatomic, weak)id <HBCommentBarDelegate> comDelegate;
@property (nonatomic, assign) NSInteger funcType;     //0-消息  1-日志 2-会议
@property (nonatomic, copy)  NSString *toUserName;    //被评论对象
@property (nonatomic, assign)NSInteger idTag;   //被评论消息的id

//- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (void)showCommentBar:(UIViewController *)viewController Delegate:(id)delegate;
- (void)dismissCommentBar;

@end
