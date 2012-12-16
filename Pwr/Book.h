//
//  Book.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

+book;

- (int)countAvailability;

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *author;
@property(nonatomic, retain) NSDictionary *availablePlaces;
@end
