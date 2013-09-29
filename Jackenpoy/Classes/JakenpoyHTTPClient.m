//
//  JakenpoyHTTPClient.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

static NSString *const BaseURL = @"http://pta.jakenpoy.com/api/";

#import "JakenpoyHTTPClient.h"
#import "AppDelegate.h"

@implementation JakenpoyHTTPClient

+ (JakenpoyHTTPClient *)getSharedClient
{
    static dispatch_once_t pred;
    static JakenpoyHTTPClient *_sharedHTTPClient = nil;
    
    dispatch_once(&pred, ^{ _sharedHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURL]]; });
    
    return _sharedHTTPClient;
}

- (void)logout
{
    [self setUserID:@""];
    [self setToken:@""];
    [self setUserName:@""];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

#pragma mark - Web Services
- (void)loginWithUsername:(NSString *)username Password:(NSString *)password
{
    NSLog(@"logging in");
    [self postPath:@"loginservice"
        parameters:@{@"username":username, @"password":password}
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               //NSLog(@"%@ %@",responseObject[@"user_id"], responseObject[@"token"]);
               NSLog(@"%@",responseObject);
               
               if ([responseObject count]>0) {
                   if ([responseObject[@"status"] isEqualToString:@"success"]) {
                       [self setToken:responseObject[@"token"]];
                       [self setUserID:responseObject[@"user_id"]];
                       [self setUserName:responseObject[@"name"]];
                       [self setType:[UserType userTypeWithRole:responseObject[@"roles"]]];
                       
                       // Enable going to menu
                       AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                       [delegate showMenuButtons];

                       if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)]) {
                           [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
                       }
                   }
                   else {
                       UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Loggin in" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       [alert show];
                   }
                   
               }
               else {
                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Server Error"
                                         //message:[NSString stringWithFormat:@"%@",error]
                                                                   message:@"Please try again."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                   [alert show];

               }
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Logging in"
                                     //message:[NSString stringWithFormat:@"%@",error]
                                                               message:@"There was an error logging in. Make sure you have internet access and try again."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
               [alert show];
           }];
}

#pragma mark Pick a Reviewer from the Library
- (void)getQuestionType
{
    NSLog(@"getting question type");
    [self getPath:@"getQuestionType"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidUpdateWithQuestionTypes:)]) {
                  [self.delegate jakenpoyHTTPClientdidUpdateWithQuestionTypes:responseObject];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)getGradeLevels
{
    NSLog(@"getting grade levels");
    [self getPath:@"getGradeLevels"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidUpdateWithGradeLevels:)])
                  [self.delegate jakenpoyHTTPClientdidUpdateWithGradeLevels:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)getSubjects
{
    NSLog(@"getting subject");
    [self getPath:@"getSubjects"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidUpdateWithSubjects:)])
                  [self.delegate jakenpoyHTTPClientdidUpdateWithSubjects:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)getAssignees
{
    NSLog(@"getting assigness");
    [self getPath:@"getAssignees"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidUpdateWithAssignees:)])
                  [self.delegate jakenpoyHTTPClientdidUpdateWithAssignees:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)getReviewersWithGradeLevel:(NSInteger)gl
                           Subject:(NSInteger)sbj
                      QuestionType:(NSInteger)qt
                              Code:(NSString *)code
                            Author:(NSString *)a
                             Limit:(NSString *)l
                            Offset:(NSString *)o
                              Sort:(NSString *)sort
                         Ascending:(NSString *)asc
{
    NSLog(@"getting reviewers");
    [self getPath:@"getReviewers"
       parameters:@{@"gradelevel":[NSString stringWithFormat:@"%d",gl], @"subject":[NSString stringWithFormat:@"%d",sbj], @"questiontype":[NSString stringWithFormat:@"%d",qt], @"code":code, @"author":a, @"limit":l, @"offset":o, @"sort":sort, @"asc":asc, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)pickReviewerWithQuestionID:(NSNumber *)qid
                         Assigness:(NSString *)a
                             Title:(NSString *)t
                        Expiration:(NSString *)e
                              Code:(NSString *)c
                     ShareToPublic:(BOOL)stp
                     ShareToSchool:(BOOL)sts
                  ShowRightAnswers:(BOOL)sa
{
    NSLog(@"picking reviewers");
    [self getPath:@"pickReviewer"
       parameters:@{@"qSetId":qid, @"assignees":a, @"title":t,  @"expiration":e, @"code":c, @"share_public":[NSString stringWithFormat:@"%d",stp], @"share_school":[NSString stringWithFormat:@"%d",sts], @"show_answers":[NSString stringWithFormat:@"%d",sa], @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"%@",responseObject);
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

#pragma mark My Reviewers
- (void)getMyReviewers
{
    NSLog(@"getting my reviewers");
    [self getPath:@"getMyReviewers"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)unpublish:(NSNumber *)ID
{
    NSLog(@"unpublishing");
    [self getPath:@"unpublish"
       parameters:@{@"qsetId":ID, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)publish:(NSNumber *)ID
{
    NSLog(@"publishing");
    [self getPath:@"publish"
       parameters:@{@"qsetId":ID, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)rateReviewer:(NSNumber *)ID Rating:(NSNumber *)rate
{
    NSLog(@"rating");
    [self getPath:@"rate"
       parameters:@{@"qsetId":ID, @"rate":rate, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidRateWithData:)])
                  [self.delegate jakenpoyHTTPClientdidRateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

#pragma mark My Account
- (void)updateName:(NSString *)name Email:(NSString *)email Password:(NSString *)password
{
    NSLog(@"updating account");
    [self getPath:@"updateAccount"
       parameters:@{@"name":name, @"currentpassword":password, @"email":email, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)deactivateGuardian:(NSNumber *)ID
{
    NSLog(@"deactivating");
    [self getPath:@"guardianDeactivate"
       parameters:@{@"student_account_id":ID, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)kidReport:(NSNumber *)ID
{
    NSLog(@"reporting");
    [self getPath:@"kidReport"
       parameters:@{@"student_account_id":ID, @"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didUpdateWithData:)])
                  [self.delegate jakenpoyHTTPClient:self didUpdateWithData:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];
}

- (void)getManageKids
{
    NSLog(@"getting kids");
    [self getPath:@"getManageKids"
       parameters:@{@"userId":self.UserID, @"token":self.Token}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClientdidUpdateWithKids:)])
                  [self.delegate jakenpoyHTTPClientdidUpdateWithKids:responseObject];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if([self.delegate respondsToSelector:@selector(jakenpoyHTTPClient:didFailWithError:)])
                  [self.delegate jakenpoyHTTPClient:self didFailWithError:error];
          }];

}

@end
