//
//  PRLPickViewController.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/8/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLPickViewController : UIViewController <JakenpoyHTTPClientDelegate>
- (void)setReviewList:(NSArray *)list;
- (void)setQuestionTypeList:(NSArray *)list;
- (void)setSubjectList:(NSArray *)list;
@end
