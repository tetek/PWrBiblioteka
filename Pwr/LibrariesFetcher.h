//
//  LibrariesFetcher.h
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Library.h"

@interface LibrariesFetcher : NSObject

+ (Library*)fetchLibraryForName:(NSString*)name;
@end
