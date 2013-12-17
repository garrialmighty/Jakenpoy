//
//  AppDelegate.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/12/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "AppDelegate.h"
#import "HPLoginViewController.h"
#import "MyReviewersViewController.h"
#import "PRLSearchViewController.h"
#import "TDMenuViewController.h"
#import "MRSFinishViewController.h"
#import "RandomizerViewController.h"
#import "MRMKKidsViewController.h"
#import "MyAccountViewController.h"
#import "AboutUsViewController.h"

#import "Challenge.h"

static NSString * RootPage;

static BOOL isBackEnabled = NO;

static CGFloat HeaderHeight;
static CGFloat ScreenHeight;
static CGFloat MenuCellHeight;

static CGFloat MenuCellCount = 8;

static NSIndexPath * SelectedRow = nil;

@interface AppDelegate()
@property (strong) UILabel * ScreenLabel;
@property (strong) UIButton * BackButton;
@property (strong) UIButton * HitArea;
@property (strong) UIImageView * BackArrow;
@property (strong) UITableView * Menu;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    HPLoginViewController * hplvc;
    
    isPhone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    
    if (isPhone) {
        hplvc = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController" bundle:nil];
    } else {
        hplvc = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController_iPad" bundle:nil];
    }
    
    self.viewController = [[UINavigationController alloc] initWithRootViewController:hplvc];
    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    [self calculateConstants];
    [self initializeNavigationBar];
    [self initializeMenu];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    jakenpoyAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper Methods
- (void)calculateConstants
{
    ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    MenuCellHeight = floorf(ScreenHeight/MenuCellCount);
    
    HeaderHeight = ScreenHeight - (MenuCellHeight*(MenuCellCount-1));
}

- (void)showMenuButtons
{
    [self.BackArrow setHidden:NO];
    [self.HitArea setHidden:NO];
    
    UserType * type = [JakenpoyHTTPClient getSharedClient].Type;
    if (!type.Teacher && !type.Admin) {
        MenuCellCount = 7;
        [self calculateConstants];
        [self.Menu reloadData];
    }
}

- (void)showBackButton
{
    isBackEnabled = YES;
    RootPage = self.ScreenLabel.text;
    [self.ScreenLabel setText:@"Back"];
}

- (void)hideBackButton
{
    isBackEnabled = NO;
    [self.ScreenLabel setText:RootPage];
}

#pragma mark - IBAction Methods
- (void)showMenu
{
    [self.BackButton setUserInteractionEnabled:YES];
    
    if (!isBackEnabled) {
        for (UIView * view in self.viewController.view.subviews) {
            if (![view isKindOfClass:[UITableView class]] && ![view isKindOfClass:[UIButton class]]) {
                [UIView animateWithDuration:0.4f animations:^{
                    CGRect currFrame = view.frame;
                    currFrame.origin.x = isPhone?245:525;
                    [view setFrame:currFrame];
                }];
            }
        }
    }
    else {
        [self.viewController popViewControllerAnimated:YES];
    }
}

- (void)back
{
    [self.BackButton setUserInteractionEnabled:NO];
    
    for (UIView * view in self.viewController.view.subviews) {
        if (![view isKindOfClass:[UITableView class]] && ![view isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.4f animations:^{
                CGRect currFrame = view.frame;
                currFrame.origin.x = 0;
                [view setFrame:currFrame];
            }];
        }
    }
}

#pragma mark - Initializer Methods
- (void)initializeNavigationBar
{
    UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, isPhone?320:768, 44)];
    [bg setBackgroundColor:[UIColor colorWithRed:0.18 green:0.53 blue:0.94 alpha:1]];
    
    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jakenpoy_logo.png"]];
    [logo setFrame:CGRectMake(245, 7, 73, 33)];
    
    self.BackArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"]];
    [self.BackArrow setFrame:CGRectMake(5, 12, 11, 23)];
    [self.BackArrow setHidden:YES];
    
    self.ScreenLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 15, 250, 19)];
    [self.ScreenLabel setText:@"Get Started"];
    [self.ScreenLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
    [self.ScreenLabel setTextColor:[UIColor whiteColor]];
    [self.ScreenLabel setBackgroundColor:[UIColor clearColor]];
    
    self.HitArea = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.HitArea setFrame:CGRectMake(0, 0, isPhone?200:500, 45)];
    [self.HitArea addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.HitArea setHidden:YES];
    
    self.BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.BackButton setFrame:CGRectMake(245, 0, isPhone?76:500, ScreenHeight)];
    [self.BackButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewController.navigationBar addSubview:bg];
    if (isPhone) [self.viewController.navigationBar addSubview:logo];
    [self.viewController.navigationBar addSubview:self.BackArrow];
    [self.viewController.navigationBar addSubview:self.ScreenLabel];
    [self.viewController.navigationBar addSubview:self.HitArea];
    [self.viewController.view addSubview:self.BackButton];
}

- (void)initializeMenu
{
    self.Menu = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, isPhone?245:525, ScreenHeight) style:UITableViewStylePlain];
    [self.Menu setDataSource:self];
    [self.Menu setDelegate:self];
    [self.Menu setScrollEnabled:NO];
    [self.Menu setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.viewController.view addSubview:self.Menu];
    [self.viewController.view sendSubviewToBack:self.Menu];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MenuCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.Menu dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    
    UIImageView * menuLogo;
    UILabel * cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(isPhone?70:140, 0, isPhone?170:300, MenuCellHeight)];
    [cellLabel setNumberOfLines:0];
    
    UIView * highlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, isPhone?320:768, MenuCellHeight)];
    [highlight setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedback.png"]]];
    
    CGFloat logoY = (HeaderHeight - 35) / 2;
    UIImageView * logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jakenpoy_logo.png"]];
    [logo setFrame:CGRectMake(20, logoY, 85, 35)];
    
    UILabel * menuLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, isPhone?80:200, HeaderHeight)];
    [menuLabel setText:@"Menu"];
    [menuLabel setFont:[UIFont boldSystemFontOfSize:isPhone?18:30]];
    [menuLabel setBackgroundColor:[UIColor clearColor]];
    [menuLabel setTextColor:[UIColor colorWithRed:0.18 green:0.53 blue:0.94 alpha:1]];
    
    //[[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (indexPath.row) {
        case 0:
            [cell addSubview:logo];
            [cell addSubview:menuLabel];
            [cell setUserInteractionEnabled:NO];
            break;
        case 1:
            menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?33:67))/2, isPhone?46:93, isPhone?33:67)];
            [menuLogo setImage:[UIImage imageNamed:@"reviewers_icon.png"]];
            [cell addSubview:menuLogo];
            
            [cellLabel setText:@"My Reviewers"];
            [cell addSubview:cellLabel];
            break;
        case 2:
            menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?24:48))/2, isPhone?54:108, isPhone?24:48)];
            [menuLogo setImage:[UIImage imageNamed:@"pick_icon.png"]];
            [cell addSubview:menuLogo];
            
            [cellLabel setText:@"Pick a Reviewer from the Library"];
            [cellLabel setNumberOfLines:2];
            [cell addSubview:cellLabel];
            break;
        default:
            break;
    }
    
    /*
    // Make a Reviewer From Scratch
    menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-13)/2, 20, 13)];
    [menuLogo setImage:[UIImage imageNamed:@"make_icon.png"]];
    [cell addSubview:menuLogo];
    
    [cellLabel setText:@"Make a Reviewer from Scratch"];
    [cell addSubview:cellLabel];
    
    // Randomizer
    menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-15)/2, 20, 15)];
    [menuLogo setImage:[UIImage imageNamed:@"random_icon.png"]];
    [cell addSubview:menuLogo];
    
    cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, MenuCellHeight)];
    [cellLabel setText:@"Randomizer"];
    [cell addSubview:cellLabel];
    
    // Tutorial
    menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-20)/2, 21, 20)];
    [menuLogo setImage:[UIImage imageNamed:@"tutorial_icon.png"]];
    [cell addSubview:menuLogo];
    
    cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, MenuCellHeight)];
    [cellLabel setText:@"Tutorials"];
    [cell addSubview:cellLabel];
    */
    
    if (MenuCellCount == 7) {
        switch (indexPath.row) {
            case 3:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?36:72))/2, isPhone?40:80, isPhone?36:72)];
                [menuLogo setImage:[UIImage imageNamed:@"manage_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"Manage/Register My Kids"];
                [cell addSubview:cellLabel];
                break;
            case 4:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?31:62))/2, isPhone?42:85, isPhone?31:62)];
                [menuLogo setImage:[UIImage imageNamed:@"my_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"My Account"];
                [cell addSubview:cellLabel];
                break;
            case 5:
                [cellLabel setText:@"About Us/Contact Us"];
                [cell addSubview:cellLabel];
                break;
            case 6:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?33:66))/2, isPhone?39:78, isPhone?33:66)];
                [menuLogo setImage:[UIImage imageNamed:@"logout_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"Log Out"];
                [cell addSubview:cellLabel];
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 3:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?40:80))/2, isPhone?40:80, isPhone?40:80)];
                [menuLogo setImage:[UIImage imageNamed:@"teacher_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"Teacher's Desk"];
                [cell addSubview:cellLabel];
                break;
            case 4:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?36:72))/2, isPhone?40:80, isPhone?36:72)];
                [menuLogo setImage:[UIImage imageNamed:@"manage_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"Manage/Register My Kids"];
                [cell addSubview:cellLabel];
                break;
            case 5:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?31:62))/2, isPhone?42.5:85, isPhone?31:62)];
                [menuLogo setImage:[UIImage imageNamed:@"my_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"My Account"];
                [cell addSubview:cellLabel];
                break;
            case 6:
                [cellLabel setText:@"About Us/Contact Us"];
                [cell addSubview:cellLabel];
                break;
            case 7:
                menuLogo = [[UIImageView alloc] initWithFrame:CGRectMake(5, (MenuCellHeight-(isPhone?33:66))/2, isPhone?39:78, isPhone?33:66)];
                [menuLogo setImage:[UIImage imageNamed:@"logout_icon.png"]];
                [cell addSubview:menuLogo];
                
                [cellLabel setText:@"Log Out"];
                [cell addSubview:cellLabel];
                break;
            default:
                break;
        }
    }
    
    [cellLabel setTextColor:[UIColor whiteColor]];
    //[cellLabel setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:isPhone?8:20]];
    [cellLabel setFont:[UIFont boldSystemFontOfSize:isPhone?15:30]];
    [cellLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell setSelectedBackgroundView:highlight];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat returnHeight=0;
    
    switch (indexPath.row) {
        case 0:
            returnHeight = HeaderHeight;
            break;
        default:
            returnHeight = MenuCellHeight;
            break;
    }
    
    return returnHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SelectedRow.row != indexPath.row) {
        [tableView deselectRowAtIndexPath:SelectedRow animated:YES];
    }
    
    SelectedRow = indexPath;
    
    UIViewController * newPage = nil;
    
    switch (indexPath.row) {
        case 1:
            RootPage = @"My Reviewers";
            if (isPhone) {
                newPage = [[MyReviewersViewController alloc] initWithNibName:@"MyReviewersViewController" bundle:nil];
            } else {
                newPage = [[MyReviewersViewController alloc] initWithNibName:@"MyReviewersViewController_iPad" bundle:nil];
            }
            break;
        case 2:
            RootPage = @"Pick a Reviewer from the Library";
            if (isPhone) {
                newPage = [[PRLSearchViewController alloc] initWithNibName:@"PRLSearchViewController" bundle:nil];
            } else {
                newPage = [[PRLSearchViewController alloc] initWithNibName:@"PRLSearchViewController_iPad" bundle:nil];
            }
            break;
        default:
            break;
    }
    
    /*
    //Make a Reviewer from Scratch
    [self.ScreenLabel setText:@"Make a Reviewer from Scratch"];
    newPage = [[MRSFinishViewController alloc] initWithNibName:@"MRSFinishViewController" bundle:nil];
    
    //Randomizer
    [self.ScreenLabel setText:@"Randomizer"];
    newPage = [[RandomizerViewController alloc] initWithNibName:@"RandomizerViewController" bundle:nil];
    
    //Tutorials
    [self.ScreenLabel setText:@"Tutorials"];
    */
    
    if (MenuCellCount == 7) {
        switch (indexPath.row) {
            case 3:
                RootPage = @"Manage/Register My Kids";
                if (isPhone) {
                    newPage = [[MRMKKidsViewController alloc] initWithNibName:@"MRMKKidsViewController" bundle:nil];
                } else {
                    newPage = [[MRMKKidsViewController alloc] initWithNibName:@"MRMKKidsViewController_iPad" bundle:nil];
                }
                break;
            case 4:
                RootPage = @"My Account";
                if (isPhone) {
                    newPage = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
                } else {
                    newPage = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController_iPad" bundle:nil];
                }
                break;
            case 5:
                RootPage = @"About Us/Contact Us";
                if (isPhone) {
                    newPage = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
                } else {
                    newPage = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPad" bundle:nil];
                }
                break;
            case 6:
                RootPage = @"Get Started";
                if (isPhone) {
                    newPage = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController" bundle:nil];
                } else {
                    newPage = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController_iPad" bundle:nil];
                }
                
                [[JakenpoyHTTPClient getSharedClient] logout];
                [self.HitArea setHidden:YES];
                [self.BackArrow setHidden:YES];
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 3:
                RootPage = @"Teacher's Desk";
                if (isPhone) {
                    newPage = [[TDMenuViewController alloc] initWithNibName:@"TDMenuViewController" bundle:nil];
                } else {
                    newPage = [[TDMenuViewController alloc] initWithNibName:@"TDMenuViewController_iPad" bundle:nil];
                }
                break;
            case 4:
                RootPage = @"Manage/Register My Kids";
                if (isPhone) {
                    newPage = [[MRMKKidsViewController alloc] initWithNibName:@"MRMKKidsViewController" bundle:nil];
                } else {
                    newPage = [[MRMKKidsViewController alloc] initWithNibName:@"MRMKKidsViewController_iPad" bundle:nil];
                }
                break;
            case 5:
                RootPage = @"My Account";
                if (isPhone) {
                    newPage = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
                } else {
                    newPage = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController_iPad" bundle:nil];
                }
                break;
            case 6:
                RootPage = @"About Us/Contact Us";
                if (isPhone) {
                    newPage = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
                } else {
                    newPage = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController_iPad" bundle:nil];
                }
                break;
            case 7:
                RootPage = @"Get Started";
                if (isPhone) {
                    newPage = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController" bundle:nil];
                } else {
                    newPage = [[HPLoginViewController alloc] initWithNibName:@"HPLoginViewController_iPad" bundle:nil];
                }
                
                [[JakenpoyHTTPClient getSharedClient] logout];
                [self.HitArea setHidden:YES];
                [self.BackArrow setHidden:YES];
                break;
            default:
                break;
        }
    }
    
    if (newPage) {
        [self.viewController popViewControllerAnimated:NO];
        [self.viewController pushViewController:newPage animated:NO];
    }
    
    [self.ScreenLabel setText:RootPage];
    [self back];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.89 blue:0.89 alpha:1]];
            break;
        case 1:
            [cell setBackgroundColor:[UIColor colorWithRed:0.25 green:0.66 blue:0.94 alpha:1]];
            break;
        case 2:
            [cell setBackgroundColor:[UIColor colorWithRed:0.75 green:0.2 blue:0.35 alpha:1]];
            break;
        default:
            break;
    }
    
    /*
     //Make a Reviewer from Scratch
     [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.67 blue:0.1 alpha:1]];
     
     //Randomizer
     [cell setBackgroundColor:[UIColor colorWithRed:0.99 green:0.1 blue:0.63 alpha:1]];
     
     //Tutorials
     [cell setBackgroundColor:[UIColor colorWithRed:0.86 green:0.39 blue:0.25 alpha:1]];
     */
    
    if (MenuCellCount == 7) {
        switch (indexPath.row) {
            case 3:
                [cell setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0.67 alpha:1]];
                break;
            case 4:
                [cell setBackgroundColor:[UIColor colorWithRed:1 green:0.79 blue:0.15 alpha:1]];
                break;
            case 5:
                [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.31 blue:0.1 alpha:1]];
                break;
            case 6:
                [cell setBackgroundColor:[UIColor colorWithRed:0.13 green:0.14 blue:0.14 alpha:1]];
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 3:
                [cell setBackgroundColor:[UIColor colorWithRed:0.24 green:0.35 blue:0.6 alpha:1]];
                break;
            case 4:
                [cell setBackgroundColor:[UIColor colorWithRed:0 green:0.6 blue:0.67 alpha:1]];
                break;
            case 5:
                [cell setBackgroundColor:[UIColor colorWithRed:1 green:0.79 blue:0.15 alpha:1]];
                break;
            case 6:
                [cell setBackgroundColor:[UIColor colorWithRed:0.1 green:0.31 blue:0.1 alpha:1]];
                break;
            case 7:
                [cell setBackgroundColor:[UIColor colorWithRed:0.13 green:0.14 blue:0.14 alpha:1]];
                break;
            default:
                break;
        }
    }
    
}

@end
