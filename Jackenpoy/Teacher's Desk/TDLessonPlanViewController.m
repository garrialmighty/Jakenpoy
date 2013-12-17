//
//  TDCourseViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDLessonPlanViewController.h"
#import "TDLessonPlanCell.h"
#import "TDSaveViewController.h"
#import "LessonPlan.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * LessonPlanList;

NSIndexPath * SelectedIndex;

@interface TDLessonPlanViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ViewSectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *EditCourseButton;
@property (weak, nonatomic) IBOutlet UIButton *AddLessonPlanButton;
@property (weak, nonatomic) IBOutlet UITableView *Table;

@end

@implementation TDLessonPlanViewController

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
    [client getLessonPlans];
    
    LessonPlanList = [[NSMutableArray alloc] init];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)addCourse
{
    /*TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];*/
    
    [self.Table reloadData];
}

- (IBAction)editCourse
{
    TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];
    [tDSVC updateTitle:LessonPlanList[SelectedIndex.row]];
    
    if ([client isAdmin]) {
        [tDSVC updateViewForAdmin];
    }
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return LessonPlanList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDLessonPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COURSECELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDLessonPlanCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    LessonPlan * item = LessonPlanList[indexPath.row];
    
    [cell.CourseTitle setText:item.Name];
    
    return cell;
}

#pragma mark - Delegate
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDLessonPlanCell" owner:self options:nil];
    TDLessonPlanCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor colorWithRed:0.83 green:0.86 blue:0.9 alpha:1]];
    [returnView.CourseTitle setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ViewSectionsButton isHidden]) {
        [self.ViewSectionsButton setHidden:NO];
        [self.EditCourseButton setHidden:NO];
        [self.AddLessonPlanButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"courses"];
        [LessonPlanList removeAllObjects];
        
        for (NSDictionary * section in data) {
            LessonPlan * item = [[LessonPlan alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[section[@"id"] integerValue]]];
            [item setName:section[@"name"]];
            
            [LessonPlanList addObject:item];
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
