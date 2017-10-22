//
//  HBPopListView.h
//  HBPopListViewDemo
//
//  Created by HEBCA on 2/21/12.
//  Copyright (c) 2012 HEBCA. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol HBPopListViewDelegate;
@interface HBPopListView : UIView <UITableViewDataSource, UITableViewDelegate>
{

    UITableView *_tableView;
    NSString *_title;
    NSArray *_options;
}

@property (nonatomic, assign) id<HBPopListViewDelegate> delegate;
//
@property (nonatomic, assign) BOOL canCancelFlag;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;

// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (NSString*)title;
@end

@protocol HBPopListViewDelegate <NSObject>
- (void)myPopListView:(HBPopListView *)popListView didSelectedIndex:(NSInteger)anIndex;
- (void)myPopListViewDidCancel;
@end