//
//  ReviewerCell.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/19/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewerCell : UITableViewCell {
    NSDate * _ExpDate;
    BOOL _isGood;
}

@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *ExpirationDate;
@property (weak, nonatomic) IBOutlet UILabel *Status;
@property (weak, nonatomic) IBOutlet UIView *SelectedBG;

@property (strong) NSDate * ExpDate;
@property (assign) BOOL isGood;
@end
