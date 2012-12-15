//
//  Book.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "Book.h"

@implementation Book

+(Book*)book{
    return [[[Book alloc] init] autorelease];
}

- (NSString*)description{
    return [NSString stringWithFormat:@"%@  : %@  : %@",_author, _title, _availablePlaces];
}
- (void)dealloc
{
    self.title = nil;
    self.author = nil;
    self.availablePlaces = nil;
    [super dealloc];
}
@end
