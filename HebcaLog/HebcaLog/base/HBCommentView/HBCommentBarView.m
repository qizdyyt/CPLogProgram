//
//  HBCommentBarView.m
//  HebcaLog
//
//  Created by 周超 on 15/3/19.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBCommentBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "ToastUIView.h"

//屏幕宽度
#define WIDTH_SCREEN [UIScreen mainScreen].applicationFrame.size.width
//屏幕高度
#define HEIGHT_SCREEN [UIScreen mainScreen].applicationFrame.size.height


@implementation HBCommentBarView
{
    BOOL  _textNull;   //文本框是否有输入
    BOOL  _hasInput;    //是否有输入
    
    UIViewController *_viewController;
    
    UIControl *_baseMask;
    UIView *_barView;
    UITextView *_textView;
    UIButton *_sendBtn;
    
    NSString *placeHolderStr;
    CGFloat _textWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        //[self setFrame:frame];
        
        _textWidth = frame.size.width > 320 ? 290 : 240;
        
        CGRect textFrame = CGRectMake(6, 8, _textWidth, 24);
        _textView = [[UITextView alloc] initWithFrame:textFrame];
        _textView.font = [UIFont systemFontOfSize:14.0];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.layer.borderColor = [[UIColor grayColor] CGColor];
        _textView.layer.borderWidth = 1;
        [_textView.layer setCornerRadius:5];
        [self addSubview:_textView];
        
        CGFloat btnWidth = 60;
        CGRect btnFrame = CGRectMake(frame.size.width - 5 - btnWidth, 8, btnWidth, 24);
        _sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sendBtn setFrame:btnFrame];
        [_sendBtn.layer setCornerRadius:3];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_sendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_sendBtn];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        _textNull = YES;
    }
    
    return self;
}


- (void)setTextViewPlaceholder
{
    _textNull = YES;
    _textView.textColor = [UIColor lightGrayColor];
    
    if (self.funcType == 2) {
        placeHolderStr = @"请填写请假原因:";
    }
    else {
        placeHolderStr = [NSString stringWithFormat:@"回复:%@", self.toUserName?self.toUserName:@""];
    }
    _textView.text = placeHolderStr;
}

- (void)cancelTextViewPlaceholder
{
    _textNull = YES;
    _textView.textColor = [UIColor darkTextColor];
    _textView.text = nil;
}

- (void)showCommentBar:(UIViewController *)viewController Delegate:(id)delegate
{
    _viewController = viewController;
    self.comDelegate = delegate;
    _textView.tag = self.idTag;
    
    [self setTextViewPlaceholder];
    [_textView becomeFirstResponder];
    
    [_viewController.view addSubview:self];
}

- (void)sendBtnPressed:(id)sender
{
    [_textView resignFirstResponder];
    
    if (_textView.text.length == 0 || [_textView.text isEqualToString:placeHolderStr]) {
        [((UIViewController *)self.comDelegate).view makeToast:@"回复内容不能为空"];
        return;
    }
    
    [self dismissCommentBar];

    [self.comDelegate sendCommentText:_textView];
}


-(void)dismissCommentBar
{
    [_textView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:nil];
    
    [self removeFromSuperview];
}

- (void)dismissKeyboardView //点击屏幕其他地方 键盘消失
{
    [_textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    CGRect _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!_baseMask)
    {
        _baseMask =[[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN,HEIGHT_SCREEN)];
        _baseMask.backgroundColor =[UIColor blackColor];
        _baseMask.alpha =0.0f;
        [_baseMask addTarget:self action:@selector(dismissKeyboardView) forControlEvents:UIControlEventTouchDown];
        
        [_viewController.view addSubview:_baseMask];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _baseMask.alpha =0.1f;
        CGFloat barHeight = self.frame.size.height;
        self.frame =CGRectMake(0, HEIGHT_SCREEN-_keyboardRect.size.height-barHeight-40, WIDTH_SCREEN, barHeight);
        [_viewController.view bringSubviewToFront:self];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification //键盘下落
{
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat barHeight = self.frame.size.height;
        self.frame=CGRectMake(0, HEIGHT_SCREEN-barHeight-40, WIDTH_SCREEN, barHeight);
        _baseMask.alpha =0.0f;
    } completion:^(BOOL finished) {
        [_baseMask removeFromSuperview];
        _baseMask =nil;
        
        if (_textNull) {
            [self setTextViewPlaceholder]; //键盘消失时，恢复TextView内容
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize contentSize = _textView.contentSize;
    
    if (contentSize.height > 140){
        return;
    }
    
    CGRect selfFrame = self.frame;
    CGFloat selfHeight = contentSize.height + 10;
    CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
    selfFrame.origin.y = selfOriginY;
    selfFrame.size.height = selfHeight;
    self.frame = selfFrame;
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_textNull){  //输入文字时取消placeholder效果
        [self cancelTextViewPlaceholder];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (_textView.text == nil || [textView.text length] == 0)
    {
        [self setTextViewPlaceholder];
    }
    else {
        _textNull = NO;
    }
}



@end
