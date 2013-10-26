//
//  MyAccountViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *Name;
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *Password;
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@end

@implementation MyAccountViewController

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
    
    [self.Name setInputAccessoryView:self.Toolbar];
    [self.Email setInputAccessoryView:self.Toolbar];
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

#pragma mark - IBAction
#pragma mark UIButton
- (IBAction)save
{
    if (self.Name.text.length==0 || self.Email.text.length==0 || self.Password.text.length==0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Empty Fields" message:@"Please fill out all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        JakenpoyHTTPClient * client = [JakenpoyHTTPClient getSharedClient];
        [client setDelegate:self];
        [client updateName:self.Name.text Email:self.Email.text Password:self.Password.text];
    }
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    if ([self.Password isFirstResponder]) {
        [self scrollPageToPoint:ViewCenter.y];
        
        [self.Password resignFirstResponder];
        [self.Email becomeFirstResponder];
        [self.NextButton setEnabled:YES];
    }
    else if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
        [self.Name becomeFirstResponder];
        [self.PreviousButton setEnabled:NO];
    }
}

- (IBAction)jumpToNext
{
    if ([self.Name isFirstResponder]) {
        [self.Name resignFirstResponder];
        [self.Email becomeFirstResponder];
        [self.PreviousButton setEnabled:YES];
    }
    else if ([self.Email isFirstResponder]) {
        [self scrollPageToPoint:80];
        
        [self.Email resignFirstResponder];
        [self.Password becomeFirstResponder];
        [self.NextButton setEnabled:NO];
    }
}

- (IBAction)close
{
    if ([self.Name isFirstResponder]) {
        [self.Name resignFirstResponder];
    }
    else if ([self.Email isFirstResponder]) {
        [self.Email resignFirstResponder];
    }
    else {
        [self.Password resignFirstResponder];
    }
    
    [self revertPageState];
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

#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self revertPageState];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.Name) {
        [self.PreviousButton setEnabled:NO];
    }
    else if (textField == self.Password) {
        [self scrollPageToPoint:80];
        [self.NextButton setEnabled:NO];
    }
}

@end
