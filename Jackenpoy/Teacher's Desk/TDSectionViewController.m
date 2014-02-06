//
//  TDSectionViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDSectionViewController.h"
#import "TDSStudentViewController.h"
#import "TDSectionCell.h"
#import "Section.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * SectionList;
NSIndexPath * SelectedIndex;

@interface TDSectionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *EditSectionButton;
@property (weak, nonatomic) IBOutlet UIButton *ViewStudentsButton;
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UIButton *AddButton;

@end

@implementation TDSectionViewController

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
    
    client = [JakenpoyHTTPClient getSharedClient];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    /*NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"Edit Section"];
    [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
    [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
    [self.EditSectionButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *printUlString = [[NSMutableAttributedString alloc] initWithString:@"View Students"];
    [printUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [printUlString length])];
    [printUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [printUlString length])];
    [self.ViewStudentsButton setAttributedTitle:printUlString forState:UIControlStateNormal];*/
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [client setDelegate:self];
    [client getAvailableSections];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -IBAction
- (IBAction)editSection
{
    TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    Section * section = SectionList[SelectedIndex.row];
    
    [self.navigationController pushViewController:tDSVC animated:YES];
    [tDSVC editSectionName:section.Name GradeLevel:section.GradeLevel WithID:section.ID];
}

- (IBAction)viewSection
{
    TDSStudentViewController * tDSSVC;
    
    if (isPhone) {
        tDSSVC = [[TDSStudentViewController alloc] initWithNibName:@"TDSStudentViewController" bundle:nil];
    }
    else {
        tDSSVC = [[TDSStudentViewController alloc] initWithNibName:@"TDSStudentViewController_iPad" bundle:nil];
    }
    
    Section * section = SectionList[SelectedIndex.row];
    [tDSSVC setSectionID:section.ID];
}

- (IBAction)addSection
{
    TDSaveViewController * tDSVC;
    
    if (isPhone) {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController" bundle:nil];
    }
    else {
        tDSVC = [[TDSaveViewController alloc] initWithNibName:@"TDSaveViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:tDSVC animated:YES];
    [tDSVC setToAddSection];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SECTIONCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDSectionCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    Section * section = SectionList[indexPath.row];
    
    [cell.ID setText:[section.ID stringValue]];
    [cell.GradeLevel setText:section.GradeLevel];
    [cell.Name setText:section.Name];
    
    return cell;
}

#pragma mark Delegate
#pragma mark UITableView Delegate
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
    if ([self.ViewStudentsButton isHidden]) {
        //[self.ViewStudentsButton setHidden:NO];
        [self.EditSectionButton setHidden:NO];
        [self.AddButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClientdidUpdateWithSections:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"available_sections"];
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

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
