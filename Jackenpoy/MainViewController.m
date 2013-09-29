//
//  ViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/12/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MainViewController.h"
#import "MyReviewersViewController.h"
#import "TDMenuViewController.h"

static CGFloat ScreenHeight;
static CGFloat ScreenWidth;

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UILabel *ScreenLabel;
@property (weak, nonatomic) IBOutlet UIView *DisplayView;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    ScreenHeight    = [UIScreen mainScreen].bounds.size.height;
    ScreenWidth     = [UIScreen mainScreen].bounds.size.width;
    
    [self.Scroller setContentSize:CGSizeMake(564, ScreenHeight)];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)back
{
    [self.BackButton setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.DisplayView setFrame:CGRectMake(0, 0, 320, 480)];
    }];
}

- (IBAction)showMenu
{
    [self.BackButton setUserInteractionEnabled:YES];
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.DisplayView setFrame:CGRectMake(245, 0, 320, 480)];
    }];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    UIView * highlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    [highlight setBackgroundColor:[UIColor blackColor]];
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"HEADER"];
            [cell setUserInteractionEnabled:NO];
            break;
        case 1:
            [cell.textLabel setText:@"My Reviewers"];
            break;
        case 2:
            [cell.textLabel setText:@"Pick a Reviewer from the Library"];
            break;
        case 3:
            [cell.textLabel setText:@"Teacher's Desk"];
            break;
        case 4:
            [cell.textLabel setText:@"Make a Reviewer from Scratch"];
            break;
        case 5:
            [cell.textLabel setText:@"Randomizer"];
            break;
        case 6:
            [cell.textLabel setText:@"Manage/Register My Kids"];
            break;
        case 7:
            [cell.textLabel setText:@"My Account"];
            break;
        case 8:
            [cell.textLabel setText:@"Tutorials"];
            break;
        case 9:
            [cell.textLabel setText:@"About Us/Contact Us"];
            break;
        case 10:
            [cell.textLabel setText:@"Log Out"];
            break;
        default:
            break;
    }
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:7]];
    [cell setSelectedBackgroundView:highlight];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat returnHeight=0;
    
    switch (indexPath.row) {
        case 0:
            returnHeight = [UIScreen mainScreen].bounds.size.height - 430;
            break;
        default:
            returnHeight = 43;
            break;
    }
    
    return returnHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController * newPage;
    
    switch (indexPath.row) {
        case 1:
            [self.ScreenLabel setText:@"My Reviewers"];
            newPage = [[MyReviewersViewController alloc] initWithNibName:@"MyReviewersViewController" bundle:nil];
            break;
        case 2:
            [self.ScreenLabel setText:@"Pick a Reviewer from the Library"];
            break;
        case 3:
            [self.ScreenLabel setText:@"Teacher's Desk"];
            newPage = [[TDMenuViewController alloc] initWithNibName:@"TDMenuViewController" bundle:nil];
            break;
        case 4:
            [self.ScreenLabel setText:@"Make a Reviewer from Scratch"];
            break;
        case 5:
            [self.ScreenLabel setText:@"Randomizer"];
            break;
        case 6:
            [self.ScreenLabel setText:@"Manage/Register My Kids"];
            break;
        case 7:
            [self.ScreenLabel setText:@"My Account"];
            break;
        case 8:
            [self.ScreenLabel setText:@"Tutorials"];
            break;
        case 9:
            [self.ScreenLabel setText:@"About Us/Contact Us"];
            break;
        default:
            break;
    }

    [self.navigationController pushViewController:newPage animated:YES];
    [self back];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.89 blue:0.89 alpha:1]];
            break;
        case 1:
            [cell setBackgroundColor:[UIColor colorWithRed:0.25 green:0.66 blue:0.94 alpha:1]];
            break;
        case 2:
            [cell setBackgroundColor:[UIColor colorWithRed:0.75 green:0.2 blue:0.35 alpha:1]];
            break;
        case 3:
            [cell setBackgroundColor:[UIColor colorWithRed:0.24 green:0.35 blue:0.6 alpha:1]];
            break;
        case 4:
            [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.67 blue:0.1 alpha:1]];
            break;
        case 5:
            [cell setBackgroundColor:[UIColor colorWithRed:0.99 green:0.1 blue:0.63 alpha:1]];
            break;
        case 6:
            [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.64 blue:0.7 alpha:1]];
            break;
        case 7:
            [cell setBackgroundColor:[UIColor colorWithRed:1 green:0.79 blue:0.15 alpha:1]];
            break;
        case 8:
            [cell setBackgroundColor:[UIColor colorWithRed:0.86 green:0.39 blue:0.25 alpha:1]];
            break;
        case 9:
            [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.31 blue:0.1 alpha:1]];
            break;
        case 10:
            [cell setBackgroundColor:[UIColor colorWithRed:0.14 green:0.16 blue:0.16 alpha:1]];
            break;
        default:
            break;
    }
}
@end
