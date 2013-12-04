//
//  TDCourseViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDCourseViewController.h"
#import "TDCourseCell.h"
#import "TDSaveViewController.h"

static NSArray * LessonPlanList;

NSIndexPath * SelectedIndex;

@interface TDCourseViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ViewSectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *EditCourseButton;

@end

@implementation TDCourseViewController

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
    
    LessonPlanList = @[@"Sample Course Title 1", @"Sample Course Title 2", @"Sample Course Title 3", @"Sample Course Title 4", @"Sample Course Title 5"];
    
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
    TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];
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
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return LessonPlanList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDCourseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COURSECELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCourseCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    [cell.CourseTitle setText:LessonPlanList[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCourseCell" owner:self options:nil];
    TDCourseCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    [returnView.CourseTitle setText:@"Lesson Plan Title"];
    [returnView.TopicButton setHidden:YES];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ViewSectionsButton isHidden]) {
        [self.ViewSectionsButton setHidden:NO];
        [self.EditCourseButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

@end
