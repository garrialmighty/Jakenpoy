//
//  HPLoginViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "HPLoginViewController.h"
#import "HPRegisterViewController.h"

@interface HPLoginViewController ()
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (weak, nonatomic) IBOutlet UIView *LandingPage;
@property (weak, nonatomic) IBOutlet UIButton *Checkbox;
@end

@implementation HPLoginViewController

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
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.Email setInputAccessoryView:self.Toolbar];
    [self.Password setInputAccessoryView:self.Toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
#pragma mark UIButton
- (IBAction) login
{
    if (self.Email.text.length==0 || self.Password.text.length==0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"Please fill out all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        JakenpoyHTTPClient * client = [JakenpoyHTTPClient getSharedClient];
        [client setDelegate:self];
        //[client loginWithUsername:self.Email.text Password:self.Password.text];
        [client loginWithUsername:@"beta.jakenpoy@gmail.com" Password:@"jakenpoy123"];
    }
}

- (IBAction) registerForFree
{
    HPRegisterViewController * hprvc = [[HPRegisterViewController alloc] initWithNibName:@"HPRegisterViewController" bundle:nil];
    [self.navigationController pushViewController:hprvc animated:YES];
}

- (IBAction) forgetPassword
{
    
}

- (IBAction)toggleCheckbox:(UIButton *)checkbox
{
    if (checkbox.tag == 0) {
        [checkbox setSelected:YES];
        [checkbox setTag:1];
    }
    else {
        [checkbox setSelected:NO];
        [checkbox setTag:0];
    }
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    [self.PreviousButton setEnabled:NO];
    [self.NextButton setEnabled:YES];
    
    [self.Password resignFirstResponder];
    [self.Email becomeFirstResponder];
}

- (IBAction)jumpToNext
{
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:NO];
    
    [self.Email resignFirstResponder];
    [self.Password becomeFirstResponder];
}

- (IBAction)close
{
    if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
    }
    else {
        [self.Password resignFirstResponder];
    }
    
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:YES];
}

#pragma mark - Delegate
#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    [self.LandingPage setHidden:NO];
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    //NSLog(@"E:%@",error);
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:YES];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.Email) {
        [self.PreviousButton setEnabled:NO];
    }
    else {
        [self.NextButton setEnabled:NO];
    }
}
@end
