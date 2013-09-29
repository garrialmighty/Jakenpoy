//
//  UserType.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/26/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

//1 student
//2 admin
//3 sponsors
//4 teacher
//5 guardian/parent
@interface UserType : NSObject
@property(assign) BOOL Student;
@property(assign) BOOL Admin;
@property(assign) BOOL Sponsor;
@property(assign) BOOL Teacher;
@property(assign) BOOL Guardian;
+ (UserType *)userTypeWithRole:(NSString *)role;
@end