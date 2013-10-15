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

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSDictionary *availablePlaces;
@property(nonatomic, strong) NSMutableDictionary *availablePlacesFetched;
@end
