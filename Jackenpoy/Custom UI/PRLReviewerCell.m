//
//  PRLReviewerCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/8/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "PRLReviewerCell.h"

@interface PRLReviewerCell()
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;
@end

@implementation PRLReviewerCell

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
            
            [self.Author setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.Author setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.Title setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Title setTextColor:[UIColor blackColor]];
            
            [self.Author setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Author setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
