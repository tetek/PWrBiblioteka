//
//  NSString+POST.h
//  Scenios
//
//  Created by Blazej Stanek on 08.05.2012.
//  Copyright (c) 2012 Fream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (POST)

- (NSString *)stringByEscapingForPOST;
- (NSString *)stringByEscapingURL;

@end
