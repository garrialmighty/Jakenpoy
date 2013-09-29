//
//  TDSaveViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/15/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDSaveViewController.h"
#import "SVSegmentedControl.h"
#import "TDCheckboxCell.h"
#import "ReviewerCell.h"

static NSInteger Selected;
static NSArray * SubjectList;

@interface TDSaveViewController ()
@property (weak, nonatomic) IBOutlet UIView *Step1;
@property (weak, nonatomic) IBOutlet UIView *Step2;
@property (weak, nonatomic) IBOutlet UIView *Step3;
@property (weak, nonatomic) IBOutlet UIButton *Step1Button;
@property (weak, nonatomic) IBOutlet UIButton *Step2Button;
@property (weak, nonatomic) IBOutlet UIButton *Step3Button;
@property (weak, nonatomic) IBOutlet UIButton *NSButton;
@property (weak, nonatomic) IBOutlet UITableView *CheckboxTable;
@property (weak, nonatomic) IBOutlet UITextField *Title;

@end

@implementation TDSaveViewController

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
    
    Selected = 0;
    SubjectList = @[@"Subject 1", @"Subject 2", @"Subject 3", @"Subject 4", @"Subject 5"];
    
    SVSegmentedControl * jackenpoySC = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"Customize",@"Jackenpoy Default"]];
    [jackenpoySC setHeight:45];
    [jackenpoySC.thumb setTintColor:[UIColor colorWithRed:1 green:0.76 blue:0.57 alpha:1]];
    [jackenpoySC.thumb setTextColor:[UIColor blackColor]];
    
    [self.Step2 addSubview:jackenpoySC];
    
    [jackenpoySC setCenter:CGPointMake(160, 70)];
    
    NSMutableAttributedString * nextUlString = [[NSMutableAttributedString alloc] initWithString:@"NEXT"];
    [nextUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [nextUlString length])];
    [nextUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [nextUlString length])];
    [self.NSButton setAttributedTitle:nextUlString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (void)updateTitle:(NSString *)title
{
    [self.Title setText:title];
}

#pragma mark - IBAction
- (IBAction)showStep:(UIButton *)sender
{
    NSMutableAttributedString * NFUlString;
    [sender setEnabled:NO];
    
    if (sender.tag == 1) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"NEXT"];
        [self.NSButton setTag:1];
        [self.Step2Button setEnabled:YES];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step2];
        [self.view sendSubviewToBack:self.Step3];
    }
    else if (sender.tag == 2) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"NEXT"];
        [self.NSButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step3];
    }
    else {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"SAVE"];
        [self.NSButton setTag:3];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step2];
    }
    
    [NFUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [NFUlString length])];
    [NFUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [NFUlString length])];
    [self.NSButton setAttributedTitle:NFUlString forState:UIControlStateNormal];
}

- (IBAction)nextSave:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self.NSButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:NO];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step3];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"NEXT"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NSButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    else if (sender.tag == 2) {
        [self.NSButton setTag:3];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:YES];
        [self.Step3Button setEnabled:NO];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step2];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"SAVE"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NSButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    else {
        NSArray * vcStack = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcStack[1] animated:YES];
        
        for (NSIndexPath * ip in [self.CheckboxTable indexPathsForSelectedRows]) {
            //NSLog(@"%d",ip.row);
        }
    }
}

#pragma mark - Data Source
#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return SubjectList.count;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TDCheckboxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHECKBOXCELL"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHECKBOXCELL"];
    
    if (cell == nil) {
        //NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCheckboxCell" owner:self options:nil];
        //cell = topObj[0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CHECKBOXCELL"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //[cell.Section setText:[NSString stringWithFormat:@"Section %d",indexPath.row]];
    [cell.textLabel setText:[NSString stringWithFormat:@"Section %d",indexPath.row]];

    return cell;
}

#pragma mark - Delegate
#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return SubjectList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Selected = row;
}

#pragma mark UITableView
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @NO;
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @YES;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

@end
