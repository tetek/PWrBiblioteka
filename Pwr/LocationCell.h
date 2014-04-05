//
//  LocationCell.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

@class Library;

@interface LocationCell : UITableViewCell

@property (nonatomic, weak) Library *library;
@property (nonatomic, strong) NSString *shortName;
@end
