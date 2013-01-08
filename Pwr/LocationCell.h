//
//  LocationCell.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *availability;
@property (nonatomic, assign) IBOutlet UILabel *placeName;
@property (nonatomic, assign) IBOutlet UILabel *ending;
@property (nonatomic, retain) NSString *shortName;
@end
