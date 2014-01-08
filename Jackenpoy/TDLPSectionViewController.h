//
//  TDLPSectionViewController.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 1/8/14.
//  Copyright (c) 2014 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDLPSectionViewController : UIViewController <JakenpoyHTTPClientDelegate>
- (void)setLessonPlanID:(NSNumber *)lpid;
@end
