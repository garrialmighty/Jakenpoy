//
//  TDSaveViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/15/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDSaveViewControllerDelegate;

@interface TDSaveViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, JakenpoyHTTPClientDelegate>
@property(weak) id<TDSaveViewControllerDelegate> delegate;

- (void)updateTitle:(NSString *)title Subject:(NSNumber *)sid Teacher:(NSNumber *)tid LessonPlan:(NSNumber *)lid;
- (void)setToEdit;
- (void)updateViewForAdmin;
@end

@protocol TDSaveViewControllerDelegate <NSObject>
-(void)tdDSaveViewControllerDelegateDidSave;
@end