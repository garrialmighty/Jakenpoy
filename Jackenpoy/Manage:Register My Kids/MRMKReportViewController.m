//
//  MRMKReportViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/6/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRMKReportViewController.h"
#import "MRMKChildReportCell.h"
#import "KidReport.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * ReportList;
static NSNumber * KidID;

@interface MRMKReportViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@end

@implementation MRMKReportViewController

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
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    
    ReportList = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setKidID:(NSNumber *)ID
{
    KidID = ID;
    //[client kidReport:kid.ID];
    [client studentReport:KidID];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ReportList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRMKChildReportCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHILDREPORTCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRMKChildReportCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    KidReport * kid = ReportList[indexPath.row];
    
    [cell.Name setText:kid.Name];
    [cell.Description setText:kid.Description];
    [cell.Count setText:kid.Count];
    
    return cell;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json
{
    //NSLog(@"%@",json);
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"results"];
        
        for (NSDictionary * report in data) {
            KidReport * item = [[KidReport alloc] init];
            [item setName:report[@"name"]];
            [item setDescription:report[@"description"]];
            [item setCount:report[@"play_count"]];
            
            [ReportList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRMKChildReportCell" owner:self options:nil];
    MRMKChildReportCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    
    return returnView;
}

@end
