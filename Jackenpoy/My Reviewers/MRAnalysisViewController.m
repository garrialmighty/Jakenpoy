//
//  MRAnalysisViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/5/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRAnalysisViewController.h"
#import "MRReportViewController.h"
#import "MRAnalysisCell.h"
#import "ReviewerStudent.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * StudentList;

static NSNumber * reviewerID;
@interface MRAnalysisViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;

@end

@implementation MRAnalysisViewController

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
    // Do any additional setup after loading the view from its nib.
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getAnalysisForReviewer:reviewerID];
    
    StudentList = [[NSMutableArray alloc] init];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setReviewerID:(NSNumber *)rid
{
    reviewerID = rid;
}

- (IBAction)viewAnalysis
{
    MRReportViewController * mrrvc;
    
    if (isPhone) {
        mrrvc = [[MRReportViewController alloc] initWithNibName:@"MRReportViewController" bundle:nil];
    }
    else {
        mrrvc = [[MRReportViewController alloc] initWithNibName:@"MRReportViewController_iPad" bundle:nil];
    }
    
    [mrrvc setReviewerID:reviewerID];
    
    [self.navigationController pushViewController:mrrvc animated:YES];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return StudentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRAnalysisCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ANALYSISCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRAnalysisCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    if (StudentList.count>0) {
        ReviewerStudent * item = StudentList[indexPath.row];
        
        [cell.Name setText:item.Name];
        [cell.Score setText:[NSString stringWithFormat:@"%@/%@",item.Correct, item.Total]];
        [cell.Percentage setText:item.Percent];
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        for (NSDictionary * student in json[@"data"]) {
            ReviewerStudent * item = [[ReviewerStudent alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[student[@"id"] integerValue]]];
            [item setName:student[@"name"]];
            [item setCorrect:student[@"correct"]];
            [item setPercent:[NSString stringWithFormat:@"%0.02f%%",[student[@"percent"] floatValue]]];
            [item setTotal:student[@"total"]];
            
            [StudentList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Generating Analysis" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRAnalysisCell" owner:self options:nil];
    MRAnalysisCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    
    return returnView;
}


@end
