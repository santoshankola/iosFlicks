//
//  MovieCell.h
//  iOSFlicks
//
//  Created by Santosh Ankola on 9/13/16.
//  Copyright © 2016 Santosh Ankola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
