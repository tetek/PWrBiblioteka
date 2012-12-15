//
//  NSString+POST.m
//  Scenios
//
//  Created by Blazej Stanek on 08.05.2012.
//  Copyright (c) 2012 Fream. All rights reserved.
//

#import "NSString+POST.h"

char toHex(char hexPart)
{
	if (hexPart < 10)
		return hexPart + 48;
	else
		return hexPart + 55;
}

NSString* encodeChar(char ch)
{
	if (ch==32)
		return @"+";
	if ((ch >= 48 && ch <= 57) || (ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || ch=='.' || ch=='-' || ch=='_')
	{
		char chStr[2];
		chStr[0] = ch;
		chStr[1] = 0;
		return [NSString stringWithCString:chStr encoding:NSASCIIStringEncoding];
	}
	else
	{
		char chStr[4];
		chStr[0] = '%';
		chStr[1] = toHex((ch>>4)&15);
		chStr[2] = toHex(ch&15);
		chStr[3] = 0;
		NSString* ret = [NSString stringWithCString:chStr encoding:NSASCIIStringEncoding];
		return ret;
	}
}

NSString* encodeUrlChar(char ch)
{
//	if (ch==32)
//		return @"+";
	if ((ch >= 48 && ch <= 57) || (ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122) || ch=='.' || ch=='-' || ch=='_' || ch==':' || ch=='/' || ch=='+' || ch=='&' || ch=='?' || ch=='=' || ch=='%')
	{
		char chStr[2];
		chStr[0] = ch;
		chStr[1] = 0;
		return [NSString stringWithCString:chStr encoding:NSASCIIStringEncoding];
	}
	else
	{
		char chStr[4];
		chStr[0] = '%';
		chStr[1] = toHex((ch>>4)&15);
		chStr[2] = toHex(ch&15);
		chStr[3] = 0;
		NSString* ret = [NSString stringWithCString:chStr encoding:NSASCIIStringEncoding];
		return ret;
	}
}

@implementation NSString (POST)

- (NSString *)stringByEscapingForPOST
{
	const char* raw = [self UTF8String];
	NSMutableString* ret = [NSMutableString string];
	for (int i = 0; i < [self length]; i++)
		[ret appendString:encodeChar(raw[i])];
	return ret;
}

- (NSString *)stringByEscapingURL
{
	const char* raw = [self UTF8String];
	NSMutableString* ret = [NSMutableString string];
	for (int i = 0; i < [self length]; i++)
		[ret appendString:encodeUrlChar(raw[i])];
	return ret;
}
@end
