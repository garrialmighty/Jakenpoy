//
//  MRAnalysisViewController.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/5/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRAnalysisViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JakenpoyHTTPClientDelegate>
- (void)setReviewerID:(NSNumber *)rid;
@end
