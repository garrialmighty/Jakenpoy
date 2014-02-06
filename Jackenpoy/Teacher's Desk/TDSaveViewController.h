//
//  TDSaveViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/15/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDSaveViewControllerDelegate;

@interface TDSaveViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, JakenpoyHTTPClientDelegate>
@property(weak) id<TDSaveViewControllerDelegate> delegate;

- (void)updateTitle:(NSString *)title Subject:(NSNumber *)sid Teacher:(NSNumber *)tid LessonPlan:(NSNumber *)lid;
- (void)setToAddSection;
- (void)setToEditLessonPlan;
- (void)editSectionName:(NSString *)name GradeLevel:(NSString *)grade WithID:(NSNumber *)sid;
@end