//
//  MyReviewersViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "MyReviewersViewController.h"
#import "PRLFinishViewController.h"
#import "MRAnalysisViewController.h"
#import "ReviewerCell.h"
#import "Reviewer.h"
#import "Challenge.h"

static NSMutableArray * ReviewersList;
static JakenpoyHTTPClient * client;

NSIndexPath * SelectedIndex;

@interface MyReviewersViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ReportsButton;
@property (weak, nonatomic) IBOutlet UIButton *PrintButton;
@property (weak, nonatomic) IBOutlet UIButton *RepublishButton;
@property (weak, nonatomic) IBOutlet UIButton *FBButton;
@property (weak, nonatomic) IBOutlet UITableView *Table;

@property (weak, nonatomic) IBOutlet UIView *LoadingScreen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@end

@implementation MyReviewersViewController

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
    
    ReviewersList = [[NSMutableArray alloc] init];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getMyReviewers];
    
    // Do any additional setup after loading the view from its nib.
    /*[self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];*/
    //[self.ReportsButton.layer setBorderWidth:1.0];
    
    // Add underlined titles
    /*NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"Reports"];
    [reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
    [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
    [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *printUlString = [[NSMutableAttributedString alloc] initWithString:@"Print"];
    [printUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [printUlString length])];
    [printUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [printUlString length])];
    [self.PrintButton setAttributedTitle:printUlString forState:UIControlStateNormal];
    
    NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"Publish"];
    [republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
    [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
    [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];*/
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.ReportsButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
    [self.PrintButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
    [self.RepublishButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [jakenpoyAppDelegate hideBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
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

#pragma mark - IBAction
- (IBAction)publish
{
    Reviewer * reviewer = ReviewersList[SelectedIndex.row];
    
    if (self.RepublishButton.tag==1) {
        [client publish:reviewer.ID];
    }
    else {
        [client unpublish:reviewer.ID];
    }
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"Your reviewer has been published." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (IBAction)edit
{
    if ([self.ReportsButton.titleLabel.text isEqualToString:@"Edit"]) {
        /*PRLFinishViewController * prlfvc = [[PRLFinishViewController alloc] initWithNibName:@"PRLFinishViewController" bundle:nil];
        [self.navigationController pushViewController:prlfvc animated:YES];
        
        Reviewer * reviewer = ReviewersList[SelectedIndex.row];
        Challenge * info = reviewer.Info;
        
        [prlfvc updateTitle:info.Title
               Instructions:info.Instruction
                     Expiry:info.Expiry
                       Code:info.Code
              ShareToPublic:info.ShareToPublic
              ShareToSchool:info.ShareToSchool
                ShowAnswers:info.ShowRightAnswers
             Classification:info.Classification
                   Assigned:nil];*/
    }
    else {
        MRAnalysisViewController * mravc;
        
        if (isPhone) {
            mravc = [[MRAnalysisViewController alloc] initWithNibName:@"MRAnalysisViewController" bundle:nil];
        }
        else {
            mravc = [[MRAnalysisViewController alloc] initWithNibName:@"MRAnalysisViewController_iPad" bundle:nil];
        }
        
        Reviewer * reviewer = ReviewersList[SelectedIndex.row];
        [mravc setReviewerID:reviewer.ID];
        
        [self.navigationController pushViewController:mravc animated:YES];
        
        Reviewer * r = ReviewersList[SelectedIndex.row];
        [client getAnalysisForReviewer:r.ID];
    }
}

- (IBAction)print
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Printing" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)shareToFB
{
    [self showLoadingScreen];
    Reviewer * reviewer = ReviewersList[SelectedIndex.row];
    [client getPDFLink:reviewer.ID];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ReviewersList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"REVIEWCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"ReviewerCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    if (ReviewersList.count>0) {
        Reviewer * reviewer = ReviewersList[indexPath.row];
        Challenge * info = reviewer.Info;
        
        [cell.Title setText:info.Title];
        [cell.ExpirationDate setText:info.Expiry];
        [cell.Status setText:reviewer.isPublished?@"(1/1)":@"(0/1)"];
        [cell setIsGood:reviewer.isPublished];
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        [format setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        [cell setExpDate:[format dateFromString:info.Expiry]];
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"ReviewerCell" owner:self options:nil];
    ReviewerCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor colorWithRed:0.83 green:0.86 blue:0.9 alpha:1]];
    [returnView.Title setText:@"Title"];
    [returnView.Title setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.ExpirationDate setText:@"Expiry Date"];
    [returnView.ExpirationDate setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    [returnView.Status setText:@"Status"];
    [returnView.Status setTextColor:[UIColor colorWithRed:0.27 green:0.31 blue:0.56 alpha:1]];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ReportsButton isHidden]) {
        [self.ReportsButton setHidden:NO];
        [self.PrintButton setHidden:NO];
        [self.RepublishButton setHidden:NO];
        [self.FBButton setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    SelectedIndex = indexPath;
    
    ReviewerCell * cell = (ReviewerCell *)[tableView cellForRowAtIndexPath:SelectedIndex];
    
    // If cell is published
    if (cell.isGood) {
        NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"Reports"];
        //[reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
        [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [reportUlString length])];
        [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
        [self.ReportsButton setBackgroundColor:[UIColor colorWithRed:0.86 green:0.39 blue:0.25 alpha:1]];
        
        // Date today is less than expiry
        if ([[NSDate date] compare:cell.ExpDate]==NSOrderedDescending) {
            NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"Unpublish"];
            //[republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
            [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
            [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
            [self.RepublishButton setTag:2];
        }
        // Date today is more than expiry
        else {
            NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"Republish"];
            //[republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
            [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
            [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
            [self.RepublishButton setTag:1];
        }
    }
    // If cell is unpublished or has expired
    else {
        NSMutableAttributedString *reportUlString = [[NSMutableAttributedString alloc] initWithString:@"Edit"];
        //[reportUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [reportUlString length])];
        [reportUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [reportUlString length])];
        [self.ReportsButton setAttributedTitle:reportUlString forState:UIControlStateNormal];
        [self.ReportsButton setBackgroundColor:[UIColor whiteColor]];
        
        NSMutableAttributedString *republishUlString = [[NSMutableAttributedString alloc] initWithString:@"Publish"];
        //[republishUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [republishUlString length])];
        [republishUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [republishUlString length])];
        [self.RepublishButton setAttributedTitle:republishUlString forState:UIControlStateNormal];
        [self.RepublishButton setTag:1];
    }
}

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClientdidUpdateWithPDFLink:(NSDictionary *)json
{
    [self hideLoadingScreen];
    NSURL * urlToShare = [NSURL URLWithString:json[@"data"]];
    
    /*
     message => "I have created a reviewer in Jakenpoy PTA!",
     picture => "pta.jakenpoy.com/img/pta-thumb.jpg",
     link => "http://pta.jakenpoy.com/assets/pdf/" . $id . ".pdf",
     name => "Jakenpoy PTA Reviewer: ". $info['title'],
     caption => "Making reviewers has never been easier and more fun!"
     */
    
    /*
     picture => pta.jakenpoy.com/img/pta-thumb.jpg
     link => this data will be returned sa web service
     */
    
    Reviewer * reviewer = ReviewersList[SelectedIndex.row];
    Challenge * info = reviewer.Info;
    
    // Try to post using Facebook app
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
                                                          name:[NSString stringWithFormat:@"Jakenpoy PTA Reviewer: %@",info.Title] // Hello Facebook
                                                       caption:@"Making reviewers has never been easier and more fun!"
                                                   description:@"I have created a reviewer in Jakenpoy PTA!" //The 'Hello Facebook' sample application showcases simple Facebook integration.
                          //https://cdn1.iconfinder.com/data/icons/zoomeyed-creatures_2/128/monkeys_audio.png
                                                       picture:[NSURL URLWithString:@"http://pta.jakenpoy.com/img/pta-thumb.jpg"]
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"Error: %@", error.description);
                                                           } else {
                                                               NSLog(@"Success!");
                                                           }
                                                       }];

    // If Facebook app is not available...
    if (!appCall) {
        // ... try to post using iOS6, and above, Facebook integration
        /*BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                              initialText:@"I have created a reviewer in Jakenpoy PTA!"
                                                                                    image:nil
                                                                                      url:urlToShare
                                                                                  handler:^(FBOSIntegratedShareDialogResult result, NSError *error) {
                                                                                      // Do something
                                                                                  }];*/
        // If iOS version is below iOS6 use Facebook web POST method
        //if (!displayedNativeDialog) {
        if (YES) {
            // Post using status update only
            //NSString *message = @"I have created a reviewer in Jakenpoy PTA!";
            /*FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            [connection setErrorBehavior:FBRequestConnectionErrorBehaviorReconnectSession | FBRequestConnectionErrorBehaviorAlertUser | FBRequestConnectionErrorBehaviorRetry];
            
            void (^postAction) (void) = ^void(void) {
                [connection addRequest:[FBRequest requestForPostOpenGraphObjectWithType:nil title:@"Test title" image:@"pta.jakenpoy.com/img/pta-thumb.jpg" url:urlToShare description:nil objectProperties:nil]
                     completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                         [self hideLoadingScreen];
                     }];
                [connection start];
                
                [self showLoadingScreen];
            };
            
            [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                               defaultAudience:FBSessionDefaultAudienceFriends
                                                  allowLoginUI:NO
                                             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                 NSLog(@"got here %@ %d %@", session, status, error);
                                                 if (FBSessionStateOpen) {
                                                     postAction();
                                                 }
                                             }];*/
            
            // Check for the permission
            // If we don't have the permission, then we request it now
            /*if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                                      defaultAudience:FBSessionDefaultAudienceFriends
                                                    completionHandler:^(FBSession *session, NSError *error) {
                                                        if (!error) {
                                                            postAction();
                                                        }
                                                        else if (error.fberrorCategory != FBErrorCategoryUserCancelled){
                                                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                                message:@"Unable to get permission to post"
                                                                                                               delegate:nil
                                                                                                      cancelButtonTitle:@"OK"
                                                                                                      otherButtonTitles:nil];
                                                            [alertView show];
                                                        }
                                                    }];
            }
            else {
                postAction();
            }*/
            
            // Post using web dialog
            // Put together the dialog parameters
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Jakenpoy PTA Reviewer: %@",info.Title], @"name",
                                           @"I have created a reviewer in Jakenpoy PTA!", @"message",
                                           @"Making reviewers has never been easier and more fun!", @"caption",
                                           //@"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
                                           @"http://pta.jakenpoy.com/assets/pdf/8123.pdf", @"link",
                                           @"pta.jakenpoy.com/img/pta-thumb.jpg", @"picture",
                                           nil];
            
            // Invoke the dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // Error launching the dialog or publishing a story.
                                                              NSLog(@"Error publishing story.");
                                                          }
                                                          else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User clicked the "x" icon
                                                                  NSLog(@"User canceled story publishing.");
                                                              }
                                                              else {
                                                                  // Handle the publish feed callback
                                                                  /*NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User clicked the Cancel button
                                                                      NSLog(@"User canceled story publishing.");
                                                                  }
                                                                  else {
                                                                      // User clicked the Share button
                                                                      NSString *msg = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"%@", msg);
                                                                      
                                                                      // Show the result in an alert
                                                                      [[[UIAlertView alloc] initWithTitle:@"Result" message:msg delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
                                                                  }*/
                                                                  
                                                                  [[[UIAlertView alloc] initWithTitle:nil message:@"You've successfully shared the reviewer in Facebook." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                                              }
                                                          }
                                                      }];
        }
    }
}

-(void)jakenpoyHTTPClientdidPublish:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        [client getMyReviewers];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"challenges"];
        [ReviewersList removeAllObjects];
        
        for (NSDictionary * reviewer in data) {
            Reviewer * item = [[Reviewer alloc] init];

            [item setID:[NSNumber numberWithInteger:[reviewer[@"id"] integerValue]]];
            [item setIsHidden:[reviewer[@"is_hidden"] boolValue]];
            [item setIsPublished:[reviewer[@"is_published"] boolValue]];
            [item setDeletable:[reviewer[@"can_be_deleted"] boolValue]];
            [item setInfo:[Challenge challengeWithInfo:reviewer[@"challenge_info"]]];
            
            [ReviewersList addObject:item];
        }
        
        [self.Table reloadData];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
