//
//  AboutUsViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *LearnMoreButton;
@property (weak, nonatomic) IBOutlet UIButton *SmartButton;
@property (weak, nonatomic) IBOutlet UIButton *SunButton;
@property (weak, nonatomic) IBOutlet UIButton *GlobeButton;
@property (weak, nonatomic) IBOutlet UIButton *LandlineButton;
@property (weak, nonatomic) IBOutlet UIButton *EmailButton;

@end

@implementation AboutUsViewController

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
    
    NSMutableAttributedString *learnUlString = [[NSMutableAttributedString alloc] initWithString:@"Click to learn more about Jakenpoy PTA"];
    [learnUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [learnUlString length])];
    [learnUlString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.18 green:0.53 blue:0.94 alpha:1] range:NSMakeRange(0, [learnUlString length])];
    [self.LearnMoreButton setAttributedTitle:learnUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *smartUlString = [[NSMutableAttributedString alloc] initWithString:@"(0939) 908-5930"];
    [smartUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [smartUlString length])];
    [smartUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [smartUlString length])];
    [self.SmartButton setAttributedTitle:smartUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *sunUlString = [[NSMutableAttributedString alloc] initWithString:@"(0932) 853-3936"];
    [sunUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [sunUlString length])];
    [sunUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [sunUlString length])];
    [self.SunButton setAttributedTitle:sunUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *globeUlString = [[NSMutableAttributedString alloc] initWithString:@"(0917) 853-8840"];
    [globeUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [globeUlString length])];
    [globeUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [globeUlString length])];
    [self.GlobeButton setAttributedTitle:globeUlString forState:UIControlStateNormal];

    NSMutableAttributedString *landUlString = [[NSMutableAttributedString alloc] initWithString:@"(02) 466-1005"];
    [landUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [landUlString length])];
    [landUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [landUlString length])];
    [self.LandlineButton setAttributedTitle:landUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *emailUlString = [[NSMutableAttributedString alloc] initWithString:@"admin@jakenpoy.com"];
    [emailUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [emailUlString length])];
    [emailUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [emailUlString length])];
    [self.EmailButton setAttributedTitle:emailUlString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)showTutorial
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://info.jakenpoy.com/"]];
}

- (IBAction)contact:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0939-908-5930"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0932-853-3936"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0917-853-8840"]];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:02-466-1005"]];
            break;
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:admin@jakenpoy.com"]];
            break;
        default:
            break;
    }
}
@end
