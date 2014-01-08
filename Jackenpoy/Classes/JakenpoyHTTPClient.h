//
//  JakenpoyHTTPClient.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "AFHTTPClient.h"
#import "UserType.h"

@protocol JakenpoyHTTPClientDelegate;

@interface JakenpoyHTTPClient : AFHTTPClient

@property(strong) NSString * UserID;
@property(strong) NSString * Token;
@property(strong) NSString * UserName;
@property(assign) NSInteger LoginErrorFlag;
@property(assign) BOOL isAdmin;
@property(strong) UserType * Type;
@property(weak) id<JakenpoyHTTPClientDelegate> delegate;

+ (JakenpoyHTTPClient *)getSharedClient;
- (void)logout;
- (id)initWithBaseURL:(NSURL *)url;

// Login
- (void)loginWithUsername:(NSString *)username Password:(NSString *)password;
- (void)createAccountUsingEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password Type:(NSString *)type School:(NSNumber *)schoolid;
- (void)getSchools;

// My Reviewers
- (void)getMyReviewers;
- (void)getReportForReviewer:(NSNumber *)ID;
- (void)unpublish:(NSNumber *)ID;
- (void)publish:(NSNumber *)ID;
- (void)rateReviewer:(NSNumber *)ID Rating:(NSNumber *)rate;
- (void)getPDFLink:(NSNumber *)ID;
- (void)getAnalysisForReviewer:(NSNumber *)ID;

//Pick a Reviewer from the Library
- (void)getQuestionType;
- (void)getGradeLevels;
- (void)getSubjects;
- (void)getAssignees;
- (void)getQuestionWithID:(NSNumber *)qid;
- (void)getReviewersWithGradeLevel:(NSInteger)gl
                           Subject:(NSInteger)sbj
                      QuestionType:(NSInteger)qt
                              Code:(NSString *)code
                            Author:(NSString *)a
                             Limit:(NSString *)l
                            Offset:(NSString *)o
                              Sort:(NSString *)sort
                         Ascending:(NSString *)asc;

- (void)pickReviewerWithQuestionID:(NSNumber *)qid
                         Assigness:(NSString *)a
                             Title:(NSString *)t
                        Expiration:(NSString *)e
                              Code:(NSString *)c
                     ShareToPublic:(BOOL)stp
                     ShareToSchool:(BOOL)sts
                  ShowRightAnswers:(BOOL)sa;

// Teacher's Desk
- (void)getLessonPlans;
- (void)getAvailableSections;
- (void)getSectionsForLessonPlan:(NSNumber *)sid;
- (void)addSection:(NSNumber *)sid ToLessonPlan:(NSNumber *)lid; //TO TEST
- (void)getLessonPlan:(NSNumber *)lid;
- (void)getTeachers;
- (void)saveLessonPlan:(NSNumber *)lid WithSubject:(NSNumber *)sid Teacher:(NSNumber *)tid Name:(NSString *)name;

// Manage/Register My Kids
- (void)deactivateGuardian:(NSNumber *)ID;
- (void)kidReport:(NSNumber *)ID;
- (void)studentReport:(NSNumber *)ID;
- (void)getManageKids;

// My Account
- (void)updateName:(NSString *)name Email:(NSString *)email Password:(NSString *)password;

@end

@protocol JakenpoyHTTPClientDelegate <NSObject>
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json;
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error;

@optional
-(void)jakenpoyHTTPClientdidCreateAccount:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidRateWithData:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithSchools:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithTeachers:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithQuestionTypes:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithGradeLevels:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithSubjects:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithAssignees:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithKids:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithQuestionDetails:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithPDFLink:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithLessonPlan:(NSDictionary *)json;
@end