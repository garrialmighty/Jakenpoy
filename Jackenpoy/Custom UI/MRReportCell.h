//
//  MRReportCell.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/13/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Number;
@property (weak, nonatomic) IBOutlet UILabel *Question;
@property (weak, nonatomic) IBOutlet UILabel *Correct;
@property (weak, nonatomic) IBOutlet UILabel *Percentage;
@property (weak, nonatomic) IBOutlet UILabel *Wrong;
@end
