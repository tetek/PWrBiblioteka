//
//  LibraryCache.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 26.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LibraryCache.h"

@implementation LibraryCache

- (LibraryCache *)init
{
    self = [super init];
    if(self)
    {
    
    }
    return self;
}


-(void)saveLibraries:(NSDictionary *)libraries
{
    NSMutableDictionary* librariesAsArrays = [NSMutableDictionary dictionary];
    for(NSString * uniq in [libraries allKeys])
    {
        Library * lib = [libraries objectForKey:uniq];
        [librariesAsArrays setObject:[lib asDictionary] forKey:uniq];
    }
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"librariesCache.plist"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:librariesAsArrays
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    } else {
        NSLog(@"Error : %@",error);
    }
}


-(NSDictionary *)getLibraries
{
    
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"librariesCache.plist"];
    NSDictionary * dictLibraries = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSMutableDictionary* libraries = [NSMutableDictionary dictionary];
    for(NSString * uniq in [dictLibraries allKeys])
    {
        Library * library = [[Library alloc] initWithDictionaryData:[dictLibraries objectForKey:uniq]];
        [libraries setObject:library forKey:uniq];
    }
    return libraries;
}
@end
