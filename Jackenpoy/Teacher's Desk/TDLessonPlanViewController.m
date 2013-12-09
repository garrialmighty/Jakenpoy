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

static JakenpoyHTTPClient * client;
static NSMutableArray * LessonPlanList;

NSIndexPath * SelectedIndex;

@interface TDLessonPlanViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ViewSectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *EditCourseButton;

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
    TDLessonPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"COURSECELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCourseCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    [cell.CourseTitle setText:LessonPlanList[indexPath.row]];
    
    return cell;
}

#pragma mark - Delegate
#pragma mark UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDLessonPlanCell" owner:self options:nil];
    TDLessonPlanCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    
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

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    NSLog(@"%@",json);
    /*if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"available_sections"];
        
        for (NSDictionary * section in data) {
            Section * item = [[Section alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[section[@"id"] integerValue]]];
            [item setGradeLevel:section[@"grade_level"]];
            [item setName:section[@"name"]];
            
            [SectionList addObject:item];
        }
        
        [self.Table reloadData];
    }*/
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    [[[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

@end
