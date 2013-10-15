//
//  LocationCell.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic, unsafe_unretained) IBOutlet UILabel *availability;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *placeName;
@property (nonatomic, unsafe_unretained) IBOutlet UILabel *ending;
@property (nonatomic, strong) NSString *shortName;
@end
