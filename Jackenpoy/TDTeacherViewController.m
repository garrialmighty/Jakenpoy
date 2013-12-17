//
//  TDTeacherViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/10/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDTeacherViewController.h"
#import "TDTeacherCell.h"
#import "Teacher.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * TeacherList;
static NSIndexPath *SelectedIndex;

@interface TDTeacherViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIButton *RemoveButton;

@end

@implementation TDTeacherViewController

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
	// Do any additional setup after loading the view.
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getTeachers];
    
    TeacherList = [[NSMutableArray alloc] init];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)removeTeacher
{
    
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TeacherList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDTeacherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TEACHERCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDTeacherCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    if (TeacherList.count>0) {
        Teacher * item = TeacherList[indexPath.row];
        
        [cell.Name setText:item.Name];
        [cell.Email setText:item.Email];
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDTeacherCell" owner:self options:nil];
    TDTeacherCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor colorWithRed:0.83 green:0.86 blue:0.9 alpha:1]];
    [returnView.Email setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.Name setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.RemoveButton isHidden]) {
        [self.RemoveButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    
}

-(void)jakenpoyHTTPClientdidUpdateWithTeachers:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"teachers"];
        [TeacherList removeAllObjects];
        
        for (NSDictionary * teacher in data) {
            Teacher * item = [[Teacher alloc] init];
            
            [item setIsAdmin:[teacher[@"is_admin"] boolValue]];
            [item setID:[NSNumber numberWithInteger:[teacher[@"id"] integerValue]]];
            [item setSchoolID:[NSNumber numberWithInteger:[teacher[@"school_id"] integerValue]]];
            [item setEmail:teacher[@"email"]];
            [item setName:teacher[@"name"]];
            
            [TeacherList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    [[[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
