//
//  TDTeacherCell.m
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 12/10/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDTeacherCell.h"

@interface TDTeacherCell()
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;
@end

@implementation TDTeacherCell

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
            [self.Name setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
            [self.Email setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:NO];
        }];
    }
    else {
        [UIView animateWithDuration:0.4f animations:^{
            [self.Name setFont:[UIFont fontWithName:@"OpenSans" size:12]];
            [self.Email setTextColor:[UIColor blackColor]];
            
            [self.SelectedBG setHidden:YES];
        }];
    }
}

@end
