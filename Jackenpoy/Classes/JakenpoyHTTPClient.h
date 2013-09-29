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
@property(strong) UserType * Type;
@property(weak) id<JakenpoyHTTPClientDelegate> delegate;

+ (JakenpoyHTTPClient *)getSharedClient;
- (void)logout;
- (id)initWithBaseURL:(NSURL *)url;
- (void)loginWithUsername:(NSString *)username Password:(NSString *)password;

//Pick a Reviewer from the Library
- (void)getQuestionType;
- (void)getGradeLevels;
- (void)getSubjects;
- (void)getAssignees;
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

// My Reviewers
- (void)getMyReviewers;
- (void)unpublish:(NSNumber *)ID;
- (void)publish:(NSNumber *)ID;
- (void)rateReviewer:(NSNumber *)ID Rating:(NSNumber *)rate;

// #pragma mark My Account
- (void)updateName:(NSString *)name Email:(NSString *)email Password:(NSString *)password;

// New
- (void)deactivateGuardian:(NSNumber *)ID;
- (void)kidReport:(NSNumber *)ID;
- (void)getManageKids;

@end

@protocol JakenpoyHTTPClientDelegate <NSObject>
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didUpdateWithData:(NSDictionary *)json;
-(void)jakenpoyHTTPClient:(JakenpoyHTTPClient *)client didFailWithError:(NSError *)error;

@optional
-(void)jakenpoyHTTPClientdidRateWithData:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithQuestionTypes:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithGradeLevels:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithSubjects:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithAssignees:(NSDictionary *)json;
-(void)jakenpoyHTTPClientdidUpdateWithKids:(NSDictionary *)json;
@end