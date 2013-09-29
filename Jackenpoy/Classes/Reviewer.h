//
//  Reviewer.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/24/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Challenge.h"

@interface Reviewer : NSObject
@property (strong) NSNumber * ID;
@property (strong) Challenge * Info;

// Used in Pick a Reviewer from the Library
@property (strong) NSString * Name;
@property (strong) NSNumber * CreatedBy;
@property (assign) float Average;
@property (assign) int Rating;
@property (assign) int TopicID;

// Used in My Reviewers
@property (assign) BOOL isPublished;
@property (assign) BOOL isHidden;
@property (assign) BOOL Deletable;

@end
