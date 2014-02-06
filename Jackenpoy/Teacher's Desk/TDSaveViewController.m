
//
//  TDSaveViewController.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/15/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDSaveViewController.h"
#import "SVSegmentedControl.h"
#import "TDCheckboxCell.h"
#import "ReviewerCell.h"
#import "Teacher.h"

static JakenpoyHTTPClient * client;
static NSMutableArray * SubjectList;
static NSMutableArray * TeacherList;
static NSDictionary * Subjects;
static NSDictionary * GradeLevels;
static NSInteger SubjectSelected;
static NSInteger TeacherSelected;
static NSString * GradeLevel;

@interface TDSaveViewController ()
@property (weak, nonatomic) IBOutlet UIView *Step1;
@property (weak, nonatomic) IBOutlet UIView *Step2;
@property (weak, nonatomic) IBOutlet UIView *Step3;
@property (weak, nonatomic) IBOutlet UIButton *Step1Button;
@property (weak, nonatomic) IBOutlet UIButton *Step2Button;
@property (weak, nonatomic) IBOutlet UIButton *Step3Button;
@property (weak, nonatomic) IBOutlet UIButton *NSButton;
@property (weak, nonatomic) IBOutlet UIButton *AddEditButton;
@property (weak, nonatomic) IBOutlet UITableView *CheckboxTable;
@property (weak, nonatomic) IBOutlet UILabel *Header;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *SubjectLabel;
@property (weak, nonatomic) IBOutlet UITextField *TitleField;
@property (weak, nonatomic) IBOutlet UILabel *TeacherLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;

@property (strong, nonatomic) NSString * titleHolder;
@property (strong, nonatomic) NSNumber * subjectID;
@property (strong, nonatomic) NSNumber * teacherID;
@property (strong, nonatomic) NSNumber * lessonPlanID;
@property (strong, nonatomic) NSNumber * sectionID;
@property (assign, nonatomic) BOOL isEditLessonPlan;
@property (assign, nonatomic) BOOL isEditSection;
@property (assign, nonatomic) BOOL isAddSection;
@end

@implementation TDSaveViewController

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

    client = [JakenpoyHTTPClient getSharedClient];
    [client setDelegate:self];
    [client getSubjects];
    [client getTeachers];
    
    SubjectSelected = 0;
    TeacherSelected = 0;
    SubjectList = [[NSMutableArray alloc] initWithArray:@[@"Araling Panlipunan", @"Civics", @"Filipino", @"Language", @"Math", @"Science", @"Unclassified"]];
    TeacherList = [[NSMutableArray alloc] init];
    
    SVSegmentedControl * jackenpoySC = [[SVSegmentedControl alloc] initWithSectionTitles:@[@"Customized",@"Jakenpoy Default"]];
    [jackenpoySC setHeight:45];
    [jackenpoySC.thumb setTintColor:[UIColor colorWithRed:1 green:0.76 blue:0.57 alpha:1]];
    [jackenpoySC.thumb setTextColor:[UIColor blackColor]];
    
    [self.Step2 addSubview:jackenpoySC];
    
    [jackenpoySC setCenter:CGPointMake(isPhone?160:360, isPhone?70:100)];
    
    /*NSMutableAttributedString * nextUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
    [nextUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [nextUlString length])];
    [nextUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [nextUlString length])];
    [self.NSButton setAttributedTitle:nextUlString forState:UIControlStateNormal];*/
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isEditLessonPlan) {
        [self.Header setText:@"Edit a Lesson Plan"];
        [self.Title setText:@"Lesson Plan Title"];
        [self.AddEditButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else if (self.isEditSection) {
        [self.Header setText:@"Edit Section"];
        [self.Title setText:@"Section Title"];
        [self.SubjectLabel setText:@"Grade Level"];
        [self.AddEditButton setTitle:@"Edit" forState:UIControlStateNormal];
        
        [self.TeacherLabel setHidden:NO];
        [client getGradeLevels];
    }
    else if (self.isAddSection) {
        [self.Header setText:@"Add Section"];
        [self.Title setText:@"Section Title"];
        [self.SubjectLabel setText:@"Grade Level"];
        [self.AddEditButton setTitle:@"Add" forState:UIControlStateNormal];
        
        [self.TeacherLabel setHidden:NO];
        [client getGradeLevels];
    }
    
    [self.TitleField setText:self.titleHolder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (void)updateTitle:(NSString *)title Subject:(NSNumber *)sid Teacher:(NSNumber *)tid LessonPlan:(NSNumber *)lid
{
    [self setTitleHolder:title];
    [self setSubjectID:sid];
    [self setTeacherID:tid];
    [self setLessonPlanID:lid];
}

- (void)setToAddSection {
    [self setIsAddSection:YES];
}

- (void)setToEditLessonPlan
{
    [self setIsEditLessonPlan:YES];
}

- (void)editSectionName:(NSString *)name GradeLevel:(NSString *)grade WithID:(NSNumber *)sid
{
    [self setIsEditSection:YES];
    [self setTitleHolder:name];
    [self setSectionID:sid];
    
    GradeLevel = grade;
}

#pragma mark - IBAction
- (IBAction)showStep:(UIButton *)sender
{
    NSMutableAttributedString * NFUlString;
    [sender setEnabled:NO];
    
    if (sender.tag == 1) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
        [self.NSButton setTag:1];
        [self.Step2Button setEnabled:YES];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step2];
        [self.view sendSubviewToBack:self.Step3];
    }
    else if (sender.tag == 2) {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
        [self.NSButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step3];
    }
    else {
        NFUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [self.NSButton setTag:3];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step2];
    }
    
    [NFUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [NFUlString length])];
    [NFUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [NFUlString length])];
    [self.NSButton setAttributedTitle:NFUlString forState:UIControlStateNormal];
}

- (IBAction)nextSave:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self.NSButton setTag:2];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:NO];
        [self.Step3Button setEnabled:YES];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step3];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"Next"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NSButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    else if (sender.tag == 2) {
        [self.NSButton setTag:3];
        [self.Step1Button setEnabled:YES];
        [self.Step2Button setEnabled:YES];
        [self.Step3Button setEnabled:NO];
        [self.view sendSubviewToBack:self.Step1];
        [self.view sendSubviewToBack:self.Step2];
        
        NSMutableAttributedString * finUlString = [[NSMutableAttributedString alloc] initWithString:@"Save"];
        [finUlString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [finUlString length])];
        [finUlString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [finUlString length])];
        [self.NSButton setAttributedTitle:finUlString forState:UIControlStateNormal];
    }
    else {
        NSArray * vcStack = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcStack[1] animated:YES];
        
        for (NSIndexPath * ip in [self.CheckboxTable indexPathsForSelectedRows]) {
            //NSLog(@"%d",ip.row);
        }
    }
}

- (IBAction)addLessonPlan
{
    if (self.isEditLessonPlan) {
        for (NSString * key in Subjects) {
            if ([Subjects[key] isEqualToString:SubjectList[SubjectSelected]]) {
                [self setSubjectID:[NSNumber numberWithInteger:[key integerValue]]];
            }
        }
        [client editLessonPlan:self.lessonPlanID WithSubject:self.subjectID Teacher:self.teacherID Name:self.TitleField.text];
    }
    else if (self.isAddSection) {
        Teacher * teacher = TeacherList[TeacherSelected];
        [client addSectionWithName:self.TitleField.text Teacher:teacher.ID GradeLevel:[NSString stringWithFormat:@"%d",SubjectSelected+1]];
    }
    else if (self.isEditSection) {
        Teacher * teacher = TeacherList[TeacherSelected];
        [client editName:self.TitleField.text Teacher:teacher.ID GradeLevel:[NSString stringWithFormat:@"%d",SubjectSelected+1] ForSection:self.sectionID];
    }
    // Add Lesson Plan
    else {
        for (NSString * key in Subjects) {
            if ([Subjects[key] isEqualToString:SubjectList[SubjectSelected]]) {
                [self setSubjectID:[NSNumber numberWithInteger:[key integerValue]]];
            }
        }
        [client addLessonPlanWithTitle:self.TitleField.text ForSubject:self.subjectID];
    }
}

- (IBAction)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Data Source
#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return (self.isEditSection||self.isAddSection)?2:1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowNumber = 0;
    
    if (self.isEditSection || self.isAddSection) {
        rowNumber = component==0?SubjectList.count:TeacherList.count;
    }
    else {
        rowNumber = SubjectList.count;
    }
    
    return rowNumber;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TDCheckboxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHECKBOXCELL"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CHECKBOXCELL"];
    
    if (cell == nil) {
        //NSArray *topObj = [[NSBundle mainBundle] loadNibNamed:@"TDCheckboxCell" owner:self options:nil];
        //cell = topObj[0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CHECKBOXCELL"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    //[cell.Section setText:[NSString stringWithFormat:@"Section %d",indexPath.row]];
    [cell.textLabel setText:[NSString stringWithFormat:@"Section %d",indexPath.row]];

    return cell;
}

#pragma mark - Delegate
#pragma mark UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark UIPickerView
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString * body;
    
    if (self.isEditSection || self.isAddSection) {
        if (TeacherList.count>0) {
            Teacher * item = TeacherList[row];
            body = [[NSMutableAttributedString alloc] initWithString:component==0?SubjectList[row]:item.Name];
        }
    }
    else {
        body  = [[NSMutableAttributedString alloc] initWithString:SubjectList[row]];
    }
    
    [body addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.isEditSection?15:12] range:NSMakeRange(0, [body length])];

    return body;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        SubjectSelected = row;
    }
    else {
        TeacherSelected = row;
    }
}

#pragma mark UITableView
/*- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @NO;
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CheckedList[indexPath.row] = @YES;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}*/

#pragma mark JakenpoyHTTPClient Delegate
-(void)jakenpoyHTTPClientdidUpdateWithGradeLevels:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        GradeLevels = json[@"data"][@"grade_levels_name"];
        [SubjectList removeAllObjects];
        
        NSArray *sortedKeys = [GradeLevels allKeys];
        sortedKeys = [sortedKeys sortedArrayUsingComparator:^(id a, id b) {
            return [a compare:b options:NSNumericSearch];
        }];
        
        /*for (NSString * key in sortedKeys) {
         [GradeLevelList addObject:GradeLevels[key]];
         }*/
        
        SubjectList = [NSMutableArray arrayWithArray:@[@"Grade 1", @"Grade 2", @"Grade 3", @"Grade 4", @"Grade 5", @"Grade 6", @"Grade 7"]];
        
        [self.Picker reloadAllComponents];
        
        if (self.isEditSection) {
            [client getSection:self.sectionID];
        }
    }
}

- (void)jakenpoyHTTPClientdidUpdateWithSection:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:json[@"data"][@"section"]];
        
        [self.Picker selectRow:[tempDict[@"grade_level"] integerValue]-1 inComponent:0 animated:NO];
        [self setTeacherID:[NSNumber numberWithInteger:[tempDict[@"teacher_id"] integerValue]]];
        
        for (Teacher * teacher in TeacherList) {
            if ([teacher.ID isEqualToNumber:self.teacherID]) {
                [self.Picker selectRow:[TeacherList indexOfObject:teacher] inComponent:1 animated:NO];
            }
        }
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(id)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithSubjects:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        //NSLog(@"%@",json[@"data"][@"subjects"]);
        
        NSMutableDictionary * tempArr = [NSMutableDictionary dictionaryWithDictionary:json[@"data"][@"subjects"]];
        [tempArr removeObjectForKey:@"0"];
        Subjects = tempArr;
        //[SubjectList removeAllObjects];
        
        NSArray *sortedKeys = [Subjects allKeys];
        sortedKeys = [sortedKeys sortedArrayUsingComparator:^(id a, id b) {
            return [a compare:b options:NSNumericSearch];
        }];
        
        /*for (NSString * key in sortedKeys) {
            [SubjectList addObject:Subjects[key]];
        }*/
        
        [self.Picker reloadComponent:0];
        
        for (NSString * subject in SubjectList) {
            if ([subject isEqualToString:Subjects[self.subjectID]]) {
                //NSLog(@"row is %d",[SubjectList indexOfObject:subject]);
                
                [self.Picker selectRow:[SubjectList indexOfObject:subject] inComponent:0 animated:NO];
            }
        }
    }
}

-(void)jakenpoyHTTPClientdidUpdateWithTeachers:(NSDictionary *)json
{
    if ([json[@"status"] isEqualToString:@"success"]) {
        NSArray * data = json[@"data"][@"teachers"];
        [TeacherList removeAllObjects];
        
        for (NSDictionary * teacher in data) {
            Teacher * item = [[Teacher alloc] init];
            
            [item setIsAdmin:[teacher[@"is_admin"] boolValue]];
            [item setID:[NSNumber numberWithInteger:[teacher[@"id"] integerValue]]];
            [item setSchoolID:[NSNumber numberWithInteger:[teacher[@"school_id"] integerValue]]];
            [item setEmail:teacher[@"email"]];
            [item setName:teacher[@"name"]];
            
            [TeacherList addObject:item];
        }
        
        if (self.isEditSection) [self.Picker reloadComponent:1];
    }
}

-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"E:%@",error);
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Searching" message:@"Make sure you are connected to the internet and please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
