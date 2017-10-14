//
//  HBContactViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/3/6.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBContactViewController.h"
#import "HBMiddleware.h"
#import "HBContactInfoCell.h"
#import "HBContactSelectCell.h"
#import "ToastUIView.h"
#import "HBFileManager.h"

@class HBContact;

@implementation HBContactViewController
{
    UILabel *deptNameLabel;
    UIToolbar *_confirmBar;
    
    NSString *_userId;
    NSString *_certCN;
    NSArray *_contactsList;     //当前显示的指定联系人
    NSArray *_baseContactList;  //基准联系人
    NSMutableArray *_selectedContacts;
    
    NSIndexPath *_indexPath;
    CGSize viewSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userId = [HBCommonUtil getUserId];
    _certCN = [HBCommonUtil getCertCN];
    
    [self initViewItems];
    
    
    if (self.funcType != 0 && _authUserIds.count) {
        [self getContactsByUserIdList:_authUserIds];
    }
    else {
        [self getUserContact];
    }
    
    _contactsList = _baseContactList;
    
    _contactTable.rowHeight = 64;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self showOkayCancelAlert];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_confirmBar removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initViewItems
{
    [self configNavigationBar];
    //搜索栏按钮
    for(UIView *view in  [[[self.searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel  setTintColor:[UIColor blackColor]];
            [cancel.titleLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    viewSize = [UIScreen mainScreen].bounds.size;
    
    //部门Label显示
    CGRect deptNameFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    deptNameLabel = [[UILabel alloc] initWithFrame:deptNameFrame];
    deptNameLabel.text = @"  部门";
    deptNameLabel.font = [UIFont systemFontOfSize:14];
    deptNameLabel.textColor = [HBCommonUtil greenColor];
    
    self.contactTable.tableHeaderView = deptNameLabel;
    
    //上一级按钮
    CGRect preFrame = CGRectMake(0, 5, 50, 20);
    UIButton *parentBtn = [[UIButton alloc] initWithFrame:preFrame];
    [parentBtn setTitle:@"上一级" forState:UIControlStateNormal];
    [parentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    parentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [parentBtn addTarget:self action:@selector(gotoUperLevel) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc] initWithCustomView:parentBtn];
    self.navigationItem.rightBarButtonItem = naviBtn;
    
    //底部完成取消按钮 (选择联系人时显示)
    if (self.funcType == 1) {
        _selectedContacts = [[NSMutableArray alloc] init];
        [self.navigationController setToolbarHidden:YES];
        
        CGRect toolBarFrame = CGRectMake(-4, viewSize.height-40, viewSize.width+8, 40);
        _confirmBar = [[UIToolbar alloc] initWithFrame:toolBarFrame];
        [self.navigationController.view addSubview:_confirmBar];
        
        CGRect clearFrame = CGRectMake(0, 0, toolBarFrame.size.width/2, 40);
        UIImage *clearImage = [UIImage imageNamed:@"btn_cancel"];
        UIButton *clearBtn = [[UIButton alloc] initWithFrame:clearFrame];
        [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [clearBtn setBackgroundImage:clearImage forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(cancelChooseContacts) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
        
        CGRect finishFrame = CGRectMake(toolBarFrame.size.width/2, 0, toolBarFrame.size.width/2, 40);
        UIImage *finishImage = [UIImage imageNamed:@"btn_finish"];
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:finishFrame];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [finishBtn setBackgroundImage:finishImage forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishChooseContacts) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *barItem2 = [[UIBarButtonItem alloc] initWithCustomView:finishBtn];
        
        UIBarButtonItem *btnGap = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *items = [NSArray arrayWithObjects:btnGap, barItem1, btnGap, barItem2, btnGap, nil];
        [_confirmBar setItems:items];
    }
}

- (void)gotoUperLevel
{
    //label单位名显示
    NSString * deptNameStr = deptNameLabel.text;
    NSMutableArray *names = [[deptNameStr componentsSeparatedByString:@"-"] mutableCopy];
    if (names.count > 1) {
        [names removeLastObject];
        NSString *newNameStr = [names componentsJoinedByString:@"-"];
        deptNameLabel.text = newNameStr;
    }
    
    //处理表数据
    HBContactDept *lastLevelDept = nil;
    
    id item = [_contactsList objectAtIndex:0];
    if ([item isKindOfClass:[HBContact class]]) {
        HBContact *contact = (HBContact *)item;
        lastLevelDept = contact.parentGroup.parentGroup;
    }
    else if ([item isKindOfClass:[HBContactDept class]]){
        HBContactDept *dept = (HBContactDept *)item;
        lastLevelDept = dept.parentGroup.parentGroup;
    }
    
    if (lastLevelDept != nil)
    {
        _contactsList = [lastLevelDept.depts copy];
    }
    else {
        _contactsList = _baseContactList;
        deptNameLabel.text = @"  部门";
    }
    
    [self.contactTable reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contactsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    if (self.funcType == 1) {
        cell = [self showContactSelection:tableView atIndex:indexPath];
    }
    else {
        cell = [self showContactList:tableView atIndex:indexPath];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
        return;
    }
    
    if ([[_contactsList objectAtIndex:indexPath.row] isKindOfClass:[HBContactDept class]]) { //部门节点：打开通讯录下一级列表
        [self openContactList:indexPath];
    }
    else { //个人节点
        if (self.funcType == 1) {//选中/去选中当前联系人（多选界面）
            [self touchContactSelection:tableView atIndex:indexPath];
        }
        else if (self.funcType == 2){ //单选联系人
            HBContact *selectContact = [_contactsList objectAtIndex:indexPath.row];
            [self.selectDelegate getBackSingleSelect:selectContact];
        }
    }
}

- (UITableViewCell *)showContactList:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    if ([[_contactsList objectAtIndex:indexPath.row] isKindOfClass:[HBContactDept class]]) { //部门节点
        static NSString *CertIdentifier = @"CellIdentifier";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CertIdentifier];
        }
        
        HBContactDept *dept = [_contactsList objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = dept.deptname;
        
        return cell;
    }
    else //个人节点
    {
        static NSString *CertIdentifier = @"contactInfoIdentifier";
        HBContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HBContactInfoCell" owner:self options:nil] lastObject];
        }
        
        HBContact *contact = [_contactsList objectAtIndex:indexPath.row];
        [cell setupLayoutWithContact:contact];
        
        return cell;
    }
}

- (UITableViewCell *)showContactSelection:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    static NSString *CertIdentifier = @"contactDeptoIdentifier";
    HBContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CertIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HBContactSelectCell" owner:self options:nil] lastObject];
    }
    cell.checkBtn.tag = indexPath.row;
    [cell.checkBtn addTarget:self action:@selector(exchangeSelectStatus:) forControlEvents:UIControlEventTouchDown];
    
    UIImage *unselectImg = [UIImage imageNamed:@"list_checkbox"];
    UIImage *selectedImg = [UIImage imageNamed:@"list_checkbox_selected"];
    BOOL selected = NO;
    
    if ([[_contactsList objectAtIndex:indexPath.row] isKindOfClass:[HBContactDept class]]) //单位
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        HBContactDept *dept = [_contactsList objectAtIndex:indexPath.row];
        
        //选中状态
        if ([dept selectedContactsCount] == 0) {
            dept.selected = NO;  //如果以前为选中，后将下面的联系人全部取消，需要将选中状态置为no
            cell.checked = NO;
        }
        else {
            dept.selected = YES; //如果以前未选中，后下面联系人有选中的，需要将Dept选中状态置为yes
            cell.checked = YES;
        }
        selected = dept.selected;
        cell.checked = selected;
        
        //check状态图标显示
        [cell.checkBtn setImage:selected?selectedImg:unselectImg forState:UIControlStateNormal];
        
        //名称显示：部门名称后面显示联系人/选中联系人数量
        NSString *deptName = dept.deptname;
        NSUInteger selectCount = [dept selectedContactsCount];
        NSUInteger allCount =  [dept contactsCount];
        
        cell.nameLable.text = [NSString stringWithFormat:@"%@ (%ld/%ld)", deptName, (unsigned long)selectCount, (unsigned long)allCount];
    }
    else  //个人
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        HBContact *contact = [_contactsList objectAtIndex:indexPath.row];
        
        selected = contact.selected;
        cell.checked = selected;
        [cell.checkBtn setImage:selected?selectedImg:unselectImg forState:UIControlStateNormal];
        
        cell.nameLable.text = contact.username;
    }
    
    return cell;
}


- (void)openContactList:(NSIndexPath *)indexPath
{
    HBContactDept *dept = [_contactsList objectAtIndex:indexPath.row];
    
    NSArray *subDeptList = [dept.depts copy];
    NSArray *subContList = [dept.contacts copy];
    
    NSArray *newList = nil;
    if (subDeptList != nil && [subDeptList count] != 0) {
        newList = subDeptList;
        if (subContList != nil) {
            newList = [subDeptList arrayByAddingObjectsFromArray:subContList];
        }
    }
    else if(subContList != nil && [subContList count] != 0)
    {
        newList = subContList;
    }
    
    if (newList != nil && [newList count] != 0)
    {
        _contactsList = newList;
        
        if ([deptNameLabel.text isEqualToString:@"  部门"]) {
            deptNameLabel.text = [NSString stringWithFormat:@"  %@", dept.deptname];
        }
        else {
            deptNameLabel.text = [deptNameLabel.text stringByAppendingFormat:@" - %@", dept.deptname];
        }
        
        [self.contactTable reloadData];
    }
}

- (void)touchContactSelection:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    //个人用户，点击cell，切换选中、非选中状态
    NSInteger index = indexPath.row;
    
    HBContact *contact = [_contactsList objectAtIndex:index];
    BOOL selected = contact.selected;
    contact.selected = !selected;
    
    UIImage *unselectImg = [UIImage imageNamed:@"list_checkbox"];
    UIImage *selectedImg = [UIImage imageNamed:@"list_checkbox_selected"];
    
    HBContactSelectCell *cell = (HBContactSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.checked = !selected;
    
    [cell.checkBtn setImage:!selected?selectedImg:unselectImg forState:UIControlStateNormal];
}

- (void)exchangeSelectStatus:(id)sender
{
    //图片切换在HBContactSelectCell类里完成了，这里只切换状态
    UIButton *checkBtn = (UIButton *)sender;
    
    BOOL selected;
    NSInteger index = checkBtn.tag;
    
    if ([[_contactsList objectAtIndex:index] isKindOfClass:[HBContactDept class]])
    {
        HBContactDept *dept = [_contactsList objectAtIndex:index];
        selected = dept.selected;
        [dept setDepSelected:!selected];
        
        
        //[self.contactTable reloadRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:UITableViewRowAnimationMiddle];
        
        //名称显示：部门名称后面显示联系人/选中联系人数量
        
        NSString *deptName = dept.deptname;
        NSUInteger selectCount = [dept selectedContactsCount];
        NSUInteger allCount =  [dept contactsCount];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        HBContactSelectCell *cell = (HBContactSelectCell *)[self.contactTable cellForRowAtIndexPath:indexPath];
        
        cell.nameLable.text = [NSString stringWithFormat:@"%@ (%ld/%ld)", deptName, (unsigned long)selectCount, (unsigned long)allCount];
        
    }
    else {
        HBContact *contact = [_contactsList objectAtIndex:index];
        selected = contact.selected;
        contact.selected = !selected;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];

    _contactsList = _baseContactList;
    [self.contactTable reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    NSString *searchStr =self.searchBar.text;
    if (searchStr == nil || [searchStr length] == 0) {
        return;
    }
    
    NSMutableArray *matchContacts = [[NSMutableArray alloc] init];
    NSArray *depts = _baseContactList;
    for (HBContactDept *dept in depts) {
        [matchContacts addObjectsFromArray:[self findContact:searchStr InDept:dept]];
    }
    
    _contactsList = [matchContacts copy];
    [self.contactTable reloadData];
}

- (NSMutableArray *)findContact:(NSString *)target InDept:(HBContactDept *)dept
{
    NSMutableArray *findResult = [[NSMutableArray alloc] init];
    
    NSArray *subContacts = dept.contacts;
    if (subContacts != nil && [subContacts count] != 0)
    {
        for (HBContact *contactItem in subContacts)
        {
            NSRange range = [contactItem.username rangeOfString:target];
            if (range.length > 0) {
                [findResult addObject:contactItem];
            }
        }
    }

    NSArray *subDepts = dept.depts;
    if (subDepts != nil && [subDepts count] != 0)
    {
        for (HBContactDept *subdept in subDepts)
        {
            NSMutableArray *subFindResult = [self findContact:target InDept:subdept];
            if (subFindResult != nil && [subFindResult count] != 0) {
                [findResult addObjectsFromArray:[subFindResult copy]];
            }
        }
    }
    
    return findResult;
}

- (void)getUserContact
{
    //先去本地查找，不存在再去服务端获取
    HBFileManager *fm = [[HBFileManager alloc] init];
    HBContactInfo *contactInfo = [fm getContactFromLocalFile];
    if (!contactInfo) {
        //MARK: 涉及证书部分删掉
//        HBCert *cert = nil;
//        NSArray *certList = [HBMiddleWare getCertList:HB_SIGN_CERT forDeviceType:HB_SOFT_DEVICE];
//        for (HBCert *item in certList) {
//            NSString *certCN = [item getSubjectItem:HB_DN_GIVEN_NAME];
//            if ([certCN isEqualToString:_certCN]) {
//                cert = item;
//                break;
//            }
//        }
        
//        [HBCommonUtil loginCert:cert];
//        NSString *signCert = [cert getBase64CertData];
//        [cert signDataInit:HB_SHA1];
//        NSString *signStr = [NSString stringWithFormat:@"%@", _userId];
//        NSData *signedData = [cert signData:[signStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        HBServerConnect *serverConnet = [[HBServerConnect alloc] init];
        HBContactRequest *request = [[HBContactRequest alloc] init];
        request.userid = _userId;
//        request.signcert = signCert;
//        request.signdata = signedData;
        request.lastupdated = [HBCommonUtil getLastUpdateTime];
        
        contactInfo = [serverConnet getContacts:request];
        if (contactInfo == nil) {
            [HBCommonUtil showAttention:@"获取联系人发生错误" sender:self];
            return;
        }
        
        [fm writeUserContacts:contactInfo];
        
        //更新联系人时间
        if (contactInfo.modified) {
            NSString *currDate = [HBCommonUtil getDateWithYMD:[NSDate date]];
            [HBCommonUtil refreshLastUpdateTime:currDate];
        }
    }
    
    _baseContactList = contactInfo.depts;
}


- (void)finishChooseContacts {
    for (HBContactDept *dept in _baseContactList) {
        NSMutableArray *subSelectCount = [[NSMutableArray alloc] init];
        
        subSelectCount = [dept getSelectedContact];
        
        [_selectedContacts addObjectsFromArray:subSelectCount];
    }
    
    if ([_selectedContacts count] == 0) {
        [self.view makeToast:@"请至少选择一位联系人"];
        return;
    }

    [_confirmBar removeFromSuperview];
    _confirmBar = nil;
    
    [self.selectDelegate getBackSelectContacts:_selectedContacts];
}

- (void)cancelChooseContacts {
    for (HBContactDept *dept in _baseContactList)
    {
        [dept setDepSelected:NO];
    }
    
    [self.contactTable reloadData];
}


- (void)popContactViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissContactViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)getContactsByUserIdList:(NSArray *)userids
{
    if (userids == nil || userids.count == 0) {
        return;
    }
        
    [self getUserContact];
    
    _baseContactList = [NSArray arrayWithArray:[HBContactDept getContactByUserIDs:userids inContactBase:_baseContactList]];
}




@end



#pragma mark HBContactDept Catery
@implementation HBContactDept (HBContactDeptSelect)

- (void)setDepSelected:(BOOL)selected
{
    self.selected = selected;
    
    //下面的联系人列表设置为selected
    if (self.contacts && [self.contacts count] > 0) {
        NSArray *subcontacts = [self.contacts copy];
        
        for (HBContact *subContact in subcontacts) {
            subContact.selected = selected;
        }
    }
    
    //下面的部门列表设置为selected
    if (self.depts && [self.depts count] > 0) {
        NSArray *subDepts = [self.depts copy];
        
        for (HBContactDept *subDept in subDepts)
        {
            subDept.selected = selected;
            
            [subDept setDepSelected:selected];
        }
    }
}

- (NSUInteger)contactsCount
{
    NSUInteger count = self.contacts.count;
    
    if (self.depts && [self.depts count] > 0) {
        NSArray *subDepts = [self.depts copy];
        
        for (HBContactDept *subDept in subDepts)
        {
            NSUInteger subCount = [subDept contactsCount];
            count += subCount;
        }
    }
    
    return count;
}

- (NSUInteger)selectedContactsCount
{
    NSUInteger count = 0;
    
    //遍历联系人列表
    if (self.contacts && [self.contacts count] > 0) {
        NSArray *subcontacts = [self.contacts copy];
        
        NSUInteger contactCount = 0;
        for (HBContact *subContact in subcontacts) {
            if (subContact.selected == YES) {
                contactCount++;
            }
        }
        
        count += contactCount;
    }
    
    //遍历部门列表
    if (self.depts && [self.depts count] > 0) {
        NSArray *subDepts = [self.depts copy];
        
        NSUInteger deptsSelectCount = 0;
        for (HBContactDept *subDept in subDepts)
        {
            deptsSelectCount += [subDept selectedContactsCount];
        }
        
        count += deptsSelectCount;
    }
    
    return count;
}

- (NSMutableArray *)getSelectedContact
{
    NSMutableArray *allSelected = [[NSMutableArray alloc] init];
    
    //遍历联系人列表
    if (self.contacts && [self.contacts count] > 0) {
        NSArray *subcontacts = [self.contacts copy];
        
        for (HBContact *subContact in subcontacts) {
            if (subContact.selected == YES) {
                [allSelected addObject:subContact];
            }
        }
    }
    
    //遍历部门列表
    if (self.depts && [self.depts count] > 0) {
        NSArray *subDepts = [self.depts copy];
        
        NSMutableArray *subSelected = [[NSMutableArray alloc] init];
        
        for (HBContactDept *subDept in subDepts) {
            if ([subDept selectedContactsCount] == 0) {
                continue;
            }
            
            [subSelected addObjectsFromArray:[subDept getSelectedContact]];
        }
        
        [allSelected addObjectsFromArray:subSelected];
    }
    
    return allSelected;
}

/* 根据联系人id列表构造通讯录结构 */
+ (NSArray *)getContactByUserIDs:(NSArray *)userList inContactBase:(NSArray *)baseContactList;
{
    NSMutableArray *deptArr = [[NSMutableArray alloc] init];
    
    //userList列表里面的用户，逐个到总通讯录下查找，如果找到则记录到每个user的部门路径到deptArr列表
    for (NSString *userIdNum in userList) {
        NSString *userid = [NSString stringWithFormat:@"%@", userIdNum];
        id foundRslt = nil;
        
        for (HBContactDept *dept in baseContactList) {
            foundRslt = [HBContactDept findUser:userid inDept:dept]; //迭代查找
            if (foundRslt) {
                HBContactDept *foundDept = [[HBContactDept alloc] init];
                foundDept.deptname = dept.deptname;
                foundDept.deptid   = [NSString stringWithFormat:@"%@", dept.deptid];
                foundDept.selected = NO;
                foundDept.parentGroup = nil;
                
                if ([foundRslt isKindOfClass:[HBContact class]]) {
                    ((HBContact *)foundRslt).parentGroup = foundDept;
                    foundDept.contacts = [NSMutableArray arrayWithObject:foundRslt];
                }
                else if ([foundRslt isKindOfClass:[HBContactDept class]]) {
                    ((HBContactDept *)foundRslt).parentGroup = foundDept;
                    foundDept.depts = [NSMutableArray arrayWithObject:foundRslt];
                }
                
                [deptArr addObject:foundDept];
                break;
            }
        }
    }
    
    //合并查找出来的多个单独的路径
    NSMutableArray *emptyList = [[NSMutableArray alloc] init];
    NSArray * contactList = [HBContactDept mergeList:[deptArr copy] toList:emptyList];
    
    return contactList;
}


+ (id)findUser:(NSString *)userid inDept:(HBContactDept *)dept
{
    NSArray *contactList = [dept.contacts copy];
    if (contactList && contactList.count) {
        for (HBContact *contact in contactList) {
            if ([userid isEqualToString:[NSString stringWithFormat:@"%@", contact.userid]]) {
                return contact;
            }
        }
    }
    
    NSArray *deptList = [dept.depts copy];
    if (deptList && deptList.count) {
        for (HBContactDept *subDept in deptList) {
            id foundResult = [HBContactDept findUser:userid inDept:subDept];
            
            if (foundResult) {
                HBContactDept *newDept = [[HBContactDept alloc] init];
                
                newDept.deptid   = [NSString stringWithFormat:@"%@", subDept.deptid];
                newDept.deptname = subDept.deptname;
                newDept.selected = NO;
                if ([foundResult isKindOfClass:[HBContactDept class]]) {
                    HBContactDept *foundDept = (HBContactDept *)foundResult;
                    foundDept.parentGroup = newDept;
                    newDept.depts = [NSMutableArray arrayWithObject:foundDept];
                }
                else if ([foundResult isKindOfClass:[HBContact class]]) {
                    HBContact *foundContact = (HBContact *)foundResult;
                    foundContact.parentGroup = newDept;
                    foundContact.selected = NO;
                    
                    newDept.contacts = [NSMutableArray arrayWithObject:foundContact];
                }
                
                return newDept;
            }
        }
    }
    
    return nil;
}


+ (NSArray *)mergeList:(NSArray *)origList toList:(NSMutableArray *)newList
{
    NSMutableArray *destList = [NSMutableArray arrayWithArray:[newList copy]];
    
    for (id origItem in origList) //遍历初始列表
    {
        /************************************
         1. 部门节点
         ************************************/
        if ([origItem isKindOfClass:[HBContactDept class]]) {
            BOOL found = NO;
            HBContactDept *dept = (HBContactDept *)origItem;
            NSString *deptId = [NSString stringWithFormat:@"%@", dept.deptid];
            
            //此节点是否在新地址簿中存在
            for (id newItem in destList) {
                if ([newItem isKindOfClass:[HBContactDept class]]) {
                    NSString *itemId = [NSString stringWithFormat:@"%@", ((HBContactDept *)newItem).deptid];
                    if ([deptId isEqualToString:itemId]) {
                        found = YES;
                        
                        //《1.1》存在则merge下一层
                        NSArray *origDepts = ((HBContactDept *)origItem).depts;
                        if (origDepts && origDepts.count) {
                            NSMutableArray *deptList = ((HBContactDept *)newItem).depts;
                            NSArray * mergedList = [HBContactDept mergeList:origDepts toList:deptList];
                            ((HBContactDept *)newItem).depts = [NSMutableArray arrayWithArray:mergedList];
                        }
                        
                        NSArray *origContacts = ((HBContactDept *)origItem).contacts;
                        NSMutableArray *contactList = [NSMutableArray arrayWithArray:((HBContactDept *)newItem).contacts];
                        if (origContacts && origContacts.count) {
                            NSArray * mergedList = [HBContactDept mergeList:origContacts toList:contactList];
                            ((HBContactDept *)newItem).contacts = [NSMutableArray arrayWithArray:mergedList];
                        }
                        
                        break;
                    }
                }
            }
            
            //《1.2》不存在则添加
            if (!found) {
                [destList addObject:dept];
            }
        }
        
        /************************************
         2. 联系人节点
         ************************************/
        else if ([origItem isKindOfClass:[HBContact class]]) {
            BOOL found = NO;
            HBContact *contact = (HBContact *)origItem;
            NSString *userId = [NSString stringWithFormat:@"%@", contact.userid];
            
            //此联系人是否在新地址簿中存在
            for (id newItem in destList) {
                if ([newItem isKindOfClass:[HBContact class]]) {
                    NSString *itemId = [NSString stringWithFormat:@"%@", ((HBContact *)newItem).userid];
                    if ([userId isEqualToString:itemId]) {
                        found = YES;
                        break; //《2.1》联系人已存在则不做处理
                    }
                }
            }
            
            //《2.2》联系人不存在则添加
            if (!found) {
                [destList addObject:origItem];
            }
        }
    }//for 遍历初始列表
    
    return [destList copy];
}



@end

