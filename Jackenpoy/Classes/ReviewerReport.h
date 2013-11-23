//
//  ReviewerReport.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/16/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewerReport : NSObject
@property (strong) NSNumber * TotalStudents;
@property (strong) NSArray * Questions;
@property (strong) NSArray * Wrong;
@property (strong) NSArray * Right;
@property (strong) NSArray * QuestionArray;
@end
