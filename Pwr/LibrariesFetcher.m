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
    library.title = title;
    
    HTMLNode *tableNode = [bodyNode findChildTag:@"table"];
    if (!tableNode) {
        //Brak wyników
        return nil;
    }
    
    
    NSLog(@"%@", url);
    NSMutableDictionary * godzinyOtwarcia = [NSMutableDictionary dictionary];
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
                
                // The NSRegularExpression class is currently only available in the Foundation framework of iOS 4
                NSError *error = NULL;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([\\n\\t\\r]+)|([\\ ]{2,2})" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                NSString *adres = [regex stringByReplacingMatchesInString:value options:0 range:NSMakeRange(0, [value length]) withTemplate:@""];
                value = adres;
                
                regex = [NSRegularExpression regularExpressionWithPattern:@"Bud(.*?)$" options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators | NSRegularExpressionAnchorsMatchLines error:&error];
                adres = [regex stringByReplacingMatchesInString:adres options:0 range:NSMakeRange(0, [adres length]) withTemplate:@""];
                
                adres = [@"Wrocław, " stringByAppendingString:adres];
                
                NSString *strGeoCode = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                                        [adres urlEncodeUsingEncoding:NSUTF8StringEncoding]];
                
                
                NSString *locationStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:strGeoCode] encoding:NSUTF8StringEncoding error:&downloadError];
                
                NSArray * locationInfo = [locationStr componentsSeparatedByString:@","];
                if([locationInfo count]>=2)
                {
                    NSString * lat = locationInfo[2];
                    NSString * lng = locationInfo[3];
                    
                    library.cord = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                    
                    
                }
                library.adress = value;
            } else if([key isEqualToString:@"telefon:"]) {
                library.phone = value;
            } else if([key isEqualToString:@"e-mail:"]) {
                library.email = value;
            } else if([key isEqualToString:@"uwagi:"]) {
                library.notes = value;
            } else {
                NSSet * allowedKeys = [NSSet setWithObjects:@"poniedziałek", @"wtorek", @"środa", @"czwartek", @"piątek", @"sobota", @"niedziela", nil];
                if([allowedKeys containsObject:value])
                {
                    [godzinyOtwarcia setObject:godzina forKey:value];
                }
            }
        }
    }
    library.openHours = godzinyOtwarcia;
    NSLog(@"godziny %@", godzinyOtwarcia);
    
    return library;
}
@end
