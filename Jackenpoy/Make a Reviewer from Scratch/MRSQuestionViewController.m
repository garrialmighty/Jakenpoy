//
//  MRSQuestionViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/16/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRSQuestionViewController.h"

@interface MRSQuestionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *DoneButton;

@end

@implementation MRSQuestionViewController

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
    
    NSMutableAttributedString * saveUlString = [[NSMutableAttributedString alloc] initWithString:@"DONE"];
    [saveUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [saveUlString length])];
    [saveUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [saveUlString length])];
    [self.DoneButton setAttributedTitle:saveUlString forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)save
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
