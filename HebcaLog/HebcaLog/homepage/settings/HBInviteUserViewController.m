//
//  HBInviteUserViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/5/5.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBInviteUserViewController.h"
#import "HBCommonUtil.h"
#import <AddressBook/AddressBook.h>
#import "ToastUIView.h"
#import "HBServerInterface.h"

@implementation HBAddressContact

@end

@implementation HBInviteUserViewController
{
    NSArray *contactList;
    NSArray *searchRsltList;
    
    BOOL searchMode;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    
    searchMode = NO;
    
    //搜索栏按钮
    for(UIView *view in  [[[self.searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel  setTintColor:[UIColor blackColor]];
            [cancel.titleLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    self.tableview.rowHeight = 52.0;
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    
    CFErrorRef error = NULL;
    ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    //申请联系人授权
    ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error)
    {
        if (granted)
        {
            //NSArray *persons = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(abRef));
            NSArray *persons = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(abRef, ABAddressBookCopyDefaultSource(abRef), kABPersonSortByLastName));
            
            NSMutableArray *personLists =  [NSMutableArray array];
            NSInteger count = [persons count];
            for (int i = 0; i < count; i++)
            {
                ABRecordRef personRecord = CFBridgingRetain([persons objectAtIndex:i]);
                
                HBAddressContact *contact = [[HBAddressContact alloc] init];
                
                //姓名 单值属性
                NSString *firstName = CFBridgingRelease(ABRecordCopyValue(personRecord, kABPersonFirstNameProperty));
                firstName = firstName ? firstName : @"";
                NSString *lastName =  CFBridgingRelease(ABRecordCopyValue(personRecord, kABPersonLastNameProperty));
                lastName = lastName ? lastName : @"";
                contact.name = [NSString stringWithFormat:@"%@%@", lastName, firstName];;
                
                //电话 通过ABRecord 查找多值属性
                ABMultiValueRef phoneProperty = ABRecordCopyValue(personRecord, kABPersonPhoneProperty);
                if (phoneProperty) {
                    CFIndex count = ABMultiValueGetCount(phoneProperty);
                    for (int i = 0; i < count; i++) {
                        NSString *number = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneProperty, i);
                        if (number) {
                            contact.phone = [self deleteSpecialCharactorInPhoneNum:number];
                            break;
                        }
                    }
                    
                    CFRelease(phoneProperty);
                }
                
                contact.checked = NO;
                [personLists addObject:contact];
                CFRelease(personRecord);
            }
            
            contactList = [personLists copy];
            //[self.tableview reloadData];
        }
        else {
            //如果没有授权则退出
            if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
                [HBCommonUtil showAttention:@"没有联系人权限,请到设置中开启" sender:self];
                return ;
            }
        }
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = searchMode ? searchRsltList.count : contactList.count;
    return count;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CertIdentifier = @"CertIdentifier";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CertIdentifier];
    }
    
    NSInteger index = indexPath.row;
    cell.textLabel.textColor = [HBCommonUtil greenColor];
    cell.detailTextLabel.textColor = [UIColor orangeColor];
    
    HBAddressContact *contact = searchMode ? [searchRsltList objectAtIndex:index] : [contactList objectAtIndex:index];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.phone;
    
    UIImage *unselectImg = [UIImage imageNamed:@"list_checkbox"];
    UIImage *selectedImg = [UIImage imageNamed:@"list_checkbox_sl"];
    if (!contact.checked) {
        [cell.imageView setImage:unselectImg];
    }else {
        [cell.imageView setImage:selectedImg];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIImage *unselectImg = [UIImage imageNamed:@"list_checkbox"];
    UIImage *selectedImg = [UIImage imageNamed:@"list_checkbox_sl"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    HBAddressContact *contact = searchMode ? [searchRsltList objectAtIndex:indexPath.row] : [contactList objectAtIndex:indexPath.row];
    BOOL checkstatus = contact.checked;
    
    if (checkstatus) {
        [cell.imageView setImage:unselectImg];
    }else {
        [cell.imageView setImage:selectedImg];
    }
    
    contact.checked = !checkstatus;
}

- (IBAction)inviteBtnPressed:(id)sender
{
    NSMutableArray *selectedNames  = [[NSMutableArray alloc] init];
    NSMutableArray *selectedPhones = [[NSMutableArray alloc] init];
    
    NSInteger count = searchMode ? searchRsltList.count : contactList.count;
    for (int index = 0; index < count; index++) {
        HBAddressContact *contact = searchMode ? [searchRsltList objectAtIndex:index] : [contactList objectAtIndex:index];
        BOOL seleceted = contact.checked;
        if (seleceted) {
            [selectedNames addObject:contact.name];
            [selectedPhones addObject:contact.phone];
        }
    }
    
    //未选中时，弹出提示框
    if (selectedNames.count == 0) {
        [self.view makeToast:@"请至少选择一个联系人"];
        return;
    }
    
    //调用服务端接口  发送邀请短信
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"正在处理";
    [self.view addSubview:hud];
    
    [hud showAnimated:YES whileExecutingBlock:^{
        NSString *namesStr = [selectedNames componentsJoinedByString:@","];
        NSString *phoneStr = [selectedPhones componentsJoinedByString:@","];
        
        HBServerConnect *serverConnect = [[HBServerConnect alloc] init];
        [serverConnect inviteUserNames:namesStr phones:phoneStr];
    }completionBlock:^{
        [self.navigationController.view makeToast:@"邀请短信已发送"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//删除手机号中的‘-’
- (NSString *)deleteSpecialCharactorInPhoneNum:(NSString *)phoneNum
{
    NSArray *phoneNumArr = [phoneNum componentsSeparatedByString:@"-"];
    NSString *newNumber = [phoneNumArr componentsJoinedByString:@""];
    
    return newNumber;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    searchMode = NO;
    
    [self.tableview reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    searchMode = YES;
    
    NSString *searchStr =self.searchBar.text;
    if (searchStr == nil || [searchStr length] == 0) {
        return;
    }
    
    NSMutableArray *matchContacts = [[NSMutableArray alloc] init];
    for (HBAddressContact *contact in contactList)
    {
        NSRange range = [contact.name rangeOfString:searchStr];
        if (range.length) {
            [matchContacts addObject:contact];
        }
    }
    
    searchRsltList = [matchContacts copy];
    [self.tableview reloadData];
}

@end
