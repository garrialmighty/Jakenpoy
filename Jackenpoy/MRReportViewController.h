//
//  MRReportViewController.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/13/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JakenpoyHTTPClientDelegate>
- (void)setReviewerID:(NSNumber *)rid;
@end
