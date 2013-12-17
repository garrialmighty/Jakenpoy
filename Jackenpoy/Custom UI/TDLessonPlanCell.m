//
//  TDCourseCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDLessonPlanCell.h"

@interface TDLessonPlanCell()
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;
@property (weak, nonatomic) IBOutlet UIButton *TopicsButton;

@end

@implementation TDLessonPlanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        [UIView animateWithDuration:0.4f animations:^{
            [self.CourseTitle setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.CourseTitle setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.CourseTitle setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.CourseTitle setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
