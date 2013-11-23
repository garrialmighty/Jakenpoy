//
//  QuestionDetails.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/21/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Challenge;

@interface QuestionDetails : NSObject
@property (strong) NSNumber * ID;
@property (strong) NSNumber * TopicID;
@property (strong) NSNumber * CreatedBy;

@property (assign) BOOL isPublished;
@property (assign) BOOL canBeDeleted;
@property (assign) BOOL ShowAnswer;
@property (assign) BOOL ShareToSchool;

@property (strong) NSString * Instruction;
@property (strong) NSString * Type;
@property (strong) NSString * Topic;
@property (strong) NSString * Title;
@property (strong) NSString * Expiry;
@property (strong) NSString * QuestionType;
@property (strong) NSString * Subject;

@property (strong) Challenge * ChallengeInfo;
@property (strong) NSArray * Questions;
@end