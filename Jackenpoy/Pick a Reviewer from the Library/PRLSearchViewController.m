//
//  PRLSearchViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/8/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "PRLSearchViewController.h"
#import "PRLPickViewController.h"
#import "Reviewer.h"
#import "Challenge.h"

static const NSInteger CODEID = 1;
static const NSInteger AUTHORID = 2;

static JakenpoyHTTPClient * client;
static NSDictionary * GradeLevels;
static NSDictionary * Subjects;
static NSDictionary * QuestionTypes;

static NSInteger Selected;
static NSMutableArray * GradeLevelList;
static NSMutableArray * SubjectList;
static NSMutableArray * QuestionTypeList;
static BOOL isGradeLevel;
static BOOL isSubject;
static BOOL isQuestionType;

static NSInteger GradeLevelSelected;
static NSInteger SubjectSelected;
static NSInteger QuestionTypeSelected;

@interface PRLSearchViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *PickerToolbar;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PreviousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *NextButton;
@property (weak, nonatomic) IBOutlet UITextField *GradeLevel;
@property (weak, nonatomic) IBOutlet UITextField *Subject;
@property (weak, nonatomic) IBOutlet UITextField *QuestionType;
@property (weak, nonatomic) IBOutlet UITextField *Code;
@property (weak, nonatomic) IBOutlet UITextField *Author;

@property (weak, nonatomic) IBOutlet UIView *LoadingScreen;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Spinner;
@end

@implementation PRLSearchViewController

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
    
    Selected = 0;
    GradeLevelList = [[NSMutableArray alloc] initWithArray:@[@"No Grade Levels"]];
    SubjectList = [[NSMutableArray alloc] initWithArray:@[@"No Subjects"]];
    QuestionTypeList = [[NSMutableArray alloc] initWithArray:@[@"No Question Types"]];
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self.Code setInputAccessoryView:self.Toolbar];
    [self.Author setInputAccessoryView:self.Toolbar];
    
    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getGradeLevels];
    [client getSubjects];
    [client getQuestionType];
    
    isGradeLevel = NO;
    isSubject = NO;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Method
- (void)revertPageState
{
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:YES];
    [self scrollPageToPoint:ViewCenter.y];
}

- (void)scrollPageToPoint:(CGFloat)y
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setCenter:CGPointMake(ViewCenter.x, y)];
    }];
}

- (void)searchUsingCode:(NSInteger)code
{
    // Find by Code
    if (code == CODEID) {
        if (self.Code.text.length>=1) {
            [self showLoadingScreen];
            [client getReviewersWithGradeLevel:0
                                       Subject:0
                                  QuestionType:0
                                          Code:self.Code.text
                                        Author:@"blank_0"
                                         Limit:@"blank_0"
                                        Offset:@"blank_0"
                                          Sort:@"average"
                                     Ascending:@"DESC"];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Code Field Empty"
                                                             message:@"Please key in author's name"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
    }
    // Find by Author
    else {
        if (self.Author.text.length>=1) {
            [self showLoadingScreen];
            [client getReviewersWithGradeLevel:0
                                       Subject:0
                                  QuestionType:0
                                          Code:@"blank_0"
                                        Author:self.Author.text
                                         Limit:@"blank_0"
                                        Offset:@"blank_0"
                                          Sort:@"average"
                                     Ascending:@"DESC"];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Author Field Empty"
                                                             message:@"Please key in author's name"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
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

#pragma mark - IBActions
#pragma mark UIButton
- (IBAction)search
{
    NSString * gradeLvlID;
    NSString * subjectID;
    NSString * questionID;
    
    for (NSString * key in GradeLevels) {
        if ([GradeLevels[key] isEqualToString:GradeLevelList[GradeLevelSelected]]) {
            gradeLvlID = key;
        }
    }
    
    for (NSString * key in Subjects) {
        if ([Subjects[key] isEqualToString:SubjectList[SubjectSelected]]) {
            subjectID = key;
        }
    }
    
    for (NSString * key in QuestionTypes) {
        if ([QuestionTypes[key] isEqualToString:QuestionTypeList[QuestionTypeSelected]]) {
            questionID = key;
        }
    }
    
    [self showLoadingScreen];
    [client getReviewersWithGradeLevel:[gradeLvlID integerValue]
                               Subject:[subjectID integerValue]
                          QuestionType:[questionID integerValue]
                                  Code:@"blank_0"//self.Code.text
                                Author:@"blank_0"//self.Author.text
                                 Limit:@"blank_0"
                                Offset:@"blank_0"
                                  Sort:@"average"
                             Ascending:@"DESC"];
}

- (IBAction)go:(UIButton *)sender
{
    [self searchUsingCode:sender.tag];
    
    // For testing purposes
    /*PRLPickViewController * prlpvc = [[PRLPickViewController alloc] initWithNibName:@"PRLPickViewController" bundle:nil];
    [self.navigationController pushViewController:prlpvc animated:YES];*/
}

#pragma mark UIPicker
- (IBAction)dropDown:(UIButton *)sender
{
    [self.Picker setHidden:NO];
    [self.PickerToolbar setHidden:NO];
    
    isGradeLevel = NO;
    isSubject = NO;
    isQuestionType = NO;
    
    switch (sender.tag) {
        case 1:
            isGradeLevel = YES;
            break;
        case 2:
            isSubject = YES;
            break;
        case 3:
            isQuestionType = YES;
            break;
        default:
            break;
    };
    
    [self.Picker reloadAllComponents];
    
    // Check if drop down list count is less than current selected row
    if (isGradeLevel) {
        Selected = GradeLevelList.count<=Selected ? GradeLevelList.count-1:Selected;
    }
    else if (isSubject) {
        Selected = SubjectList.count<=Selected ? SubjectList.count-1:Selected;
    }
    else {
        Selected = QuestionTypeList.count<=Selected ? QuestionTypeList.count-1:Selected;
    }
    
    if ((isGradeLevel&&GradeLevelList.count>0) || (isSubject&&SubjectList.count>0) || (isQuestionType&&QuestionTypeList.count>0)) {
        [self.Picker selectRow:Selected inComponent:0 animated:NO];
    }
}

- (IBAction)done
{
    [self.Picker setHidden:YES];
    [self.PickerToolbar setHidden:YES];

    if (isGradeLevel && GradeLevelList.count>0) {
        GradeLevelSelected = Selected;
        [self.GradeLevel setText:GradeLevelList[Selected]];
    }
    else if (isSubject && SubjectList.count>0) {
        SubjectSelected = Selected;
        [self.Subject setText:SubjectList[Selected]];
    }
    else if (isQuestionType && QuestionTypeList.count>0) {
        QuestionTypeSelected = Selected;
        [self.QuestionType setText:QuestionTypeList[Selected]];
    }
}

#pragma mark UIToolbar
- (IBAction)jumpToPrevious
{
    [self.PreviousButton setEnabled:NO];
    [self.NextButton setEnabled:YES];
    
    [self.Author resignFirstResponder];
    [self.Code becomeFirstResponder];
}

- (IBAction)jumpToNext
{
    [self.PreviousButton setEnabled:YES];
    [self.NextButton setEnabled:NO];
    
    [self.Code resignFirstResponder];
    [self.Author becomeFirstResponder];
}

- (IBAction)close
{
    if ([self.Code isFirstResponder]) {
        [self.Code resignFirstResponder];
    }
    else {
        [self.Author resignFirstResponder];
    }
    
    [self revertPageState];
}

#pragma mark - UIPickerView Data Source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return isPhone?1:3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger returnRow;
    
    if (isPhone) {
        returnRow = isGradeLevel?GradeLevelList.count:isSubject?SubjectList.count:QuestionTypeList.count;
    }
    else {
        returnRow = component==0?GradeLevelList.count:component==1?SubjectList.count:QuestionTypeList.count;
    }
    
    return returnRow;
}

#pragma mark - Delegate
#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self revertPageState];
    
    if (textField == self.Code) {
        [self searchUsingCode:CODEID];
    }
    else if (textField == self.Author) {
        [self searchUsingCode:AUTHORID];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self scrollPageToPoint:-20];
    
    if (textField == self.Code) {
        [self.PreviousButton setEnabled:NO];
    }
    else {
        [self.NextButton setEnabled:NO];
    }
}

#pragma mark UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * rowString;
    
    if (isPhone) {
        rowString = isGradeLevel?GradeLevelList[row]:isSubject?SubjectList[row]:QuestionTypeList[row];
    }
    else {

        rowString = component==0?GradeLevelList[row]:component==1?SubjectList[row]:QuestionTypeList[row];
    }
    
    return rowString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (isPhone) {
        Selected = row;
    }
    else {
        switch (component) {
            case 0:
                GradeLevelSelected = row;
                break;
            case 1:
                SubjectSelected = row;
                break;
            case 2:
                QuestionTypeSelected = row;
                break;
            default:
                break;
        }
    }
}

#pragma mark JakenpoyHTTPClient
-(void)jakenpoyHTTPClientdidUpdateWithQuestionTypes:(NSDictionary *)json
{
    for (NSString * key in json) NSLog(@"QT:%@ %@",key, json[key]);
    
    if ([json[@"status"] isEqualToString:@"success"]) {
        //NSLog(@"%@",[json[@"data"][@"question_types_name"] class]);
        
        QuestionTypes = json[@"data"][@"question_types_name"];
        [QuestionTypeList removeAllObjects];
        
        NSArray *sortedKeys = [QuestionTypes allKeys];
        sortedKeys = [sortedKeys sortedArrayUsingComparator:^(id a, id b) {
            return [a compare:b options:NSNumericSearch];
        }];
        
        for (NSString * key in sortedKeys) {
            [QuestionTypeList addObject:QuestionTypes[key]];
        }
        
        if (isPhone) {
            if (isQuestionType) {
                [self.Picker reloadAllComponents];
            }
        }
        else {
            [self.Picker reloadComponent:2];
        }
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithGradeLevels:(NSDictionary *)json
{
    //for (NSString * key in json) NSLog(@"GL:%@ %@",key, json[key]);
    
    if ([json[@"status"] isEqualToString:@"success"]) {
        //NSLog(@"%@",json[@"data"][@"grade_levels_name"]);
        
        GradeLevels = json[@"data"][@"grade_levels_name"];
        [GradeLevelList removeAllObjects];
        
        NSArray *sortedKeys = [GradeLevels allKeys];
        sortedKeys = [sortedKeys sortedArrayUsingComparator:^(id a, id b) {
            return [a compare:b options:NSNumericSearch];
        }];
        
        for (NSString * key in sortedKeys) {
            [GradeLevelList addObject:GradeLevels[key]];
        }
        
        if (isPhone) {
            if (isGradeLevel) {
                [self.Picker reloadAllComponents];
            }
        }
        else {
            [self.Picker reloadComponent:0];
        }
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithSubjects:(NSDictionary *)json
{
    //for (NSString * key in json) NSLog(@"S:%@ %@",key, json[key]);
    
    if ([json[@"status"] isEqualToString:@"success"]) {
        //NSLog(@"%@",json[@"data"][@"subjects"]);
        
        Subjects = json[@"data"][@"subjects"];
        [SubjectList removeAllObjects];
        
        NSArray *sortedKeys = [Subjects allKeys];
        sortedKeys = [sortedKeys sortedArrayUsingComparator:^(id a, id b) {
            return [a compare:b options:NSNumericSearch];
        }];
        
        for (NSString * key in sortedKeys) {
            [SubjectList addObject:Subjects[key]];
        }
        
        if (isPhone) {
            if (isSubject) {
                [self.Picker reloadAllComponents];
            }
        }
        else {
            [self.Picker reloadComponent:1];
        }
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json
{    
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"];
        NSMutableArray * reviewerList = [[NSMutableArray alloc] init];
        //NSLog(@"%@",json);
        for (NSDictionary * reviewer in data) {
            Reviewer * item = [[Reviewer alloc] init];
            [item setName:reviewer[@"name"]];
            [item setCreatedBy:[NSNumber numberWithInteger:[reviewer[@"created_by"] integerValue]]];
            [item setID:[NSNumber numberWithInteger:[reviewer[@"id"] integerValue]]];
            [item setTopicID:[reviewer[@"topic_id"] intValue]];
            [item setRating:[reviewer[@"rating"] integerValue]];
            [item setAverage:[reviewer[@"average"] floatValue]];
            [item setInfo:[Challenge challengeWithInfo:reviewer[@"challenge_info"]]];

            [reviewerList addObject:item];
        }
        
        [self hideLoadingScreen];
        PRLPickViewController * prlpvc = [[PRLPickViewController alloc] initWithNibName:@"PRLPickViewController" bundle:nil List:reviewerList];
        [self.navigationController pushViewController:prlpvc animated:YES];
        [prlpvc setQuestionTypeList:QuestionTypeList];
        [prlpvc setSubjectList:SubjectList];
        
        [prlpvc setReviewList:reviewerList];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    [self hideLoadingScreen];
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
