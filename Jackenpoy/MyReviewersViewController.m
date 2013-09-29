//
//  MyReviewersViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MyReviewersViewController.h"
#import "PRLFinishViewController.h"
#import "ReviewerCell.h"
#import "Reviewer.h"
#import "Challenge.h"

static NSMutableArray * ReviewersList;
static JakenpoyHTTPClient * client;

NSIndexPath * SelectedIndex;

@interface MyReviewersViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ReportsButton;
@property (weak, nonatomic) IBOutlet UIButton *PrintButton;
@property (weak, nonatomic) IBOutlet UIButton *RepublishButton;
@property (weak, nonatomic) IBOutlet UITableView *Table;
@end

@implementation MyReviewersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    ReviewersList = [[NSMutableArray alloc] init];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getMyReviewers];
    
    // Do any additional setup after loading the view from its nib.
    /*[self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];*/
    //[self.ReportsButton.layer setBorderWidth:1.0];
    
    // Add underlined titles
    NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"REPORTS"];
    [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
    [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
    [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *printUlString = [[NSMutableAttributedString alloc] initWithString:@"PRINT"];
    [printUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [printUlString length])];
    [printUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [printUlString length])];
    [self.PrintButton setAttributedTitle:printUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"PUBLISH"];
    [republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
    [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
    [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBaction
- (IBAction)publish
{
    Reviewer * reviewer = ReviewersList[SelectedIndex.row];
    
    if (self.RepublishButton.tag==1) {
        [client publish:reviewer.ID];
    }
    else {
        [client unpublish:reviewer.ID];
    }
}

- (IBAction)edit
{
    if ([self.ReportsButton.titleLabel.text isEqualToString:@"EDIT"]) {
        /*PRLFinishViewController * prlfvc = [[PRLFinishViewController alloc] initWithNibName:@"PRLFinishViewController" bundle:nil];
        [self.navigationController pushViewController:prlfvc animated:YES];
        
        Reviewer * reviewer = ReviewersList[SelectedIndex.row];
        Challenge * info = reviewer.Info;
        
        [prlfvc updateTitle:info.Title
               Instructions:info.Instruction
                     Expiry:info.Expiry
                       Code:info.Code
              ShareToPublic:info.ShareToPublic
              ShareToSchool:info.ShareToSchool
                ShowAnswers:info.ShowRightAnswers
             Classification:info.Classification
                   Assigned:nil];*/
    }
    else {
        // Do something for reports
    }
}

- (IBAction)print
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Printing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ReviewersList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"REVIEWCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"ReviewerCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    if (ReviewersList.count>0) {
        Reviewer * reviewer = ReviewersList[indexPath.row];
        Challenge * info = reviewer.Info;
        
        [cell.Title setText:info.Title];
        [cell.ExpirationDate setText:info.Expiry];
        [cell.Status setText:reviewer.isPublished?@"(1/1)":@"(0/1)"];
        [cell setIsGood:reviewer.isPublished];
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        [cell setExpDate:[format dateFromString:info.Expiry]];
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"challenges"];
        
        for (NSDictionary * reviewer in data) {
            Reviewer * item = [[Reviewer alloc] init];

            [item setID:[NSNumber numberWithInteger:[reviewer[@"id"] integerValue]]];
            [item setIsHidden:[reviewer[@"is_hidden"] boolValue]];
            [item setIsPublished:[reviewer[@"is_published"] boolValue]];
            [item setDeletable:[reviewer[@"can_be_deleted"] boolValue]];
            [item setInfo:[Challenge challengeWithInfo:reviewer[@"challenge_info"]]];
            
            [ReviewersList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"ReviewerCell" owner:self options:nil];
    ReviewerCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    [returnView.Title setText:@"Title"];
    [returnView.ExpirationDate setText:@"Exp."];
    [returnView.Status setText:@"Status"];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ReportsButton isHidden]) {
        [self.ReportsButton setHidden:NO];
        [self.PrintButton setHidden:NO];
        [self.RepublishButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
 
    ReviewerCell * cell = (ReviewerCell *)[tableView cellForRowAtIndexPath:SelectedIndex];
    
    // If cell is published
    if (cell.isGood) {
        NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"REPORTS"];
        [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
        [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
        [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
        [self.ReportsButton setBackgroundColor:[UIColor colorWithRed:0.86 green:0.39 blue:0.25 alpha:1]];
        
        // Date today is less than expiry
        if ([[NSDate date] compare:cell.ExpDate]==NSOrderedDescending) {
            NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"UNPUBLISH"];
            [republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
            [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
            [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
            [self.RepublishButton setTag:2];
        }
        // Date today is more than expiry
        else {
            NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"REPUBLISH"];
            [republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
            [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
            [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
            [self.RepublishButton setTag:1];
        }
    }
    // If cell is unpublished or has expired
    else {
        NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"EDIT"];
        [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
        [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [reportUlString length])];
        [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
        [self.ReportsButton setBackgroundColor:[UIColor whiteColor]];
        
        NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"PUBLISH"];
        [republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
        [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
        [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
        [self.RepublishButton setTag:1];
    }
}

@end
