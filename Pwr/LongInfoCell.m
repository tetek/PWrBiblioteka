//
//  LongInfoCell.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 31.03.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LongInfoCell.h"

@implementation LongInfoCell

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
}

- (void)dealloc {
    [_keyLabel release];
    [_valueLabel release];
    [super dealloc];
}
@end
