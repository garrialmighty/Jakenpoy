//
//  TDCourseViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDLessonPlanViewController.h"
#import "TDLPSectionViewController.h"
#import "TDLessonPlanCell.h"
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
    
    LessonPlanList = [[NSMutableArray alloc] init];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [client getLessonPlans];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)editCourse
{
    LessonPlan * item = LessonPlanList[SelectedIndex.row];
    [client getLessonPlan:item.ID];
}

- (IBAction)viewSections
{
    TDLPSectionViewController * tDLPSVC;
    
    if (isPhone) {
        tDLPSVC = [[TDLPSectionViewController alloc] initWithNibName:@"TDLPSectionViewController" bundle:nil];
    }
    else {
        tDLPSVC = [[TDLPSectionViewController alloc] initWithNibName:@"TDLPSectionViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDLPSVC animated:YES];
    
    LessonPlan * item = LessonPlanList[SelectedIndex.row];
    [tDLPSVC setLessonPlanID:item.ID];
}

- (IBAction)addCourse
{
    TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];
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

#pragma mark TDSaveViewControllerDelegate
-(void)tdDSaveViewControllerDelegateDidSave
{
    NSLog(@"delegate called");
    [client getLessonPlans];
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClientdidUpdateWithLessonPlan:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSDictionary * data = json[@"data"][@"course"];
        LessonPlan * item = [[LessonPlan alloc] init];

        [item setID:[NSNumber numberWithInteger:[data[@"id"] integerValue]]];
        [item setName:data[@"name"]];
        [item setSubjectID:data[@"subject_id"]];
        [item setTeacherID:data[@"teacher_id"]];
        
        TDSaveViewController * tDSVC;
        
        if (isPhone) {
            tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
        }
        else {
            tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:tDSVC animated:YES];
        [tDSVC setDelegate:self];
        [tDSVC setToEdit];
        [tDSVC updateTitle:item.Name Subject:item.SubjectID Teacher:item.TeacherID LessonPlan:item.ID];
        
        if ([client isAdmin]) {
            [tDSVC updateViewForAdmin];
        }

    }    
}

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
