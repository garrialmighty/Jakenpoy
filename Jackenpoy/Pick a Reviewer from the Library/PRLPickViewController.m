//
//  PRLPickViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/8/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "PRLPickViewController.h"
#import "PRLReviewerCell.h"
#import "PRLFinishViewController.h"
#import "Reviewer.h"
#import "Challenge.h"

static NSInteger Rating;
static NSArray * ReviewList;
static NSArray * QuestionTypeList;
static NSArray * SubjectList;
static NSIndexPath * SelectedIndex;
static NSIndexPath * IndexToUpdate;

@interface PRLPickViewController ()
@property (weak, nonatomic) IBOutlet UITableView *Table;
@property (weak, nonatomic) IBOutlet UILabel *RateLabel;
@property (weak, nonatomic) IBOutlet UIButton *Star5;
@property (weak, nonatomic) IBOutlet UIButton *Star4;
@property (weak, nonatomic) IBOutlet UIButton *Star3;
@property (weak, nonatomic) IBOutlet UIButton *Star2;
@property (weak, nonatomic) IBOutlet UIButton *Star1;
@property (weak, nonatomic) IBOutlet UILabel *RatingLabel;
@end

@implementation PRLPickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil List:(NSArray *)list
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ReviewList = [[NSArray alloc] initWithArray:list];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ReviewList = [[NSArray alloc] init];
    QuestionTypeList = [[NSArray alloc] init];
    SubjectList = [[NSArray alloc] init];
    
    [jakenpoyAppDelegate showBackButton];
    [self.navigationItem setHidesBackButton:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.Table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (void)setReviewList:(NSArray *)list
{
    ReviewList = list;
    //[self.Table reloadData];
}

- (void)setQuestionTypeList:(NSArray *)list
{
    QuestionTypeList = list;
}

- (void)setSubjectList:(NSArray *)list
{
    SubjectList = list;
}

- (void)updateRating:(int)rating
{
    UIImage * fill = [UIImage imageNamed:@"star_fill.png"];
    UIImage * blank = [UIImage imageNamed:@"star_blank.png"];
    
    switch (rating) {
        case 5:
            [self.Star5 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:fill forState:UIControlStateNormal];
            break;
        case 4:
            [self.Star5 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:fill forState:UIControlStateNormal];
            break;
        case 3:
            [self.Star5 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:fill forState:UIControlStateNormal];
            break;
        case 2:
            [self.Star5 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:fill forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:fill forState:UIControlStateNormal];
            break;
        case 1:
            [self.Star5 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:fill forState:UIControlStateNormal];
            break;
        default:
            [self.Star5 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star4 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star3 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star2 setBackgroundImage:blank forState:UIControlStateNormal];
            [self.Star1 setBackgroundImage:blank forState:UIControlStateNormal];
            break;
    }
}

- (void)updateAverage:(float)ave
{
    NSMutableAttributedString *ratingUlString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Rating: %0.1f",ave]];
    [ratingUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [ratingUlString length])];
    [ratingUlString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [ratingUlString length])];
    [self.RatingLabel setAttributedText:ratingUlString];
}

#pragma mark - IBAction
- (IBAction)rate:(UIButton *)sender
{
    [self updateRating:sender.tag];
    Reviewer * reviewer = ReviewList[SelectedIndex.row];
    JakenpoyHTTPClient * client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client rateReviewer:reviewer.ID Rating:[NSNumber numberWithInt:sender.tag]];
    
    Rating = sender.tag;
    IndexToUpdate = SelectedIndex;
}

- (IBAction)pick
{
    PRLFinishViewController * prlfvc;
    
    if (isPhone) {
        prlfvc = [[PRLFinishViewController alloc] initWithNibName:@"PRLFinishViewController" bundle:nil];
    }
    else {
        prlfvc = [[PRLFinishViewController alloc] initWithNibName:@"PRLFinishViewController_iPad" bundle:nil];
    }
    
    [self.navigationController pushViewController:prlfvc animated:YES];
    
    Reviewer * reviewer = ReviewList[SelectedIndex.row];
    Challenge * info = reviewer.Info;
    
    [prlfvc updateTitle:info.Title
           Instructions:info.Instruction
                 Expiry:info.Expiry
                   Code:info.Code
          ShareToPublic:info.ShareToPublic
          ShareToSchool:info.ShareToSchool
            ShowAnswers:info.ShowRightAnswers
         Classification:info.Classification
               Assigned:nil];
    
    [prlfvc setReviewerID:reviewer.ID QuestionTypeList:QuestionTypeList SubjectList:SubjectList];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ReviewList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PRLReviewerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PICKREVIEWCELL"];
    
    if (cell == nil) {
        NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"PRLReviewerCell" owner:self options:nil];
        cell = topObj[0];
    }
    
    Reviewer * reviewer = ReviewList[indexPath.row];
    Challenge * info = reviewer.Info;
    
    [cell.Title setText:info.Title];
    [cell.Author setText:reviewer.Name];
    
    return cell;
}

#pragma mark - Delegate
#pragma mark Jakenpoy
-(void)jakenpoyHTTPClientdidRateWithData:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        Reviewer * reviewer = ReviewList[IndexToUpdate.row];
        [reviewer setRating:Rating];
        NSLog(@"up:%d",Rating);
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Rating" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json
{
    NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"PRLReviewerCell" owner:self options:nil];
    PRLReviewerCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    [returnView.Title setText:@"Reviewer Title"];
    [returnView.Author setText:@"Author"];
    
    return returnView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reviewer * reviewer = ReviewList[indexPath.row];
    [self updateRating:reviewer.Rating];
    [self updateAverage:reviewer.Average];

    if ([self.RateLabel isHidden]) {
        [self.RateLabel setHidden:NO];
        [self.Star5 setHidden:NO];
        [self.Star4 setHidden:NO];
        [self.Star3 setHidden:NO];
        [self.Star2 setHidden:NO];
        [self.Star1 setHidden:NO];
        [self.RatingLabel setHidden:NO];
    }
    
    if (SelectedIndex.row != indexPath.row) [tableView deselectRowAtIndexPath:SelectedIndex animated:YES];
    
    SelectedIndex = indexPath;
}

@end
