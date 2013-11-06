//
//  PRLPickViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/8/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLPickViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JakenpoyHTTPClientDelegate>
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil List:(NSArray *)list;
- (void)setReviewList:(NSArray *)list;
- (void)setQuestionTypeList:(NSArray *)list;
- (void)setSubjectList:(NSArray *)list;
@end
