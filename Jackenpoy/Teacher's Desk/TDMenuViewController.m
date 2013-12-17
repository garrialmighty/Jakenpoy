//
//  TDMenuViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDMenuViewController.h"
#import "TDSectionViewController.h"
#import "TDLessonPlanViewController.h"
#import "TDTeacherViewController.h"

@interface TDMenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ManageTeachersButton;
@end

@implementation TDMenuViewController

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
    [self.navigationItem setHidesBackButton:YES];
    
    UserType * type = [JakenpoyHTTPClient getSharedClient].Type;
    if (!type.Admin) {
        [self.ManageTeachersButton setHidden:YES];
    }
    
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

#pragma mark - IBActions
- (IBAction)manageSections
{
    TDSectionViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSectionViewController alloc] initWithNibName:@"TDSectionViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSectionViewController alloc] initWithNibName:@"TDSectionViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];
}

- (IBAction)manageCourses
{
    TDLessonPlanViewController * tDCVC;
    
    if (isPhone) {
        tDCVC = [[TDLessonPlanViewController alloc] initWithNibName:@"TDLessonPlanViewController" bundle:nil];
    }
    else {
        tDCVC = [[TDLessonPlanViewController alloc] initWithNibName:@"TDLessonPlanViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDCVC animated:YES];
}

- (IBAction)manageTeachers
{
    TDTeacherViewController * tDTVC;
    
    if (isPhone) {
        tDTVC = [[TDTeacherViewController alloc] initWithNibName:@"TDTeacherViewController" bundle:nil];
    }
    else {
        tDTVC = [[TDTeacherViewController alloc] initWithNibName:@"TDTeacherViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDTVC animated:YES];
}

@end
