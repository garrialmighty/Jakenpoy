//
//  TDSectionCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/20/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDSectionCell.h"

@interface TDSectionCell()
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;
@end

@implementation TDSectionCell

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
    
    if (selected) {
        [UIView animateWithDuration:0.4f animations:^{
            [self.ID setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.ID setTextColor:[UIColor blackColor]];
            
            [self.Name setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.Name setTextColor:[UIColor blackColor]];
            
            [self.GradeLevel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.GradeLevel setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.ID setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.ID setTextColor:[UIColor blackColor]];
            
            [self.Name setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Name setTextColor:[UIColor blackColor]];
            
            [self.GradeLevel setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.GradeLevel setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
