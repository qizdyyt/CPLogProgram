//
//  DAKeyboardControl.h
//  DAKeyboardControlExample
//
//  Created by Daniel Amitay on 7/14/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DAKeyboardDidMoveBlock)(CGRect keyboardFrameInView);
typedef void (^DAKeyboardDidCompleteBlock)(BOOL finished, BOOL isShowing);

@interface UIView (DAKeyboardControl)

@property (nonatomic) CGFloat keyboardTriggerOffset;

- (void)addKeyboardPanningWithActionHandler:(DAKeyboardDidMoveBlock)didMoveBlock;
- (void)addKeyboardNonpanningWithActionHander:(DAKeyboardDidMoveBlock)didMoveBlock;
- (void)addKeyboardCompletionHandler:(DAKeyboardDidCompleteBlock)didMoveBlock;

- (void)removeKeyboardControl;

- (CGRect)keyboardFrameInView;

- (void)setgMailTemplateType:(NSInteger)mailTemplateType;
- (void)setMailUITextView:(UITextView*)mailUITextView;
- (void)setMailUIWebView:(UIWebView*)mailUIWebView;

@end