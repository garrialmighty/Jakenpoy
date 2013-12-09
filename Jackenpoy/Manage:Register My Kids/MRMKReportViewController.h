//
//  MRMKReportViewController.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/6/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRMKReportViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JakenpoyHTTPClientDelegate>
- (void)setKidID:(NSNumber *)ID;
@end
