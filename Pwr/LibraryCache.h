//
//  LibraryCache.h
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 26.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Library.h"
@interface LibraryCache : NSObject


- (void) saveLibraries:(NSDictionary *)libraries;
- (NSDictionary *) getLibraries;

@end
