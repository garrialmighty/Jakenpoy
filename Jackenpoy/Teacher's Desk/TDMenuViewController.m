//
//  TDMenuViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDMenuViewController.h"
#import "TDSectionViewController.h"
#import "TDCourseViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)manageSections
{
    TDSectionViewController * tDSVC = [[TDSectionViewController alloc] initWithNibName:@"TDSectionViewController" bundle:nil];
    [self.navigationController pushViewController:tDSVC animated:YES];
}

- (IBAction)manageCourses
{
    TDCourseViewController * tDCVC = [[TDCourseViewController alloc] initWithNibName:@"TDCourseViewController" bundle:nil];
    [self.navigationController pushViewController:tDCVC animated:YES];
}

- (IBAction)manageTeachers
{
    
}

@end
