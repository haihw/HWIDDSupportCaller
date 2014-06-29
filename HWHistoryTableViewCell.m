//
//  HWHistoryTableViewCell.m
//  IDDCaller
//
//  Created by Hai Hw on 30/6/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWHistoryTableViewCell.h"

@implementation HWHistoryTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
