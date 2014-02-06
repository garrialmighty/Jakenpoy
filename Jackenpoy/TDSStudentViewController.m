//
//  TDSStudentViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 1/22/14.
//  Copyright (c) 2014 Garri Adrian Nablo. All rights reserved.
//

#import "TDSStudentViewController.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * StudentList;
static NSNumber * SectionID;

@interface TDSStudentViewController ()

@end

@implementation TDSStudentViewController

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
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [client viewStudents:SectionID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (void)setSectionID:(NSNumber *)sid
{
    SectionID = sid;
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        //NSArray * data = json[@"data"][@"available_sections"];
        [StudentList removeAllObjects];
        
        /*for (NSDictionary * section in data) {
            Section * item = [[Section alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[section[@"id"] integerValue]]];
            [item setGradeLevel:section[@"grade_level"]];
            [item setName:section[@"name"]];
            
            [SectionList addObject:item];
        }*/
        
        //[self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
