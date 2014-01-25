//
//  TDLPSectionViewController.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 1/8/14.
//  Copyright (c) 2014 Garri Adrian Nablo. All rights reserved.
//

#import "TDLPSectionViewController.h"
#import "TDSectionCell.h"
#import "Section.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * SectionList;
static NSMutableArray * AllSectionList;
static NSNumber * LessonPlanID;
static NSIndexPath * SelectedIndex;

@interface TDLPSectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIView *AddSectionView;
@property (weak, nonatomic) IBOutlet UITableView *SectionTable;
@end

@implementation TDLPSectionViewController

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
    
    SectionList = [[NSMutableArray alloc] init];
    AllSectionList = [[NSMutableArray alloc] init];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"getting id %@",LessonPlanID);
    [client getSectionsForLessonPlan:LessonPlanID];
    [client getAvailableSections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method

- (void)setLessonPlanID:(NSNumber *)lpid
{
    LessonPlanID = lpid;
}

#pragma mark - IBActions
- (IBAction)addSection
{
    [self.AddSectionView setHidden:NO];
}

- (IBAction)done
{
    if (SelectedIndex) {
        Section * item = AllSectionList[SelectedIndex.row];
        [client addSection:item.ID ToLessonPlan:LessonPlanID];
        [self.AddSectionView setHidden:YES];
    }
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag==1?AllSectionList.count:SectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SECTIONCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDSectionCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    Section * section = tableView.tag==1?AllSectionList[indexPath.row]:SectionList[indexPath.row];
    
    [cell.ID setText:[section.ID stringValue]];
    [cell.GradeLevel setText:section.GradeLevel];
    [cell.Name setText:section.Name];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDSectionCell" owner:self options:nil];
    TDSectionCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor colorWithRed:0.83 green:0.86 blue:0.9 alpha:1]];
    [returnView.ID setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.Name setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.GradeLevel setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
        SelectedIndex = indexPath;
    }
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClientdidUpdateWithSections:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"available_sections"];
        [AllSectionList removeAllObjects];
        
        for (NSDictionary * section in data) {
            Section * item = [[Section alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[section[@"id"] integerValue]]];
            [item setGradeLevel:section[@"grade_level"]];
            [item setName:section[@"name"]];
            
            [AllSectionList addObject:item];
        }
        
        [self.SectionTable reloadData];
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithAddedSections:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        [client getSectionsForLessonPlan:LessonPlanID];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"sections"];
        [SectionList removeAllObjects];
        
        for (NSDictionary * section in data) {
            Section * item = [[Section alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[section[@"id"] integerValue]]];
            [item setGradeLevel:section[@"grade_level"]];
            [item setName:section[@"name"]];
            
            [SectionList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
