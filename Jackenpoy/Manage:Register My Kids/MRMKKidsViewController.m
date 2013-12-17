//
//  MRMKKidsViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRMKKidsViewController.h"
#import "MRMKRegisterViewController.h"
#import "MRMKReportViewController.h"
#import "MRMKChildCell.h"
#import "Student.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * StudentList;
NSIndexPath * SelectedIndex;

@interface MRMKKidsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *ReportsButton;
@property (weak, nonatomic) IBOutlet UIButton *DeactivateButton;
@end

@implementation MRMKKidsViewController

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
    
    StudentList = [[NSMutableArray alloc] init];
    
    [self.navigationItem setHidesBackButton:YES];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getManageKids];
    
    UserType * type = client.Type;
    if (!type.Guardian) {
        [self.RegisterButton setHidden:YES];
    }
    
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [jakenpoyAppDelegate hideBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)registerChild
{
    MRMKRegisterViewController * mrmkrvc;
    
    if (isPhone) {
        mrmkrvc = [[MRMKRegisterViewController alloc] initWithNibName:@"MRMKRegisterViewController" bundle:nil];
    }
    else {
        mrmkrvc = [[MRMKRegisterViewController alloc] initWithNibName:@"MRMKRegisterViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:mrmkrvc animated:YES];
}

- (IBAction)deactivateAccount
{
    Student * kid = StudentList[SelectedIndex.row];
    [client deactivateGuardian:kid.ID];
}

- (IBAction)report
{
    Student * kid = StudentList[SelectedIndex.row];
    
    MRMKReportViewController * mrmkrvc;
    
    if (isPhone) {
        mrmkrvc = [[MRMKReportViewController alloc] initWithNibName:@"MRMKReportViewController" bundle:nil];
    }
    else {
        mrmkrvc = [[MRMKReportViewController alloc] initWithNibName:@"MRMKReportViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:mrmkrvc animated:YES];
    
    [mrmkrvc setKidID:kid.ID];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return StudentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRMKChildCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHILDCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRMKChildCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    Student * kid = StudentList[indexPath.row];
    
    [cell.Name setText:[NSString stringWithFormat:@"%@ %@",kid.FirstName, kid.LastName]];
    [cell.Status setText:kid.isGuardianActive?@"Activated":@"Deactivated"];
    
    return cell;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient
- (void)jakenpoyHTTPClientdidUpdateWithKids:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"student_accounts"];
        [StudentList removeAllObjects];
        
        for (NSDictionary * student in data) {
            Student * item = [[Student alloc] init];
            [item setID:[NSNumber numberWithInteger:[student[@"id"] integerValue]]];
            [item setFirstName:student[@"firstname"]];
            [item setLastName:student[@"lastname"]];
            [item setIsGuardianActive:[student[@"guardian_status"] isEqualToString:@"active"]];

            [StudentList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json
{
    //NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
}

#pragma mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRMKChildCell" owner:self options:nil];
    MRMKChildCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor colorWithRed:0.83 green:0.86 blue:0.9 alpha:1]];
    [returnView.Name setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.Status setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ReportsButton isHidden]) {
        [self.ReportsButton setHidden:NO];
        [self.DeactivateButton setHidden:NO];
        [self.RegisterButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

@end
