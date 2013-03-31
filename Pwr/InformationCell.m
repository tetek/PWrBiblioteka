//
//  InformationCell.m
//  TemomukoFlow
//
//  Created by Bartosz Hernas on 30.03.2013.
//  Copyright (c) 2013 Bartosz Hernas. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
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
    [_separator release];
    [super dealloc];
}
@end
