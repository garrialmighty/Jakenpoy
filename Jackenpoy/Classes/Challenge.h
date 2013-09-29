//
//  Challenge.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/24/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Challenge : NSObject
@property (strong) NSString * Title;
@property (strong) NSString * Instruction;
@property (strong) NSString * Expiry;
@property (strong) NSArray * AssignedKids;
@property (assign) uint Code;
@property (assign) uint Classification;
@property (assign) BOOL ShareToPublic;
@property (assign) BOOL ShareToSchool;
@property (assign) BOOL ShowRightAnswers;

+ (Challenge *)challengeWithInfo:(NSString *)info;

@end
