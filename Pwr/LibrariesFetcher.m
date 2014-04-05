//
//  LibrariesFetcher.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LibrariesFetcher.h"
#import "HTMLParser.h"
#import "NSString+URLEncoding.h"
#import "JSONKit.h"

@implementation LibrariesFetcher

+ (Library*)fetchLibraryForName:(NSString*)name{
    
    //replace spaces with +
    NSMutableString *safeQuery = [name mutableCopy];
    [safeQuery replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, safeQuery.length)];
    name = safeQuery;
    NSString *baseURL = @"http://aleph.bg.pwr.wroc.pl/F?func=library&sub_library=";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL,name];
    NSError *downloadError = nil;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&downloadError];
    
    
    NSLog(@"librUrl: %@", url);
    if (downloadError) {
        @throw [NSException exceptionWithName:@"Connection error" reason:@"Couldn't load results" userInfo:nil];
    }
    
    NSError *error = nil;
    
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        @throw [NSException exceptionWithName:@"Parsing error" reason:@"Couldn't parse results" userInfo:nil];
        return nil;
    }
    
    Library *library = [Library library];
    
    HTMLNode *bodyNode = [parser body];
    
    HTMLNode *nameNode = [bodyNode findChildTag:@"font"];
    NSString * title = [((HTMLNode *)[nameNode findChildTag:@"b"]) contents];
    library.name = title;
    
    HTMLNode *tableNode = [bodyNode findChildTag:@"table"];
    if (!tableNode) {
        //Brak wyników
        return nil;
    }
    
    
    NSMutableArray * godzinyOtwarcia = [NSMutableArray array];
    NSArray *trs = [tableNode findChildTags:@"tr"];
    for (HTMLNode *info in trs) {
        NSArray * keys = [info findChildrenWithAttribute:@"class" matchingName:@"td1" allowPartial:YES];
        NSArray * values = [info findChildrenWithAttribute:@"class" matchingName:@"td2" allowPartial:YES];
        NSArray * otwarcie = [info findChildrenWithAttribute:@"class" matchingName:@"td3" allowPartial:YES];
        
        
        for(int i=0; i<[values count]; i++)
        {
            NSString * key = nil;
            NSString * godzina = nil;
            if(i<[keys count])
            {
                key = [((HTMLNode *)[keys objectAtIndex:i]) allContents];
            }
            if(i<[otwarcie count])
            {
                godzina = [((HTMLNode *)[otwarcie objectAtIndex:i]) allContents];
            }
            NSString * value = [((HTMLNode *)[values objectAtIndex:i]) allContents];
            
            
            if([key isEqualToString:@"adres:"]) {
                NSError *error = NULL;
                
                //Tylko dla adresu potrzebujemy czystego HTMLa a nie sam tekst po to aby spacje można było w odpowiednich miejscach porobić
                NSString * value = [((HTMLNode *)[values objectAtIndex:i]) rawContents];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\<(.+?)\\>" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                value = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@" "];
                
                //A teraz wywalamy podwójne białe znaki itd
                regex = [NSRegularExpression regularExpressionWithPattern:@"([\\n\\t\\r\\ ]+)" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                value = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@" "];
                
                
                //Potrzebujemy adresu, więc wszystko aż do frazy "Bud"
                regex = [NSRegularExpression regularExpressionWithPattern:@"Bud(.*?)$" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                NSString * adres = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@""];
                
                adres = [@"Wrocław, " stringByAppendingString:adres];
                
                NSString *strGeoCode = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",
                                        [adres urlEncodeUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:strGeoCode] encoding:NSUTF8StringEncoding error:&downloadError];
                
                //NSLog(@"google response JSON: %@", locationStr);
                NSDictionary *decoded = [locationStr objectFromJSONString];
                if([[decoded objectForKey:@"results"] count]>0) {
                NSDictionary *results = [[((NSArray *)[decoded objectForKey:@"results"])[0] objectForKey:@"geometry"] objectForKey:@"location"];
                    NSString * lat = [results objectForKey:@"lat"];
                    NSString * lng = [results objectForKey:@"lng"];
                    
                    library.cord = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                }
                library.adress = value;
            } else if([key isEqualToString:@"telefon:"]) {
                library.phones = [self parsePhones:value];
            } else if([key isEqualToString:@"e-mail:"]) {
                NSError *error = NULL;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAllowCommentsAndWhitespace error:&error];
                NSUInteger numberOfMatches = [regex numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])];
                if(numberOfMatches!=0) {
                    library.emails = [self parseEmails:value];
                }
            } else if([key isEqualToString:@"uwagi:"]) {
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([\\n\\t\\r\\ ]+)" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                
                NSString *notes = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@" "];

                library.notes = notes;
            } else {
                NSSet * allowedKeys = [NSSet setWithObjects:@"poniedziałek", @"wtorek", @"środa", @"czwartek", @"piątek", @"sobota", @"niedziela", nil];
                if([allowedKeys containsObject:value] && godzina)
                {
                    [godzinyOtwarcia addObject:@{@"key": value, @"value": godzina}];
                }
            }
        }
    }
    library.openHours = godzinyOtwarcia;
    
    return library;
}


+ (NSArray *)parsePhones:(NSString *)valueToParse {
    // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9\\s]+)(\\((.*)\\)|)" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines error:&error];
    
    
    NSMutableArray *results = [NSMutableArray array];
    [regex enumerateMatchesInString:valueToParse options:NULL range:NSMakeRange(0, 12) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *key = @"";
        NSString *value = @"";
        if(result.numberOfRanges>3) {
            NSRange keyRange = [result rangeAtIndex:3];
            if(keyRange.location != NSNotFound) {
                key = [valueToParse substringWithRange:[result rangeAtIndex:3]];
                value = [valueToParse substringWithRange:[result rangeAtIndex:1]];
                [results addObject:@{@"key": key, @"value": [self cleanPhoneNumber:value]}];
            } else {
                value = [valueToParse substringWithRange:[result rangeAtIndex:1]];
                [results addObject:@{@"key": key, @"value": [self cleanPhoneNumber:value]}];
            }
        }
    }];
    return results;
}
+ (NSString *)cleanPhoneNumber:(NSString *)phone {
    NSString *cleaned = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cleaned = [cleaned stringByReplacingOccurrencesOfString:@" " withString:@""];
    return cleaned;
}

+ (NSArray *)parseEmails:(NSString *)valueToParse {
    // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\\.[a-zA-Z]{2,4})" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines error:&error];
    
    
    NSMutableArray *results = [NSMutableArray array];
    [regex enumerateMatchesInString:valueToParse options:NULL range:NSMakeRange(0, valueToParse.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *key = @"";
        NSString *value = @"";
        if(result.numberOfRanges>1) {
            value = [valueToParse substringWithRange:[result rangeAtIndex:1]];
            [results addObject:@{@"key": key, @"value": [self cleanPhoneNumber:value]}];
        }
    }];
    return results;
}
@end
