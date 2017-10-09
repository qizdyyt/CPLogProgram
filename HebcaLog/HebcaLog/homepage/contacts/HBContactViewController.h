//
//  HBContactViewController.h
//  HebcaLog
//
//  Created by 周超 on 15/3/6.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBServerInterface.h"

@protocol HBContactSelectDelegate <NSObject>

@optional
- (void)getBackSelectContacts:(NSMutableArray *)contacts;
- (void)getBackSingleSelect:(HBContact *)contact;

@end

@interface HBContactDept (HBContactDeptSelect)

- (void)setDepSelected:(BOOL)selected;
- (NSUInteger)contactsCount;
- (NSUInteger)selectedContactsCount;
- (NSMutableArray *)getSelectedContact;
+ (NSArray *)getContactByUserIDs:(NSArray *)userList inContactBase:(NSArray *)baseContactList;
@end

@interface HBContactViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain)id<HBContactSelectDelegate> selectDelegate;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *contactTable;

@property (nonatomic, assign)NSInteger funcType;    //0：显示通讯录  1：联系人多选 2：联系人单选
@property (nonatomic, copy) NSArray *authUserIds;

- (void)getContactsByUserIdList:(NSArray *)userids;
- (void)popContactViewController;
- (void)dismissContactViewController;

@end


