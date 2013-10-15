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
    return [[Library alloc] init];
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
    //return [NSString stringWithFormat:@"Library: %@", self.uniq];
    return [NSString stringWithFormat:@"uniq: %@ \n title: %@ \n shorttitle: %@ \n phone: %@ \n email: %@ \n adress: %@ \n open: %@ \n notes: %@ \n  --------- \n ", self.uniq, self.title, self.shorttitle, self.phone, self.email, self.adress, self.openHours, self.notes];
}
- (NSDictionary*)asDictionary{
    //Nie może być nic nil bo nam się dictionary nie stworzy :(
    if(!self.title) { self.title = @""; }
    if(!self.shorttitle) { self.shorttitle = @""; }
    if(!self.phone) { self.phone = @""; }
    if(!self.email) { self.email = @""; }
    if(!self.adress) { self.adress = @""; }
    if(!self.openHours) { self.openHours = [NSDictionary dictionary]; }
    if(!self.notes) { self.notes = @""; }
    
    
    NSNumber * cord1 = [NSNumber numberWithDouble:self.cord.latitude];
    NSNumber * cord2 = [NSNumber numberWithDouble:self.cord.longitude];
    
    NSArray * keys = [NSArray arrayWithObjects:@"uniq", @"title", @"shorttitle", @"phone", @"email", @"adress", @"openHours", @"notes", @"cord1", @"cord2", nil];
    NSArray * values = [NSArray arrayWithObjects:self.uniq, self.title, self.shorttitle, self.phone, self.email, self.adress, self.openHours, self.notes, cord1, cord2, nil];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}
- (Library *) initWithDictionaryData: (NSDictionary *) data
{
    self = [super init];
    if(self)
    {
        double cord1 = [((NSNumber *)[data objectForKey:@"cord1"]) floatValue];
        double cord2 = [((NSNumber *)[data objectForKey:@"cord2"]) floatValue];
        
        CLLocationCoordinate2D cords = CLLocationCoordinate2DMake(cord1, cord2);
        self.uniq = [data objectForKey:@"uniq"];
        self.title = [data objectForKey:@"title"];
        self.shorttitle = [data objectForKey:@"shorttitle"];
        self.phone = [data objectForKey:@"phone"];
        self.email = [data objectForKey:@"email"];
        self.adress = [data objectForKey:@"adress"];
        self.openHours = [data objectForKey:@"openHours"];
        self.notes = [data objectForKey:@"notes"];
        self.cord = cords;
    }
    return self;
}
@end
