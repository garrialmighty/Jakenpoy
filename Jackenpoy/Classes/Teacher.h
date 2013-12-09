//
//  Teacher.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/10/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Teacher : NSObject
@property (assign) BOOL isAdmin;
@property (strong) NSNumber * ID;
@property (strong) NSNumber * SchoolID;
@property (strong) NSString * Email;
@property (strong) NSString * Name;
@end
