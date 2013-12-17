//
//  ReviewerCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "ReviewerCell.h"

@implementation ReviewerCell

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
            [self.Title setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.Title setTextColor:[UIColor blackColor]];
            
            [self.ExpirationDate setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.ExpirationDate setTextColor:[UIColor blackColor]];
            
            [self.Status setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.Status setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.Title setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Title setTextColor:[UIColor blackColor]];
            
            [self.ExpirationDate setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.ExpirationDate setTextColor:[UIColor blackColor]];
            
            [self.Status setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Status setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
