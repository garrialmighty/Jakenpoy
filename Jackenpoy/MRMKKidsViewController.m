//
//  MRMKKidsViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRMKKidsViewController.h"
#import "MRMKChildCell.h"
#import "MRMKRegisterViewController.h"
#import "Student.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * StudentList;
NSIndexPath * SelectedIndex;

@interface MRMKKidsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIButton *RegisterButton;
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
    [client kidReport:kid.ID];
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
    NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"MRMKChildCell" owner:self options:nil];
    MRMKChildCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

@end
