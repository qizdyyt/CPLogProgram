//
//  HBMessageTableViewController.m
//  HebcaLog
//
//  Created by 周超 on 15/1/27.
//  Copyright (c) 2015年 hebca. All rights reserved.
//

#import "HBMessageTableViewController.h"
#import "HBMessageCell.h"
#import "HBServerInterface.h"
#import "HBNewMsgViewController.h"

static NSString *messageCellIdentity = @"HBMessageCell";

@interface HBMessageTableViewController ()

@end

@implementation HBMessageTableViewController
{
    NSArray *_msgList;
    NSArray *_journalList;
    
    NSMutableArray *_textViewHeightRecords;
    NSMutableArray *_imageViewHeightRecords;
    NSMutableArray *_imageViewWidthRecords;
    
    HBServerConnect *serverConnect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _textViewHeightRecords  = [[NSMutableArray alloc] init];
    _imageViewHeightRecords = [[NSMutableArray alloc] init];
    _imageViewWidthRecords  = [[NSMutableArray alloc] init];
    
    serverConnect = [[HBServerConnect alloc] init];
    
    //在导航栏添加刷新、写消息按钮
    [self addNavigatorButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.type ? [_journalList count] : [_msgList count];
}

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算文本框高度
    CGFloat textHeight = [self getTextViewHeight:indexPath.row];
    
    //计算图片高度
    CGFloat imageHeight = [self getImageViewHeight:indexPath.row];
    
    //回复列表高度
    CGFloat replysHeight = [self getReplysHeight:indexPath.row];
    
    CGFloat cellHeight = 125 + (textHeight - 30);
    
    if (imageHeight != 0) {
        cellHeight += (imageHeight + 5);
    }
    if (replysHeight != 0) {
        cellHeight += (replysHeight);
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentity];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HBMessageCell" owner:self options:nil] lastObject];
    }
    
    NSInteger replyCount = 0;
    NSString *textContent = nil;
    NSString *imgUrl = nil;
    if (0 == self.type) {
        HBMessageInfo *msgInfo = [_msgList objectAtIndex:indexPath.row];
        cell.userNameLbl.text   = msgInfo.username;
        cell.timeLbl.text       = msgInfo.time;
        cell.locationLbl.text   = msgInfo.address;
        cell.replylist          = msgInfo.replies;
        replyCount =    [msgInfo.replies count];
        textContent =   msgInfo.content;
        imgUrl =        msgInfo.image;
    }
    else if(1 == self.type) {
        HBJournalInfo *journalInfo = [_journalList objectAtIndex:indexPath.row];
        cell.userNameLbl.text   = @"我";
        cell.timeLbl.text       = journalInfo.time;
        cell.locationLbl.text   = journalInfo.address;
        cell.replylist          = journalInfo.replies;
        replyCount =  journalInfo.replies.count;
        textContent = journalInfo.content;
        imgUrl =      journalInfo.image;
    }
    
    //根据文本内容调整textView大小
    cell.msgTextViewHeight.constant = [self getTextViewHeight:indexPath.row];
    cell.messageText.text = textContent;
    
    //图片显示
    CGFloat imgwidth = 0;
    CGFloat imgheight = 0;
    if (nil != imgUrl && [imgUrl length] > 0) {
        NSString *fullUrl = [MLOG_SERVER_URL stringByAppendingFormat:@"download.action?filename=%@", imgUrl];
        NSString* imageUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *urlstr = [NSURL URLWithString:imageUrl];
        UIImage *msgImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlstr]];
        if (msgImg.size.width <= 200) {
            imgwidth  = msgImg.size.width;
            imgheight = msgImg.size.height;
        }else {
            imgwidth = 200;
            imgheight = 200 * msgImg.size.height / msgImg.size.width;
        }

        UIImageView *imgView = [[UIImageView alloc] initWithImage:msgImg];
        //[imgView setImage:msgImg];
        [imgView setFrame:CGRectMake(5, 105, imgwidth, imgheight)];
        [cell addSubview:imgView];
        
        /*CGRect replysFrame = cell.replysTableView.frame;
        replysFrame.origin.y += (height + 5);
        cell.replysTableView.frame = replysFrame;*/
    }
    
    //回复数量为0  不显示回复图标和计数
    if (replyCount == 0) {
        cell.replyImg.hidden = YES;
        cell.replyCount.hidden = YES;
        cell.replyListView.hidden = YES;
    } else {
        cell.replyImg.hidden = NO;
        cell.replyCount.hidden = NO;
        cell.replyCount.text    = [NSString stringWithFormat:@"%ld", (unsigned long)replyCount];
        
        cell.replyListView.hidden = NO;
        cell.replyListTopspage.constant += (imgheight+5);
    }
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (CGFloat)getTextViewHeight:(NSInteger)index
{
    CGSize textSize = CGSizeMake(312, 1000);
    NSString *textContent = nil;
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_msgList objectAtIndex:index];
        textContent = msgInfo.content;
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        textContent = jnlInfo.content;
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:textContent];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    CGRect bound =  [textContent boundingRectWithSize:textSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:dic
                                              context:nil];
    CGFloat boundheight = bound.size.height + 17; //增加附加值，不然多行字符显示不全
    NSNumber *height = [NSNumber numberWithFloat:boundheight];
    
    return [height floatValue];
}

- (CGFloat)getImageViewHeight:(NSInteger)index
{
    NSString *imageName = nil;
    NSString *imageUrl = @"";
    
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_msgList objectAtIndex:index];
        imageName = msgInfo.image;
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        imageName = jnlInfo.image;
    }
    
    if (imageName == nil || [imageName length] == 0) {
        NSNumber *imgHeight = [NSNumber numberWithFloat:0];
        NSNumber *imgWidth  = [NSNumber numberWithFloat:0];
        [_imageViewHeightRecords addObject:imgHeight];
        [_imageViewWidthRecords addObject:imgWidth];
        
        return 0;
    }
    
    NSString *fullUrl = [MLOG_SERVER_URL stringByAppendingFormat:@"download.action?filename=%@", imageName];
    imageUrl = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlstr = [NSURL URLWithString:imageUrl];
    UIImage *msgImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlstr]];
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (msgImg.size.width <= 200) {
        width  = msgImg.size.width;
        height = msgImg.size.height;
    }else {
        width = 200;
        height = 200 * msgImg.size.height / msgImg.size.width;
    }
    
    NSNumber *imgHeight = [NSNumber numberWithFloat:height];
    NSNumber *imgWidth  = [NSNumber numberWithFloat:width];
    [_imageViewHeightRecords addObject:imgHeight];
    [_imageViewWidthRecords addObject:imgWidth];

    return height;
}

- (CGFloat)getReplysHeight:(NSInteger)index
{
    NSInteger count = 0;
    if (self.type == 0) {
        HBMessageInfo *msgInfo = [_msgList objectAtIndex:index];
        count = [msgInfo.replies count];
    }
    else if (self.type == 1) {
        HBJournalInfo *jnlInfo = [_journalList objectAtIndex:index];
        count = [jnlInfo.replies count];
    }
    
    if (count == 0) {
        return 0;
    }
    
    return count*60;
}

-(void)addNavigatorButton
{
    UIBarButtonItem *segButton = nil;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    UIImage *freshImage  = [UIImage imageNamed:@"btn_refresh_pressed"];
    UIImage *newMsgImage = [UIImage imageNamed:@"btn_add_pressed"];
    
    
    UIButton *freshButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    UIButton *newMsgButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 20, 20)];
    
    [freshButton setImage:freshImage forState:UIControlStateNormal];
    [newMsgButton setImage:newMsgImage forState:UIControlStateNormal];
    
    [freshButton addTarget:self action:@selector(freshMessageList) forControlEvents:UIControlEventTouchDown];
    [newMsgButton addTarget:self action:@selector(newMessage) forControlEvents:UIControlEventTouchDown];
    
    [customView addSubview:freshButton];
    [customView addSubview:newMsgButton];
    segButton = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
    self.navigationItem.rightBarButtonItem = segButton;
}

- (void)loadData
{
    if (0 == self.type){
        HBMsgRequestInfo *request = [[HBMsgRequestInfo alloc] init];
        request.userid = self.userid;
        request.getuserid = @"";
        request.pagenum = 1;
        request.pagesize = 20;
        
        _msgList = [[serverConnect getMsgList:request] copy];
    }
    else if(1 == self.type){
        HBJournalRequestInfo *request = [[HBJournalRequestInfo alloc] init];
        request.userid = self.userid;
        request.getuserid = self.userid;
        request.pagenum = 1;
        request.pagesize = 20;
        request.date = @"2015-03-03";
        
        _journalList = [serverConnect getJournalList:request];
    }
    [self.tableView reloadData];
}

-(void)freshMessageList
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    
    [self.view addSubview:hud];
    
    [hud showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
}

- (void)newMessage
{
    HBNewMsgViewController *newMesgView = [[HBNewMsgViewController alloc] init];
    newMesgView.title = self.type == 0 ? @"写消息" : @"写日志";
    newMesgView.type  = self.type;
    [self.navigationController pushViewController:newMesgView animated:YES];
}

@end
