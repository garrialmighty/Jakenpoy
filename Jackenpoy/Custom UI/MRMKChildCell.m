//
//  MRMKChildCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/17/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "MRMKChildCell.h"

@interface MRMKChildCell()
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;
@end

@implementation MRMKChildCell

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
            [self.Name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
            [self.Name setTextColor:[UIColor blackColor]];
            [self.Status setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14]];
            [self.Status setTextColor:[UIColor blackColor]];
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.Name setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
            [self.Name setTextColor:[UIColor blackColor]];
            [self.Status setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:12]];
            [self.Status setTextColor:[UIColor blackColor]];
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
