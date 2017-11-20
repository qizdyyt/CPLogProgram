//
//  HBMessageCell.h
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBReplyCell.h"
#import "HBCommentBarView.h"
#import "HBServerInterface.h"

@protocol HBMessageCellDelegate <NSObject>

@optional

- (void)didSelectReplyCell:(HBReplyCell *)cell;
- (void)msgUserFilterCellAtIndex:(NSInteger)msgIndex;

- (void)meetingAttendIn:(NSInteger)msgIndex;
- (void)meetingLeaveOut:(NSInteger)msgIndex;

@end



@interface HBMessageCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, HBCommentBarDelegate>

@property(nonatomic,retain) id<HBMessageCellDelegate> mDelegate;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSArray *replylist;   //消息回复列表
@property (nonatomic, assign) NSInteger imgHeight;  //图片高度
@property (nonatomic, assign) NSInteger msgIndex;

//消息日志头部：头像、姓名、时间、内容
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITextView *messageText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgTextViewHeight;

//消息图片
@property (weak, nonatomic) IBOutlet UIImageView *msgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;

//会议面板
@property (weak, nonatomic) IBOutlet UIView *meetingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meetingVeiwHeight;

@property (weak, nonatomic) IBOutlet UIImageView *staffBackImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staffBackImgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *staffLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *staffLabelHeight;


//位置 + 回复组件 + 会议组件
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLblWidth;

@property (weak, nonatomic) IBOutlet UIView *replySetView;
@property (weak, nonatomic) IBOutlet UILabel *replyCount;
@property (weak, nonatomic) IBOutlet UIImageView *replyImg;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@property (weak, nonatomic) IBOutlet UIView *meetingSetView;
@property (weak, nonatomic) IBOutlet UILabel *attendCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *attendButton;
@property (weak, nonatomic) IBOutlet UILabel *leaveCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *leaveButoon;

- (IBAction)attendBtnPressed:(id)sender;
- (IBAction)leaveBtnPressed:(id)sender;


//回复面板
@property (weak, nonatomic) IBOutlet UIImageView *replyBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *replyListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyHeight;



+ (CGFloat)getReplyCellHeight:(HBReply *)reply;

@end
