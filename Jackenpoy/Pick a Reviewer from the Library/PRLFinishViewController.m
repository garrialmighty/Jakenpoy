//
//  PRLFinishViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/14/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "PRLFinishViewController.h"
#import "PRLSearchViewController.h"
#import "PRLQuestionCell.h"
#import "TDCheckboxCell.h"
#import "Reviewer.h"
#import "Challenge.h"
#import "Assignees.h"
#import "QuestionDetails.h"
#import "Question.h"

static JakenpoyHTTPClient * client;
static QuestionDetails * QuestionDetail;
static NSInteger Selected;
static NSInteger Step2Selected;
static NSMutableArray * AssigneeList;

static NSString * CurrentTitle;
static NSString * CurrentInstruction;

@interface PRLFinishViewController ()
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *Expiry;
@property (weak, nonatomic) IBOutlet UITextField *Code;
@property (weak, nonatomic) IBOutlet UITextField *Classification;
@property (weak, nonatomic) IBOutlet UIButton *NFButton;
@property (weak, nonatomic) IBOutlet UIButton *Step1Button;
@property (weak, nonatomic) IBOutlet UIButton *Step2Button;
@property (weak, nonatomic) IBOutlet UIButton *DetailsButton;
@property (weak, nonatomic) IBOutlet UIView *Step1;
@property (weak, nonatomic) IBOutlet UIView *Step2;
@property (weak, nonatomic) IBOutlet UIView *Detail;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *PickerToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ToolbarDoneButton;
@property (weak, nonatomic) IBOutlet UITableView *KidsTable;
@property (weak, nonatomic) IBOutlet UIView *KidsView;
@property (weak, nonatomic) IBOutlet UIButton *ShareToPublicCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *ShareToSchoolCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *ShowRightAnswersCheckbox;
@property (weak, nonatomic) IBOutlet UIToolbar *Step2PickerToolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *Step2Picker;
//@property (weak, nonatomic) IBOutlet UITextField *QuestionType;

@property (weak, nonatomic) IBOutlet UILabel *QuestionTitle;
@property (weak, nonatomic) IBOutlet UILabel *QuestionClassification;
@property (weak, nonatomic) IBOutlet UILabel *QuestionTopic;
@property (weak, nonatomic) IBOutlet UILabel *QuestionType;
@property (weak, nonatomic) IBOutlet UITableView *QuestionTable;
@property (weak, nonatomic) IBOutlet UILabel *QuestionInstructions;

@property (weak, nonatomic) IBOutlet UIView *LoadingScreen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;

// Used when updating UI
@property (strong, nonatomic) NSString * titleHolder;
@property (strong, nonatomic) NSString * instructionHolder;
@property (strong, nonatomic) NSString * expiryHolder;
@property (strong, nonatomic) NSString * codeHolder;
@property (assign, nonatomic) BOOL shareToPublicHolder;
@property (assign, nonatomic) BOOL shareToSchoolHolder;
@property (assign, nonatomic) BOOL showAnswersHolder;
@property (strong, nonatomic) NSString * classificationHolder;
@property (strong, nonatomic) NSArray * assignedHolder;

// Used when getting reviewer details
@property (strong, nonatomic)  NSNumber * ReviewerID;
@property (strong, nonatomic)  NSArray * SubjectList;
@property (strong, nonatomic)  NSArray * QuestionTypeList;
@end

@implementation PRLFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getAssignees];
    
    AssigneeList = [[NSMutableArray alloc] init];
    
    /*NSMutableAttributedString * nextUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
    [nextUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [nextUlString length])];
    [nextUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [nextUlString length])];
    [self.NFButton setAttributedTitle:nextUlString forState:UIControlStateNormal];*/
    
    [self.Title setInputAccessoryView:self.Toolbar];
    [self.Code setInputAccessoryView:self.Toolbar];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.Title setPlaceholder:self.titleHolder];
    
    [self.Expiry setText:self.expiryHolder];
    [self.Code setText:self.codeHolder];
    
    [self.ShareToPublicCheckbox setSelected:self.shareToPublicHolder];
    [self.ShareToSchoolCheckbox setSelected:self.shareToSchoolHolder];
    [self.ShowRightAnswersCheckbox setSelected:self.showAnswersHolder];
    
    [self.Classification setText:self.classificationHolder];
    
    [client getQuestionWithID:self.ReviewerID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method
- (void)setReviewerID:(NSNumber *)ID QuestionTypeList:(NSArray *)list SubjectList:(NSArray *)slist
{
    [self setReviewerID:ID];
    [self setQuestionTypeList:list];
    [self setSubjectList:slist];
}

- (void)updateTitle:(NSString *)t
       Instructions:(NSString *)i
             Expiry:(NSString *)e
               Code:(NSString *)c
      ShareToPublic:(BOOL)stp
      ShareToSchool:(BOOL)sts
        ShowAnswers:(BOOL)sa
     Classification:(NSString *)cl
           Assigned:(NSArray *)a
{
    CurrentTitle = t;
    CurrentInstruction = i;
    
    [self setTitleHolder:t];
    [self setExpiryHolder:e];

    [self setCodeHolder:c];
    [self setShareToPublicHolder:stp];
    [self setShareToSchoolHolder:sts];
    [self setShowAnswersHolder:sa];
    [self setClassificationHolder:cl];
}

- (void) revertPageState
{
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:YES];
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

#pragma mark - IBAction
#pragma mark UIButton
- (IBAction)showStep:(UIButton *)sender
{
    NSMutableAttributedString * NFUlString;
    [sender setEnabled:NO];
    if (sender.tag == 3) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
        [self.NFButton setTag:3];
        [self.DetailsButton setEnabled:NO];
        [self.Step1Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step2];
        [self.view sendSubviewToBack:self.Step1];
    }
    //else if (sender.tag == 3) {
    else {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [self.NFButton setTag:1];
        [self.DetailsButton setEnabled:YES];
        [self.Step1Button setEnabled:NO];
        [self.view sendSubviewToBack:self.Detail];
        [self.view sendSubviewToBack:self.Step2];
    }
    /*else {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [self.NFButton setTag:2];
        [self.DetailsButton setEnabled:YES];
        [self.Step1Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Detail];
        [self.view sendSubviewToBack:self.Step1];
    }*/
    
    //[NFUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [NFUlString length])];
    [NFUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [NFUlString length])];
    [self.NFButton setAttributedTitle:NFUlString forState:UIControlStateNormal];
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

- (IBAction)nextFinish:(UIButton *)sender
{
    if (sender.tag == 3) {
        [self.NFButton setTag:1];
        [self.DetailsButton setEnabled:YES];
        [self.Step1Button setEnabled:NO];
        [self.Step2Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Detail];
        [self.view sendSubviewToBack:self.Step2];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        //[finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NFButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    /*else if (sender.tag == 1) {
        [self.NFButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:NO];
        [self.view sendSubviewToBack:self.Detail];
        [self.view sendSubviewToBack:self.Step1];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NFButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }*/
    else {
        NSString * assigneeString = @"";

        //NSLog(@"selected %d", self.KidsTable.indexPathsForSelectedRows.count);
        
        if ([self.KidsTable indexPathsForSelectedRows].count > 0) {
            for (NSIndexPath * ip in [self.KidsTable indexPathsForSelectedRows]) {
                Assignees * student = AssigneeList[ip.row];
                
                if (assigneeString.length==0) {
                    assigneeString = [assigneeString stringByAppendingString:student.ID];
                }
                else {
                    assigneeString = [assigneeString stringByAppendingString:[NSString stringWithFormat:@"+%@",student.ID]];
                }
            }
            
            [self showLoadingScreen];
            
            NSString * titleToSend = self.Title.text.length>0?self.Title.text:CurrentTitle.length>0?CurrentTitle:@"blank_0";
            
            if (isPhone) {
                [client pickReviewerWithQuestionID:self.ReviewerID
                                         Assigness:assigneeString.length>0?assigneeString:@"blank_0"
                                             Title:titleToSend
                                        Expiration:self.Expiry.text.length>0?self.Expiry.text:@"blank_0"
                                              Code:self.Code.text.length>0?self.Code.text:@"blank_0"
                                     ShareToPublic:[self.ShareToPublicCheckbox isSelected]
                                     ShareToSchool:[self.ShareToSchoolCheckbox isSelected]
                                  ShowRightAnswers:[self.ShowRightAnswersCheckbox isSelected]];
            }
            else {
                NSDateFormatter * format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"YYYY-MM-dd"];

                [client pickReviewerWithQuestionID:self.ReviewerID
                                         Assigness:assigneeString.length>0?assigneeString:@"blank_0"
                                             Title:titleToSend
                                        Expiration:[format stringFromDate:self.DatePicker.date]
                                              Code:self.Code.text.length>0?self.Code.text:@"blank_0"
                                     ShareToPublic:[self.ShareToPublicCheckbox isSelected]
                                     ShareToSchool:[self.ShareToSchoolCheckbox isSelected]
                                  ShowRightAnswers:[self.ShowRightAnswersCheckbox isSelected]];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"You must assign at least one (1) child to the reviewer"
                                       delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
        }
    }
}

- (IBAction)assignKid
{
    [self.KidsView setHidden:NO];
}

- (IBAction)doneAssigning
{
    [self.KidsView setHidden:YES];
}


#pragma mark UIPicker
- (IBAction)dropDown:(UIButton *)sender
{
    if (sender.tag==1) {
        [self.Picker setHidden:NO];
        [self.PickerToolbar setHidden:NO];
        [self.ToolbarDoneButton setTag:1];
    }
    else if (sender.tag==2) {
        [self.Picker setHidden:YES];
        [self.DatePicker setHidden:NO];
        [self.PickerToolbar setHidden:NO];
        [self.ToolbarDoneButton setTag:2];
    }
    else {
        [self.Step2Picker setHidden:NO];
        [self.Step2PickerToolbar setHidden:NO];
    }
}

- (IBAction)done:(UIButton *)sender
{
    if (sender.tag==1) {
        [self.Picker setHidden:YES];
        [self.PickerToolbar setHidden:YES];
        [self.Classification setText:self.SubjectList[Selected]];
    }
    else if (sender.tag==2) {
        [self.DatePicker setHidden:YES];
        [self.PickerToolbar setHidden:YES];
        
        NSDateFormatter * format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];
        [self.Expiry setText:[format stringFromDate:self.DatePicker.date]];
    }
    else {
        [self.Step2Picker setHidden:YES];
        [self.Step2PickerToolbar setHidden:YES];
        [self.QuestionType setText:self.QuestionTypeList[Step2Selected]];
    }
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    if ([self.Code isFirstResponder]) {
        [self.Code resignFirstResponder];
        [self.NextButton setEnabled:YES];
    }
}

- (IBAction)jumpToNext
{
    if ([self.Title isFirstResponder]) {
        [self.Title resignFirstResponder];
        [self.PreviousButton setEnabled:YES];
    }
}

- (IBAction)close
{
    if ([self.Title isFirstResponder]) {
        [self.Title resignFirstResponder];
    }
    else {
        [self.Code resignFirstResponder];
    }
    
    [self revertPageState];
}

#pragma mark - Data Source
#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerView.tag==1?self.SubjectList.count:self.QuestionTypeList.count;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag==1337?QuestionDetail.Questions.count:AssigneeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (tableView.tag==1337) {
        cell = cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTIONCELL"];
        
        if (cell == nil) {
            NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"PRLQuestionCell" owner:self options:nil];
            PRLQuestionCell *qCell = topObj[0];
            Question * qItem = QuestionDetail.Questions[indexPath.row];
            
            [qCell.Question setText:qItem.Question];
            [qCell.Right setText:qItem.Right];
            [qCell.Wrong setText:qItem.Wrong];
            
            cell = qCell;
        }
    }
    else {
        TDCheckboxCell *cCell = [tableView dequeueReusableCellWithIdentifier:@"CHECKBOXCELL"];
        
        if (cell == nil) {
            NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCheckboxCell" owner:self options:nil];
            cCell = topObj[0];
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CHECKBOXCELL"];
            //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        if ([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [cCell toggleCheckbox];
        }
        else {
            //[cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        if (AssigneeList.count>0) {
            Assignees * kid = AssigneeList[indexPath.row];
            
            //[cell.textLabel setText:kid.Name];
            [cCell.Section setText:kid.Name];
        }
        
        cell = cCell;
    }
    
    return cell;
}

#pragma mark - Delegate
#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerView.tag==1?self.SubjectList[row]:self.QuestionTypeList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        Selected = row;
    }
    else {
        Step2Selected = row;
    }
}

#pragma mark Alertview
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        NSArray * vcStack = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcStack[1] animated:YES];
    }
}

#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json
{
    [self hideLoadingScreen];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"You're reviewer has successfully been saved."
                                                     message:@"Go to My Reviewers to see your recently saved reviewer!"
                                                    delegate:self
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
    [alert setTag:1];
    [alert show];
    
    NSLog(@"%@",json);
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    [self hideLoadingScreen];
    NSLog(@"%@",error);
}

-(void)jakenpoyHTTPClientdidUpdateWithAssignees:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        [AssigneeList removeAllObjects];
        
        NSDictionary * data = json[@"data"][@"assignees"];
        
        for (NSString * key in data) {
            Assignees * item = [[Assignees alloc] init];
            [item setID:key];
            [item setName:data[key]];

            [AssigneeList addObject:item];
        }
        
        [self.KidsTable reloadData];
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithQuestionDetails:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSDictionary * qset = json[@"data"][@"question_set"];
        
        QuestionDetail = [[QuestionDetails alloc] init];
        
        [QuestionDetail setID:[NSNumber numberWithInteger:[qset[@"id"] integerValue]]];
        [QuestionDetail setTopicID:[NSNumber numberWithInteger:[qset[@"topic_id"] integerValue]]];
        [QuestionDetail setCreatedBy:[NSNumber numberWithInteger:[qset[@"created_by"] integerValue]]];
        [QuestionDetail setIsPublished:[qset[@"is_published"] boolValue]];
        [QuestionDetail setCanBeDeleted:[qset[@"can_be_deleted"] boolValue]];
        [QuestionDetail setShowAnswer:[qset[@"show_answer"] boolValue]];
        [QuestionDetail setShareToSchool:[qset[@"share_to_school"] boolValue]];
        [QuestionDetail setInstruction:qset[@"instruction"]];
        [QuestionDetail setType:qset[@"type"]];
        [QuestionDetail setTopic:qset[@"topic"]];
        [QuestionDetail setTitle:qset[@"title"]];
        [QuestionDetail setExpiry:qset[@"expiry"]];
        [QuestionDetail setQuestionType:qset[@"question_type"]];
        [QuestionDetail setSubject:qset[@"subject"]];
        [QuestionDetail setChallengeInfo:[Challenge challengeWithInfo:qset[@"challenge_info"]]];
        
        NSMutableArray * temp = [NSMutableArray arrayWithCapacity:[json[@"data"][@"questions"] count]];
        
        for (NSDictionary * qstn in json[@"data"][@"questions"]) {
            Question * item = [[Question alloc] init];
            
            [item setID:[NSNumber numberWithInteger:[qstn[@"id"] integerValue]]];
            [item setQuestion:qstn[@"text"]];
            [item setRight:qstn[@"right"]];
            [item setWrong:qstn[@"wrong"]];
            
            [temp addObject:item];
        }
        
        [QuestionDetail setQuestions:temp];
        
        [self.QuestionTitle setText:QuestionDetail.Title];
        [self.QuestionClassification setText:QuestionDetail.Subject];
        [self.QuestionTopic setText:QuestionDetail.Topic];
        [self.QuestionType setText:QuestionDetail.QuestionType];
        [self.QuestionInstructions setText:QuestionDetail.Instruction];
        [self.QuestionTable reloadData];
    }
}

#pragma mark UITableView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"PRLQuestionCell" owner:self options:nil];
    PRLQuestionCell * returnView = topObj[0];
    [returnView setBackgroundColor:[UIColor whiteColor]];
    
    return tableView.tag==1337?returnView:nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return tableView.tag!=1337?@"Choose Kid":nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @NO;
    if (tableView.tag==1337) {
        // Do nothing
    }
    else {
        //UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //[cell setAccessoryType:UITableViewCellAccessoryNone];
        
        TDCheckboxCell *cCell = (TDCheckboxCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cCell toggleCheckbox];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @YES;
    if (tableView.tag==1337) {
        // Do nothing
    }
    else {
        //UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        TDCheckboxCell *cCell = (TDCheckboxCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cCell toggleCheckbox];
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
    if (textField == self.Title) {
        [self.PreviousButton setEnabled:NO];
    }
    else if (textField == self.Code)  {
        [self.NextButton setEnabled:NO];
    }
}

@end
