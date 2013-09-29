//
//  MRSFinishViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/16/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRSFinishViewController.h"
#import "MRSQuestionViewController.h"

@interface MRSFinishViewController ()
@property (weak, nonatomic) IBOutlet UIView *Step1;
@property (weak, nonatomic) IBOutlet UIView *Step2;
@property (weak, nonatomic) IBOutlet UIButton *Step1Button;
@property (weak, nonatomic) IBOutlet UIButton *Step2Button;
@property (weak, nonatomic) IBOutlet UIButton *NFButton;

@end

@implementation MRSFinishViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)showStep:(UIButton *)sender
{
    NSMutableAttributedString * NFUlString;
    [sender setEnabled:NO];
    
    if (sender.tag == 1) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"NEXT"];
        [self.NFButton setTag:1];
        [self.Step2Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step2];
    }
    else {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"FINISHED"];
        [self.NFButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
    }
    
    [NFUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [NFUlString length])];
    [NFUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [NFUlString length])];
    [self.NFButton setAttributedTitle:NFUlString forState:UIControlStateNormal];
}

- (IBAction)makeQuestion
{
    MRSQuestionViewController * mrsqvc = [[MRSQuestionViewController alloc] initWithNibName:@"MRSQuestionViewController" bundle:nil];
    [self.navigationController pushViewController:mrsqvc animated:YES];
}

- (IBAction)nextFinish:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self.NFButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:NO];
        [self.view sendSubviewToBack:self.Step1];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"FINISHED"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NFButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    else {
        NSArray * vcStack = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcStack[1] animated:YES];
    }
}

@end
