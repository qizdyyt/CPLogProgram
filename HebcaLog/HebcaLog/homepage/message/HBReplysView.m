//
//  HBReplysView.m
//  HebcaLog
//
//  Created by 周超 on 15/3/18.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBReplysView.h"
#import <QuartzCore/QuartzCore.h>

@implementation HBReplysView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor greenColor] CGColor];
    }
    
    return self;
}

- (void)updateViewForReplys:(NSArray *)replys
{
    CGFloat replysViewWidth = self.frame.size.width;
    
    int count = [replys count];
    for (int i = 0; i < count; count++)
    {
        HBReply *reply = [replys objectAtIndex:i];
        
        //创建每一个reply item的view
        CGFloat itemWidth = replysViewWidth - 10;
        CGFloat itemHeight = 40;
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, itemWidth, itemHeight)];
        
        //回复者label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor greenColor];
        titleLabel.text = reply.content;
        [itemView addSubview:titleLabel];
        
        //时间日期label
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth - 60, 4, 60, 16)];
        dateLabel.font = [UIFont systemFontOfSize:9];
        dateLabel.textColor = [UIColor darkTextColor];
        dateLabel.text = reply.time;
        [itemView addSubview:dateLabel];
        
        //回复内容Label
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.textColor = [UIColor darkTextColor];
        contentLabel.text = reply.content;
        
        CGSize contentSize  = [contentLabel sizeThatFits:CGSizeMake(itemWidth, 2000)];
        CGFloat height = contentSize.height;
        if (height < 20) height = 20;
        if (height > 80) height = 80;
        CGRect contentFrame = CGRectMake(0, 20, itemWidth, contentSize.height);
        [contentLabel setFrame:contentFrame];
        
        [itemView addSubview:contentLabel];
        
        //最上层添加一个透明的textView （用以实现点击回复内容，弹出回复键盘）
        //最上层添加一个control， 用以响应点击动作，进行回复
        
        
        
        [self addSubview:itemView];
        CGRect viewFrame = self.frame;
        viewFrame.size.height += height - 20;
        [self setFrame:viewFrame];
        
        
        //添加分割线
        if (i != count - 1 && count != 1) {
            UIImage *divierImg = [UIImage imageNamed:@"divider_solid"];
            UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(2, itemHeight+1, replysViewWidth - 4, 1)];
            [divider setImage:divierImg];
            
            [self addSubview:divider];
        }
    }

}


- (id)initWithReply:(NSArray *)replys
{
    self = [super init];
    if (!self) return nil;
    
    int count = replys.count;
    
    CGRect viewFrame = [UIScreen mainScreen].bounds;
    CGFloat replysViewWidth = viewFrame.size.width - 10;
    
    CGRect replysFrame = CGRectMake(5, 0, replysViewWidth, 41 * count);
    [self setFrame:replysFrame];
    [self setBackgroundColor:[UIColor lightGrayColor]];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor greenColor] CGColor];
    
    for (int i = 0; i < count; count++)
    {
        HBReply *reply = [replys objectAtIndex:i];
        
        //创建每一个reply的view
        CGFloat replyWidth = replysViewWidth - 10;
        CGFloat replyHeight = 40;
        UIView *replyView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, replyWidth, replyHeight)];
        
        //回复者label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor greenColor];
        titleLabel.text = reply.content;
        [replyView addSubview:titleLabel];
        
        //时间日期label
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyWidth - 60, 4, 60, 16)];
        dateLabel.font = [UIFont systemFontOfSize:9];
        dateLabel.textColor = [UIColor darkTextColor];
        dateLabel.text = reply.time;
        [replyView addSubview:dateLabel];
        
        //回复内容Label
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.textColor = [UIColor darkTextColor];
        contentLabel.text = reply.content;
        
        CGSize contentSize  = [contentLabel sizeThatFits:CGSizeMake(replyWidth, 2000)];
        CGFloat height = contentSize.height;
        if (height < 20) height = 20;
        if (height > 80) height = 80;
        CGRect contentFrame = CGRectMake(0, 20, replyWidth, contentSize.height);
        [contentLabel setFrame:contentFrame];
        
        [replyView addSubview:contentLabel];
        
        //最上层添加一个透明的textView （用以实现点击回复内容，弹出回复键盘）
        //最上层添加一个control， 用以响应点击动作，进行回复
        
        
        
        [self addSubview:replyView];
        CGRect viewFrame = self.frame;
        viewFrame.size.height += height - 20;
        [self setFrame:viewFrame];
        
        
        //添加分割线
        if (i != count - 1 && count != 1) {
            UIImage *divierImg = [UIImage imageNamed:@"divider_solid"];
            UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(2, replyHeight+1, replysViewWidth - 4, 1)];
            [divider setImage:divierImg];
            
            [self addSubview:divider];
        }
        
    }

    return self;
}



@end
