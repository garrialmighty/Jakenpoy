//
//  HPFinishViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "HPFinishViewController.h"
#import "School.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * SchoolList;
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
@property (strong, nonatomic) NSString * Email;
@property (strong, nonatomic) NSString * Name;
@property (strong, nonatomic) NSString * Password;
@property (strong, nonatomic) NSString * Type;

@property (weak, nonatomic) IBOutlet UIView *LoadingScreen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
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
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getSchools];
    
    Selected = 0;
    SchoolList = [[NSMutableArray alloc] init];
    
    [self.SchoolName setInputAccessoryView:self.Toolbar];
    [self.SchoolShortName setInputAccessoryView:self.Toolbar];
    [self.SchoolAddress setInputAccessoryView:self.Toolbar];
    [self.SchoolContact setInputAccessoryView:self.Toolbar];
    
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

- (void)showLoadingScreen
{
    [self.LoadingScreen setHidden:NO];
    [self.Spinner startAnimating];
}

- (void)hideLoadingScreen
{
    [self.LoadingScreen setHidden:YES];
    [self.Spinner stopAnimating];
}

- (void)setEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password Type:(NSString *)type
{
    [self setEmail:email];
    [self setName:name];
    [self setPassword:password];
    [self setType:type];
}

#pragma mark - IBActions
#pragma mark UIButton
- (IBAction) finish
{
    [self showLoadingScreen];
    School * school = SchoolList[Selected];
    [client createAccountUsingEmail:self.Email Name:self.Name Password:self.Password Type:self.Type School:school.ID];
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
    
    School * school = SchoolList[Selected];
    [self.School setText:school.Name.length<=0?@"":school.Name];
    [self.SchoolName setText:school.Name.length<=0?@"":school.Name];
    [self.SchoolShortName setText:school.ShortName.length<=0?@"":school.ShortName];
    [self.SchoolAddress setText:school.Address.length<=0?@"":school.Address];
    [self.SchoolContact setText:school.ContactNumber?@"":school.ContactNumber];
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
#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClientdidCreateAccount:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        [self hideLoadingScreen];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Creating Account" message:json[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithSchools:(NSDictionary *)json
{
    //NSLog(@"%@",json);
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSDictionary * list = json[@"data"][@"schools"];
        
        for (NSDictionary * school in list) {
            School * item = [[School alloc] init];
            [item setID:[NSNumber numberWithInteger:[school[@"id"] integerValue]]];
            [item setName:school[@"name"]];
            [item setShortName:school[@"shortname"]];
            [item setAddress:school[@"address"]];
            [item setContactNumber:school[@"contact"]];

            [SchoolList addObject:item];
        }

        [self.Picker reloadAllComponents];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    [self hideLoadingScreen];
    NSLog(@"E:%@",error);
}
#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    School * school = SchoolList[row];
    return school.ShortName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Selected = row;
    
    if (!isPhone) {
        School * school = SchoolList[Selected];
        [self.School setText:school.Name.length<=0?@"":school.Name];
        [self.SchoolName setText:school.Name.length<=0?@"":school.Name];
        [self.SchoolShortName setText:school.ShortName.length<=0?@"":school.ShortName];
        [self.SchoolAddress setText:school.Address.length<=0?@"":school.Address];
        [self.SchoolContact setText:school.ContactNumber?@"":school.ContactNumber];
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
