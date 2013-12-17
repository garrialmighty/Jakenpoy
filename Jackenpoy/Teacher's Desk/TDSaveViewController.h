//
//  TDSaveViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/15/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDSaveViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, JakenpoyHTTPClientDelegate>
- (void)updateTitle:(NSString *)title;
- (void)updateViewForAdmin;
@end
