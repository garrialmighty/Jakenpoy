//
//  PRLFinishViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/14/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLFinishViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, JakenpoyHTTPClientDelegate, UIAlertViewDelegate>
- (void)setReviewerID:(NSNumber *)ID QuestionTypeList:(NSArray *)list SubjectList:(NSArray *)slist;
- (void)updateTitle:(NSString *)t
       Instructions:(NSString *)i
             Expiry:(NSString *)e
               Code:(uint)c
      ShareToPublic:(BOOL)stp
      ShareToSchool:(BOOL)sts
        ShowAnswers:(BOOL)sa
     Classification:(uint)cl
           Assigned:(NSArray *)a;
@end
