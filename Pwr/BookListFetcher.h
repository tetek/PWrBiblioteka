//
//  BookListFetcher.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

@interface BookListFetcher : NSObject

+ (NSArray*)fetchBooksForQuery:(NSString*)query;

@end
