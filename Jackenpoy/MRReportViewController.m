//
//  MRReportViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/13/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRReportViewController.h"
#import "MRReportCell.h"
#import "ReviewerReport.h"
#import "Question.h"

static NSNumber * reviewerID;
static ReviewerReport * Report;
static JakenpoyHTTPClient * client;

@interface MRReportViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@end

@implementation MRReportViewController

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
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getReportForReviewer:reviewerID];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Report.Questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"REPORTCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRReportCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    if (Report.Questions.count>0) {
        Question * item = Report.Questions[indexPath.row];
        
        [cell.Number setText:[NSString stringWithFormat:@"%d",indexPath.row+1]];
        [cell.Question setText:item.Question];
        [cell.Right setText:item.Right];
        [cell.Wrong setText:item.Wrong];
        
        BOOL isRight = [Report.QuestionArray[indexPath.row] boolValue];
        
        if (isRight) {
            [cell.Result setText:@"Right"];
            [cell.Result setBackgroundColor:[UIColor colorWithRed:0.15 green:0.6 blue:0.22 alpha:1]];
        }
        else {
            [cell.Result setText:@"Wrong"];
            [cell.Result setBackgroundColor:[UIColor colorWithRed:0.62 green:0.06 blue:0 alpha:1]];
        }
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        Report = [[ReviewerReport alloc] init];
        
        NSArray * questions = json[@"data"][@"questions"];
        NSDictionary * wrongAnws = json[@"data"][@"wrong_answers"];
        NSDictionary * quesArray = json[@"data"][@"question_array"];
        
        NSMutableArray * questionList = [NSMutableArray arrayWithCapacity:[questions count]];
        NSMutableArray * wrongList = [NSMutableArray arrayWithCapacity:[wrongAnws count]];
        NSMutableArray * quesArrList = [NSMutableArray arrayWithCapacity:[quesArray count]];
        
        id totalStudents = json[@"data"][@"total_students"];
        [Report setTotalStudents:[NSNumber numberWithInteger:[totalStudents integerValue]]];
        
        [Report setRight:json[@"data"][@"questions_correct"]];
        
        // Convert JSON data to Question objects for easy access to data
        for (NSDictionary * qitem in questions) {
            Question * item = [[Question alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[qitem[@"id"] integerValue]]];
            [item setQuestion:qitem[@"text"]];
            [item setRight:qitem[@"right"]];
            [item setWrong:qitem[@"wrong"]];
            
            [questionList addObject:item];
        }
        
        [Report setQuestions:questionList];
        
        // Parse wrong answers and convert dictionary JSON to array
        for (uint i=0; i<wrongAnws.count; i++) {
            [wrongList addObject:wrongAnws[[NSString stringWithFormat:@"%d",i+1]]];
        }
        
        [Report setWrong:wrongList];
        
        for (uint i=0; i<quesArray.count; i++) {
            [quesArrList addObject:quesArray[[NSString stringWithFormat:@"%d",i+1]]];
        }
        
        [Report setQuestionArray:quesArrList];

        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Generating Report" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRReportCell" owner:self options:nil];
    MRReportCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    [returnView.Number setText:@"No."];
    [returnView.Question setText:@"Question"];
    [returnView.Right setText:@"Right"];
    [returnView.Wrong setText:@"Wrong"];
    [returnView.Result setText:@"Result"];
    
    return returnView;
}

@end
