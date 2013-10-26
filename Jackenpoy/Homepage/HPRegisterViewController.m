//
//  HPRegisterViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "HPRegisterViewController.h"
#import "HPFinishViewController.h"

static NSArray * AccountTypeList;
static NSInteger Selected;

@interface HPRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *PickerToolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UITextField *AccountType;
@end

@implementation HPRegisterViewController

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
    
    ViewCenter = self.view.center;
    
    Selected = 0;
    AccountTypeList = @[@"Parent/Guardian", @"Teacher", @"Both Parent/Guardian & Teacher"];
    
    [self.navigationItem setHidesBackButton:YES];
    NSMutableAttributedString *loginString = [[NSMutableAttributedString alloc] initWithString:@"Log-In"];
    [loginString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [loginString length])];
    [loginString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.18 green:0.53 blue:0.94 alpha:1] range:NSMakeRange(0, [loginString length])];
    [self.LogInButton setAttributedTitle:loginString forState:UIControlStateNormal];
    
    [self.Email setInputAccessoryView:self.Toolbar];
    [self.Name setInputAccessoryView:self.Toolbar];
    [self.Password setInputAccessoryView:self.Toolbar];
    
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
    if (isPhone) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.view setCenter:CGPointMake(ViewCenter.x, y)];
        }];
    }
}

#pragma mark - IBActions
#pragma mark UIButton
- (IBAction) registerUser
{
    if (self.Email.text.length<=0 || self.Name.text.length<=0 || self.Password.text.length<=0 || (isPhone&&self.AccountType.text.length<=0)) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill out all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        HPFinishViewController * hpfvc;
        
        if (isPhone) {
            hpfvc = [[HPFinishViewController alloc] initWithNibName:@"HPFinishViewController" bundle:nil];
        }
        else {
            hpfvc = [[HPFinishViewController alloc] initWithNibName:@"HPFinishViewController_iPad" bundle:nil];
        }
        
        [self.navigationController pushViewController:hpfvc animated:YES];
        
        [hpfvc setEmail:self.Email.text Name:self.Name.text Password:self.Password.text Type:Selected==0?@"guardian":Selected==1?@"teacher":@"both"];
    }
}

- (IBAction)login
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.AccountType setText:AccountTypeList[Selected]];
}


#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    if ([self.Password isFirstResponder]) {
        [self scrollPageToPoint:ViewCenter.y];
        
        [self.Password resignFirstResponder];
        [self.Name becomeFirstResponder];
        [self.NextButton setEnabled:YES];
    }
    else if ([self.Name isFirstResponder]) {
        [self.Name resignFirstResponder];
        [self.Email becomeFirstResponder];
        [self.PreviousButton setEnabled:NO];
    }
}

- (IBAction)jumpToNext
{
    if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
        [self.Name becomeFirstResponder];
        [self.PreviousButton setEnabled:YES];
    }
    else if ([self.Name isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.Name resignFirstResponder];
        [self.Password becomeFirstResponder];
        [self.NextButton setEnabled:NO];
    }
}

- (IBAction)close
{
    if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
    }
    else if ([self.Name isFirstResponder]) {
        [self.Name resignFirstResponder];
    }
    else {
        [self.Password resignFirstResponder];
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
    return AccountTypeList.count;
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
}

#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return AccountTypeList[row];
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
    if (textField == self.Email) {
        [self.PreviousButton setEnabled:NO];
    }
    else if (textField == self.Password) {
        [self scrollPageToPoint:80];
        [self.NextButton setEnabled:NO];
    }
}

@end
