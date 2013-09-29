//
//  Student.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/28/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property (strong) NSString * FirstName;
@property (strong) NSString * LastName;
@property (strong) NSNumber * ID;
@property (assign) BOOL isGuardianActive;
@end
