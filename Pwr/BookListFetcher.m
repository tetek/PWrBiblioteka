//
//  BookListFetcher.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "BookListFetcher.h"
#import "HTMLParser.h"
#import "Book.h"


@implementation BookListFetcher

+ (NSArray*)fetchBooksForQuery:(NSString*)query{
    
    //replace spaces with +
    NSMutableString *safeQuery = [query mutableCopy];
    [safeQuery replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, safeQuery.length)];
    query = safeQuery;
    
    NSString *baseURL = @"http://aleph.bg.pwr.wroc.pl/F?func=find-b&REQUEST=";
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL,query];    
    NSError *downloadError = nil;
    NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&downloadError];
   
    if (downloadError) {
        @throw [NSException exceptionWithName:@"Connection error" reason:@"Couldn't load results" userInfo:nil];
    }
    
    NSError *error = nil;
    
    HTMLParser *parser = [[[HTMLParser alloc] initWithString:html error:&error] autorelease];
    
    if (error) {
        @throw [NSException exceptionWithName:@"Parsing error" reason:@"Couldn't parse results" userInfo:nil];
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *tableNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"short_table" allowPartial:YES];
    NSLog(@"url: %@", url);
    if (!tableNode) {
        //Brak wyników
        return nil;
    }
    NSMutableArray *books = [NSMutableArray array];
    
    NSArray *trs = [tableNode findChildTags:@"tr"];
    for (HTMLNode *bookInfo in trs) {
        Book *book = [Book book];
        NSString *author = ((HTMLNode*)bookInfo.children[4]).contents;
        NSString *title = ((HTMLNode*)bookInfo.children[6]).contents;
        if (!title) {
            continue;
        }
        NSMutableString *titleMut = [title mutableCopy];
        
        [titleMut replaceOccurrencesOfString:@"/" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, titleMut.length)];
        title = titleMut;
        
        book.author = author ? author : @"Gal, Anonim.";
        book.title = title;
//        
//        NSLog(@"Autor %@",author);
//        NSLog(@"Tytul %@",title);
        NSMutableDictionary *places = [NSMutableDictionary dictionary];
        
        HTMLNode *available = (HTMLNode*)bookInfo.children[10];
        for (HTMLNode *place in [available findChildTags:@"a"]) {
            NSString *placeString = place.contents;
            
            NSString * placeHref = [place getAttributeNamed:@"href"];
            NSArray* urlForPlaceSep = [placeHref componentsSeparatedByString:@"sub_library="];
            NSString * libraryIndentifier = urlForPlaceSep[1];
            
            NSArray *leftRight = [placeString componentsSeparatedByString:@"("];
            if (leftRight.count == 2) {                
                NSString *placeName = leftRight[0];
                
                
                NSArray *placeNames = [NSArray arrayWithObjects:libraryIndentifier, placeName, nil];
                
                NSArray *right = [((NSString*)leftRight[1]) componentsSeparatedByString:@"/ "];
                if (right.count == 2) {                    
                    int all = [right[0] intValue];
                    int rented = [right[1] intValue];
//                    NSLog(@"%@ %d",placeName, all-rented);
                    
                    [places setObject:[NSNumber numberWithInt:(all-rented)] forKey:placeNames];
                }
            }
            
        }
        book.availablePlaces = places;
        [books addObject:book];
    }
    return books;
}

@end
