//
//  HBPopoverTableTableViewController.h
//  TSPopoverDemo
//
//  Created by hebca on 14-9-11.
//  Copyright (c) 2014年 ar.ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HBPopoverDelegate <NSObject>

- (void)didSelectRowAtIndexPath:(NSInteger)index;

@end

@protocol HBPopoverTableTableViewDelegate <NSObject>

- (void)didSelectRowAtIndexPath:(NSInteger)index;
- (void) dismissPopoverAnimatd:(BOOL)animated;

@end

@interface HBPopoverController : UIViewController<HBPopoverTableTableViewDelegate>

@property (nonatomic, strong) UIColor *cellColor;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign) CGSize popoverViewSize;
@property (nonatomic, strong) NSArray *cellsText;
@property (nonatomic, strong) UIColor *popoverBaseColor;
@property (nonatomic, weak) id<HBPopoverDelegate> delegate;

//Action As: -(void)showPopover:(id)sender forEvent:(UIEvent*)event
- (void) showPopoverWithTouch:(UIEvent*)senderEvent;

@end



@interface HBPopoverTableTableViewController : UITableViewController

@property (nonatomic, strong) UIColor *cellColor;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, strong) NSArray *cellsText;
@property (nonatomic, weak) id<HBPopoverTableTableViewDelegate> popoverDelegate;

@end
