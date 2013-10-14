//
//  HPFinishViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPFinishViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, JakenpoyHTTPClientDelegate>
- (void)setEmail:(NSString *)email Name:(NSString *)name Password:(NSString *)password Type:(NSString *)type;
@end
