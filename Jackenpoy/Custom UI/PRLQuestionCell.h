//
//  PRLQuestionCell.h
//  Jakenpoy PTA
//
//  Created by Garri Adrian Nablo on 11/28/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRLQuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Question;
@property (weak, nonatomic) IBOutlet UILabel *Right;
@property (weak, nonatomic) IBOutlet UILabel *Wrong;
@end
