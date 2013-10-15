//
//  NSString+URLEncoding.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "NSString+URLEncoding.h"
@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end
