//
//  MRMKRegisterViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRMKRegisterViewController.h"

static JakenpoyHTTPClient * client;

static NSDictionary * GradeLevels;

static NSInteger Selected;
static NSMutableArray * GradeLevelList;
static NSArray * SchoolList;
static NSArray * SectionList;
static BOOL isGradeLevel;
static BOOL isSchool;
static BOOL isSection;

static NSInteger GradeLevelSelected;
static NSInteger SchoolSelected;
static NSInteger SectionSelected;

@interface MRMKRegisterViewController ()
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *FirstName;
@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *Username;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *Confirm;
@property (weak, nonatomic) IBOutlet UITextField *School;
@property (weak, nonatomic) IBOutlet UITextField *GradeLevel;
@property (weak, nonatomic) IBOutlet UITextField *Section;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
@property (weak, nonatomic) IBOutlet UIToolbar *PickerToolbar;
@property (weak, nonatomic) IBOutlet UIButton *BoyButton;
@property (weak, nonatomic) IBOutlet UIButton *GirlButton;

@end

@implementation MRMKRegisterViewController

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
    
    GradeLevelList = [NSMutableArray arrayWithArray:@[@"Grade Level 1", @"Grade Level 2", @"Grade Level 3", @"Grade Level 4", @"Grade Level 5"]];
    SchoolList = @[@"School 1", @"School 2", @"School 3", @"School 4", @"School 5"];
    SectionList = @[@"Section 1", @"Section 2", @"Section 3"];
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.18 green:0.53 blue:0.94 alpha:1] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.BoyButton setBackgroundImage:image forState:UIControlStateDisabled];
    [self.GirlButton setBackgroundImage:image forState:UIControlStateDisabled];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    [self.Email setInputAccessoryView:self.Toolbar];
    [self.FirstName setInputAccessoryView:self.Toolbar];
    [self.LastName setInputAccessoryView:self.Toolbar];
    [self.Username setInputAccessoryView:self.Toolbar];
    [self.Password setInputAccessoryView:self.Toolbar];
    [self.Confirm setInputAccessoryView:self.Toolbar];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
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

#pragma mark - IBAction
- (IBAction)toggleGender:(UIButton *)sender
{
    [sender setEnabled:NO];
    
    if (sender.tag==1) {
        [self.GirlButton setEnabled:YES];
    }
    else {
        [self.BoyButton setEnabled:YES];
    }
}

#pragma mark UIPicker
- (IBAction)dropDown:(UIButton *)sender
{
    [self.Picker setHidden:NO];
    [self.PickerToolbar setHidden:NO];
    [self close];
    
    isGradeLevel = NO;
    isSchool = NO;
    isSection = NO;
    
    switch (sender.tag) {
        case 1:
            isSchool = YES;
            break;
        case 2:
            isGradeLevel = YES;
            break;
        case 3:
            isSection = YES;
            break;
        default:
            break;
    };
    
    [self.Picker reloadAllComponents];
    
    // Check if drop down list count is less than current selected row
    if (isGradeLevel && GradeLevelList.count>0) {
        Selected = GradeLevelList.count<=Selected ? GradeLevelList.count-1:Selected;
    }
    else if (isSchool && SchoolList.count>0) {
        Selected = SchoolList.count<=Selected ? SchoolList.count-1:Selected;
    }
    else if (isSection && SectionList.count>0) {
        Selected = SectionList.count<=Selected ? SectionList.count-1:Selected;
    }
    
    if ((isGradeLevel&&GradeLevelList.count>0) || (isSchool&&SchoolList.count>0) || (isSection&&SectionList.count>0)) {
        [self.Picker selectRow:Selected inComponent:0 animated:NO];
    }
}

- (IBAction)done
{
    [self.Picker setHidden:YES];
    [self.PickerToolbar setHidden:YES];
    
    if (isGradeLevel) {
        GradeLevelSelected = Selected;
        [self.GradeLevel setText:GradeLevelList[Selected]];
    }
    else if (isSchool) {
        SchoolSelected = Selected;
        [self.School setText:SchoolList[Selected]];
    }
    else {
        SectionSelected = Selected;
        [self.Section setText:SectionList[Selected]];
    }
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    if ([self.Confirm isFirstResponder]) {
        [self.Confirm resignFirstResponder];
        [self.Password becomeFirstResponder];
        [self.NextButton setEnabled:YES];
    }
    else if ([self.Password isFirstResponder]) {
        [self.Password resignFirstResponder];
        [self.Username becomeFirstResponder];
    }
    else if ([self.Username isFirstResponder]) {
        [self.Username resignFirstResponder];
        [self.LastName becomeFirstResponder];
    }
    else if ([self.LastName isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.LastName resignFirstResponder];
        [self.FirstName becomeFirstResponder];
    }
    else if ([self.FirstName isFirstResponder]) {
        [self scrollPageToPoint:ViewCenter.y];
        
        [self.FirstName resignFirstResponder];
        [self.Email becomeFirstResponder];
        [self.PreviousButton setEnabled:NO];
    }
}

- (IBAction)jumpToNext
{
    if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
        [self.FirstName becomeFirstResponder];
        [self.PreviousButton setEnabled:YES];
    }
    else if ([self.FirstName isFirstResponder]) {
        [self.FirstName resignFirstResponder];
        [self.LastName becomeFirstResponder];
    }
    else if ([self.LastName isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.LastName resignFirstResponder];
        [self.Username becomeFirstResponder];
    }
    else if ([self.Username isFirstResponder]) {
        [self scrollPageToPoint:0];
        
        [self.Username resignFirstResponder];
        [self.Password becomeFirstResponder];
    }
    else if ([self.Password isFirstResponder]) {
        [self.Password resignFirstResponder];
        [self.Confirm becomeFirstResponder];
        [self.NextButton setEnabled:NO];
    }
}

- (IBAction)close
{
    if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
    }
    else if ([self.FirstName isFirstResponder]) {
        [self.FirstName resignFirstResponder];
    }
    else if ([self.LastName isFirstResponder]) {
        [self.LastName resignFirstResponder];
    }
    else if ([self.Username isFirstResponder]) {
        [self.LastName resignFirstResponder];
    }
    else if ([self.Password isFirstResponder]) {
        NSLog(@"password");
        [self.Password resignFirstResponder];
    }
    else {
        NSLog(@"confirm");
        [self.Confirm resignFirstResponder];
    }
    
    [self revertPageState];
}

#pragma mark - Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return isPhone?1:3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger returnRow;
    
    if (isPhone) {
        returnRow = isGradeLevel?GradeLevelList.count:isSchool?SchoolList.count:SectionList.count;
    }
    else {
        returnRow = component==0?GradeLevelList.count:component==1?SchoolList.count:SectionList.count;
    }
    
    return returnRow;
}

#pragma mark - Delegate
#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * rowString;
    
    if (isPhone) {
        rowString = isGradeLevel?GradeLevelList[row]:isSchool?SchoolList[row]:SectionList[row];
    }
    else {
        rowString = component==0?GradeLevelList[row]:component==1?SchoolList[row]:SectionList[row];
    }
    
    return rowString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isPhone) {
        Selected = row;
    }
    else {
        switch (component) {
            case 0:
                GradeLevelSelected = row;
                break;
            case 1:
                SchoolSelected = row;
                break;
            case 2:
                SectionSelected = row;
                break;
            default:
                break;
        }
    }
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
    if (textField==self.Email || textField==self.FirstName) {
        [self scrollPageToPoint:ViewCenter.y];
    }
    else if (textField==self.LastName) {
        [self scrollPageToPoint:80];
    }
    else if (textField==self.Username || textField==self.Password || textField==self.Confirm) {
        [self scrollPageToPoint:0];
    }
    
    if (textField == self.Email) {
        [self.PreviousButton setEnabled:NO];
    }
    else if (textField == self.Confirm) {
        [self.NextButton setEnabled:NO];
    }
    
    if (![self.Picker isHidden]) {
        [self done];
    }
}

@end
