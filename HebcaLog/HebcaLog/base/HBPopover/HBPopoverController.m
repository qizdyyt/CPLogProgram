//
//  HBPopoverTableTableViewController.m
//  TSPopoverDemo
//
//  Created by hebca on 14-9-11.
//  Copyright (c) 2014年 ar.ms. All rights reserved.
//

#import "HBPopoverController.h"
#import "TSPopoverController.h"

@implementation HBPopoverController
{
    HBPopoverTableTableViewController *popoverTableViewController;
    TSPopoverController *popoverController;
}

- (void)didSelectRowAtIndexPath:(NSInteger)index
{
    [self.delegate didSelectRowAtIndexPath:index];
}

- (void) showPopoverWithTouch:(UIEvent*)senderEvent
{
    if (nil == popoverTableViewController) {
        popoverTableViewController = [[HBPopoverTableTableViewController alloc] initWithStyle:UITableViewStylePlain];
    }
    //计算高度、宽度
    NSInteger cellsCount = [self.cellsText count];
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0) {
        popoverTableViewController.tableView.rowHeight = 44;
        
    }
        
    CGFloat height = popoverTableViewController.tableView.rowHeight*cellsCount-1;
    
    CGRect viewRect = CGRectMake(0, 0, self.popoverViewSize.width, self.popoverViewSize.height);
    if (0==viewRect.size.height || 0==viewRect.size.width) {
        CGFloat width = 0;
        UIFont *font = nil;
        if (nil != self.cellFont) {
            font = self.cellFont;
        } else {
            font = [UIFont fontWithName:@"helvetica" size:17.0];
        }
        for (NSString *cellText in self.cellsText) {
            CGSize sizeofCellText = [cellText sizeWithFont:font constrainedToSize:CGSizeMake(320, 300)];
            if (sizeofCellText.width > width) {
                width = sizeofCellText.width;
            }
        }
        
        viewRect = CGRectMake(0,0, width+30, height);
    }

    if (nil == self.cellColor) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        popoverTableViewController.cellColor = button.tintColor;
    } else {
        popoverTableViewController.cellColor = self.cellColor;
    }
    popoverTableViewController.cellFont = self.cellFont;
    popoverTableViewController.cellsText = self.cellsText;
    popoverTableViewController.popoverDelegate = self;
    popoverTableViewController.view.frame = viewRect;
    [popoverTableViewController.tableView reloadData];
    if (nil == popoverController) {
        popoverController = [[TSPopoverController alloc] initWithContentViewController:popoverTableViewController];
    }
    
    popoverController.cornerRadius = 5;
    if (nil != self.popoverBaseColor) {
        popoverController.popoverBaseColor = self.popoverBaseColor;
    } else {
        popoverController.popoverBaseColor = [UIColor whiteColor];
    }
    popoverController.popoverGradient= YES;
    [popoverController showPopoverWithTouch:senderEvent];
}

- (void) dismissPopoverAnimatd:(BOOL)animated
{
    if (nil != popoverController) {
        [popoverController dismissPopoverAnimatd:YES];
    }
}

@end

@interface HBPopoverTableTableViewController ()

@end

@implementation HBPopoverTableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.cellsText count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *popoverTableIdentifier = @"HBPopoverTableTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popoverTableIdentifier];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:popoverTableIdentifier];
    }
    

    cell.textLabel.text = self.cellsText[indexPath.row];
    if (nil != self.cellFont) {
        cell.textLabel.font = self.cellFont;
    } else {
        cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:16.0];
    }
    if (nil != self.cellColor) {
        cell.textLabel.textColor = self.cellColor;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.popoverDelegate didSelectRowAtIndexPath:indexPath.row];
    [self.popoverDelegate dismissPopoverAnimatd:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
