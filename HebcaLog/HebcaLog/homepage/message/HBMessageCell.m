//
//  HBMessageCell.m
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBMessageCell.h"
#import "HBReplyCell.h"
#import <QuartzCore/QuartzCore.h>

static NSString *replyCellIdentity = @"HBReplyCell";

@implementation HBMessageCell
{
    HBCommentBarView *_commentBar;
}

@synthesize mDelegate;

- (void)awakeFromNib {
    // Initialization code
    self.replyListView.delegate = self;
    self.replyListView.dataSource = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapped)];
    [self.headImageView addGestureRecognizer:recognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBReply *reply = [self.replylist objectAtIndex:indexPath.row];
    return [HBMessageCell getReplyCellHeight:reply];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBReplyCell *cell = (HBReplyCell *)[tableView dequeueReusableCellWithIdentifier:replyCellIdentity];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HBReplyCell" owner:self options:nil] lastObject];
    }
    
    HBReply *reply = [self.replylist objectAtIndex:indexPath.row];
    cell.msgIndex = self.msgIndex;
    cell.rplIndex = indexPath.row;
    
    NSString *userName = [UserDefaultTool getUserName];
    [reply.sendername stringByReplacingOccurrencesOfString:userName withString:@"我"];
    
    NSString *title = nil;
    if ([reply.sendername isEqualToString:userName]) {
        title = @"我";
    } else {
        title = reply.sendername;
    }
    
    NSString *replyContent = [HBCommonUtil transferUrlHtmlStr:reply.content];
    
    cell.titleLabe.text = title;
    cell.timeLabel.text = reply.time;
    cell.replyContentView.text = replyContent;
    cell.titleLabe.tag = self.replyListView.tag;
    
    cell.contentHeightCS.constant = [HBMessageCell getReplyCellHeight:reply];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.type == 2)  return;  //会议界面不实现点击回复
    
    [self.mDelegate didSelectReplyCell:(HBReplyCell *)[tableView cellForRowAtIndexPath:indexPath]];
}

- (IBAction)attendBtnPressed:(id)sender {
    [self.mDelegate meetingAttendIn:self.msgIndex];
}

- (IBAction)leaveBtnPressed:(id)sender {
    [self.mDelegate meetingLeaveOut:self.msgIndex];
}

+ (CGFloat)getReplyCellHeight:(HBReply *)reply
{
    NSString *content = [HBCommonUtil transferUrlHtmlStr:reply.content];
    
    CGRect viewSize = [UIScreen mainScreen].bounds;
    CGSize textSize = CGSizeMake(viewSize.size.width-30, 3000);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey: NSFontAttributeName];
    
    CGRect bound =  [content boundingRectWithSize:textSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    CGFloat cellHeight = bound.size.height + 24;
    if (cellHeight < 44) {
        cellHeight = 44;
    }
    
    return ceilf(cellHeight);
}

- (void)headImageTapped
{
    [mDelegate msgUserFilterCellAtIndex:self.msgIndex];
}

@end
