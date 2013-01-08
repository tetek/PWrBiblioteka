//
//  Library.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 07.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "Library.h"

@implementation Library

+(Library*)library{
    return [[[Library alloc] init] autorelease];
}
- (Library *) initWithTitle: (NSString *) title coordinate: (CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.cord = coordinate;
    }
    return self;
}
- (CLLocationCoordinate2D) coordinate
{
    return self.cord;
}
- (NSString*)description{
    return [NSString stringWithFormat:@"uniq: %@ \n title: %@ \n shorttitle: %@ \n phone: %@ \n email: %@ \n adress: %@ \n open: %@ \n notes: %@ \n  --------- \n ", self.uniq, self.title, self.shorttitle, self.phone, self.email, self.adress, self.openHours, self.notes];
}
- (void)dealloc
{
    self.title = nil;
    self.uniq = nil;
    self.adress = nil;
    self.phone = nil;
    self.email = nil;
    self.notes = nil;
    self.openHours = nil;
    [super dealloc];
}
@end
