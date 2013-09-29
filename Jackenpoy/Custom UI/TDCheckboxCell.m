//
//  TDSSectionCell.m
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 9/16/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import "TDCheckboxCell.h"

@implementation TDCheckboxCell

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
}

#pragma mark - IBAction
- (IBAction)toggleCheckbox
{
    if (self.Checkbox.tag == 0) {
        [self.Checkbox setSelected:YES];
        [self.Checkbox setTag:1];
    }
    else {
        [self.Checkbox setSelected:NO];
        [self.Checkbox setTag:0];
    }
}

@end
