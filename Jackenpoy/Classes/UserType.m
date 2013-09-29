//
//  UserType.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/26/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "UserType.h"

@implementation UserType

@synthesize Student, Admin, Sponsor, Teacher, Guardian;

+ (UserType *)userTypeWithRole:(NSString *)role
{
    UserType * returnUserType = [[UserType alloc] init];
    NSArray * tokens = [role componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
    
    for (NSString * item in tokens) {
        //NSLog(@"%@",item);
        switch ([item intValue]) {
            case 1:
                [returnUserType setStudent:YES];
                break;
            case 2:
                [returnUserType setAdmin:YES];
                break;
            case 3:
                [returnUserType setSponsor:YES];
                break;
            case 4:
                [returnUserType setTeacher:YES];
                break;
            case 5:
                [returnUserType setGuardian:YES];
                break;
            default:
                break;
        }
    }
    
    return returnUserType;
}

@end
