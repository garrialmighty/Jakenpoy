//
//  Challenge.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/24/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "Challenge.h"

@interface NSArray (JKPArray)
- (NSDictionary *)toDictionary;
@end

@implementation NSArray (JKPArray)

- (NSDictionary *)toDictionary
{
    NSMutableDictionary * returnDictionary = [[NSMutableDictionary alloc] init];
    
    for (uint i=1; i+2<self.count; i+=4) {
        //NSLog(@"%@ %@",self[i+2],self[i]);
        //NSLog(@"%@",self[i]);
        //NSLog(@" ");
        [returnDictionary setValue:self[i+2] forKey:self[i]];
    }
    
    return returnDictionary;
}

@end

@implementation Challenge

@synthesize Title, Instruction, Expiry, Code, ShareToPublic, ShareToSchool, ShowRightAnswers, Classification, AssignedKids;

+ (Challenge *)challengeWithInfo:(NSString *)info
{
    Challenge * returnChallenge = [[Challenge alloc] init];
    NSDictionary * tokenDict = [[info componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]] toDictionary];
    
    [returnChallenge setTitle:tokenDict[@"title"]];
    [returnChallenge setExpiry:tokenDict[@"expiry"]];
    
    //NSLog(@"stp:%@",tokenDict[@"share_to_public"]);
    
    return returnChallenge;
}

@end
