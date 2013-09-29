//
//  HPFinishViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "HPFinishViewController.h"

static NSArray * SchoolList;
static NSInteger Selected;

@interface HPFinishViewController ()
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
@property (weak, nonatomic) IBOutlet UIToolbar *PickerToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UITextField *School;
@property (weak, nonatomic) IBOutlet UITextField *SchoolName;
@property (weak, nonatomic) IBOutlet UITextField *SchoolShortName;
@property (weak, nonatomic) IBOutlet UITextField *SchoolAddress;
@property (weak, nonatomic) IBOutlet UITextField *SchoolContact;
@end

@implementation HPFinishViewController

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
    [self.navigationItem setHidesBackButton:YES];
    
    Selected = 0;
    SchoolList = @[@"School 1", @"School 2", @"School 3", @"School 4", @"School 5"];
    
    [self.SchoolName setInputAccessoryView:self.Toolbar];
    [self.SchoolShortName setInputAccessoryView:self.Toolbar];
    [self.SchoolAddress setInputAccessoryView:self.Toolbar];
    [self.SchoolContact setInputAccessoryView:self.Toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method
- (void) revertPageState
{
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:YES];
    
    [self scrollPageToPoint:ViewCenter.y];
}

- (void) scrollPageToPoint:(CGFloat)y
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setCenter:CGPointMake(ViewCenter.x, y)];
    }];
}

#pragma mark - IBActions
#pragma mark UIButton
- (IBAction) finish
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UIPicker
- (IBAction)dropDown
{
    [self.Picker setHidden:NO];
    [self.PickerToolbar setHidden:NO];
}

- (IBAction)done
{
    [self.Picker setHidden:YES];
    [self.PickerToolbar setHidden:YES];
    [self.School setText:SchoolList[Selected]];
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    if ([self.SchoolContact isFirstResponder]) {
        [self scrollPageToPoint:0];
        
        [self.SchoolContact resignFirstResponder];
        [self.SchoolAddress becomeFirstResponder];
        [self.NextButton setEnabled:YES];
    }
    else if ([self.SchoolAddress isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.SchoolAddress resignFirstResponder];
        [self.SchoolShortName becomeFirstResponder];
    }
    else if ([self.SchoolShortName isFirstResponder]) {
        [self scrollPageToPoint:ViewCenter.y];
        
        [self.SchoolShortName resignFirstResponder];
        [self.SchoolName becomeFirstResponder];
        [self.PreviousButton setEnabled:NO];
    }
}

- (IBAction)jumpToNext
{
    if ([self.SchoolName isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.SchoolName resignFirstResponder];
        [self.SchoolShortName becomeFirstResponder];
        [self.PreviousButton setEnabled:YES];
    }
    else if ([self.SchoolShortName isFirstResponder]) {
        [self scrollPageToPoint:0];
        
        [self.SchoolShortName resignFirstResponder];
        [self.SchoolAddress becomeFirstResponder];
    }
    else if ([self.SchoolAddress isFirstResponder]) {
        [self.SchoolAddress resignFirstResponder];
        [self.SchoolContact becomeFirstResponder];
        [self.NextButton setEnabled:NO];
    }
}

- (IBAction)close
{
    if ([self.SchoolName isFirstResponder]) {
        [self.SchoolName resignFirstResponder];
    }
    else if ([self.SchoolShortName isFirstResponder]) {
        [self.SchoolShortName resignFirstResponder];
    }
    else if ([self.SchoolAddress isFirstResponder]) {
        [self.SchoolAddress resignFirstResponder];
    }
    else {
        [self.SchoolContact resignFirstResponder];
    }
    
    [self revertPageState];
}

#pragma mark - Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return SchoolList.count;
}

#pragma mark - Delegate
#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return SchoolList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Selected = row;
}

#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self revertPageState];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.SchoolShortName) {
        [self scrollPageToPoint:80];
    }
    else if (textField==self.SchoolAddress || textField==self.SchoolContact) {
        [self scrollPageToPoint:0];
    }
    
    if (textField == self.SchoolName) {
        [self.PreviousButton setEnabled:NO];
    }
    else if (textField == self.SchoolContact) {
        [self.NextButton setEnabled:NO];
    }
}

@end
