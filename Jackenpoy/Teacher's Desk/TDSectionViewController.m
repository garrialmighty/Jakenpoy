//
//  TDSectionViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDSectionViewController.h"
#import "TDSectionCell.h"

NSIndexPath * SelectedIndex;

@interface TDSectionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *EditSectionButton;
@property (weak, nonatomic) IBOutlet UIButton *ViewStudentsButton;

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
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"Edit Section"];
    [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
    [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
    [self.EditSectionButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *printUlString = [[NSMutableAttributedString alloc] initWithString:@"View Students"];
    [printUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [printUlString length])];
    [printUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [printUlString length])];
    [self.ViewStudentsButton setAttributedTitle:printUlString forState:UIControlStateNormal];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDSectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SECTIONCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDSectionCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    [cell.Section setText:[NSString stringWithFormat:@"Sample Section %d",indexPath.row]];
    [cell.Grade setText:@"AB"];
    [cell.Teacher setText:@"Prof. Ession Al"];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDSectionCell" owner:self options:nil];
    TDSectionCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    [returnView.Section setText:@"Section"];
    [returnView.Grade setText:@"Grade"];
    [returnView.Teacher setText:@"Teacher"];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ViewStudentsButton isHidden]) {
        [self.ViewStudentsButton setHidden:NO];
        [self.EditSectionButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
}

@end
