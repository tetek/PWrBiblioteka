//
//  LocationCell.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "LocationCell.h"
#import "Library.h"

@interface LocationCell ()

@property (weak) IBOutlet UILabel *availability;
@property (weak) IBOutlet UILabel *placeName;
@property (weak) IBOutlet UILabel *ending;

@end
@implementation LocationCell

-(void)awakeFromNib{
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
}

-(void)setLibrary:(Library *)library{
    _library = library;

    self.placeName.text = [NSString stringWithFormat:@"w %@",_library.shorttitle];
    
    NSNumber *number = _library.available;
    
    self.availability.text = [NSString stringWithFormat:@"%d",number.intValue];
    self.ending.text = number.intValue > 1 ? @"sztuki" : number.intValue == 1 ? @"sztuka" : @"sztuk";
}
@end
