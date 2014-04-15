//
//  Library.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 07.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "Library.h"

@implementation Library

+(instancetype)library{
    return [[Library alloc] init];
}

- (Library *) initWithTitle: (NSString *) title coordinate: (CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self)
    {
        self.name = title;
        self.cord = coordinate;
    }
    return self;
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
        self.name = [data objectForKey:@"title"];
        self.shorttitle = [data objectForKey:@"shorttitle"];
        self.phones = [data objectForKey:@"phones"];
        self.emails = [data objectForKey:@"emails"];
        self.adress = [data objectForKey:@"adress"];
        self.openHours = [data objectForKey:@"openHours"];
        self.notes = [data objectForKey:@"notes"];
        self.cord = cords;
        
        [self setupTable];
    }
    return self;
}


- (CLLocationCoordinate2D) coordinate
{
    return self.cord;
}
-(NSString *)title{
    return self.name;
}
- (NSString*)description{
    //return [NSString stringWithFormat:@"Library: %@", self.uniq];
    return [NSString stringWithFormat:@"uniq: %@ \n title: %@ \n shorttitle: %@ \n phone: %@ \n email: %@ \n adress: %@ \n open: %@ \n notes: %@ \n  --------- \n ", self.uniq, self.name, self.shorttitle, self.phones, self.emails, self.adress, self.openHours, self.notes];
}

- (NSDictionary*)asDictionary{
    //Nie może być nic nil bo nam się dictionary nie stworzy :(
    if(!self.name) { self.name = @""; }
    if(!self.shorttitle) { self.shorttitle = @""; }
    if(!self.phones) { self.phones = @[]; }
    if(!self.emails) { self.emails = @[]; }
    if(!self.adress) { self.adress = @""; }
    if(!self.openHours) { self.openHours = @[]; }
    if(!self.notes) { self.notes = @""; }
    
    
    NSNumber * cord1 = [NSNumber numberWithDouble:self.cord.latitude];
    NSNumber * cord2 = [NSNumber numberWithDouble:self.cord.longitude];
    
    NSArray * keys = [NSArray arrayWithObjects:@"uniq", @"title", @"shorttitle", @"phones", @"emails", @"adress", @"openHours", @"notes", @"cord1", @"cord2", nil];
    NSArray * values = [NSArray arrayWithObjects:self.uniq, self.name, self.shorttitle, self.phones, self.emails, self.adress, self.openHours, self.notes, cord1, cord2, nil];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}



- (void)setupTable{
    
    NSMutableArray *sections = [NSMutableArray array];
    
    NSMutableArray *section1 = [NSMutableArray array];
    
    if ([self titleRow]) {
        [section1 addObject:[self titleRow]];
    }
    if ([self mapRow]) {
        [section1 addObject:[self mapRow]];
    }
    
    [sections addObject:@{@"":section1}];
    
    if (self.emails.count > 0) {
        NSMutableArray *section2 = [NSMutableArray array];
        for (int i = 0; i < self.emails.count; i++) {
            if ([self emailRowForRow:i]) {
                [section2 addObject:[self emailRowForRow:i]];                
            }

        }
        [sections addObject:@{@"email": section2}];
    }
    
    if (self.phones.count > 0) {
        NSMutableArray *section3 = [NSMutableArray array];
        for (int i = 0; i < self.phones.count; i++) {
            if ([self phoneRowForRow:i]) {
                [section3 addObject:[self phoneRowForRow:i]];
            }
        }
        [sections addObject:@{@"telefon": section3}];
    }
    
    if (self.openHours.count > 0) {
        NSMutableArray *section4 = [NSMutableArray array];
        for (int i = 0; i < self.openHours.count; i++) {
            [section4 addObject:[self openHourRowForRow:i]];
        }
        [sections addObject:@{@"Godziny Otwarcia": section4}];
    }
    
    
    if (self.notes.length > 0) {
        NSMutableArray *section5 = [NSMutableArray array];
        [section5 addObject:[self noteRow]];
        [sections addObject:@{@"notatka": section5}];
    }
    self.sections = sections;
}

- (NSDictionary *)openHourRowForRow:(NSInteger)row {
    NSDictionary *data;
    NSString *openHourKey = self.openHours[row][@"key"];
    NSString *openHourValue = self.openHours[row][@"value"];
    
    data = @{
             @"cellType": @"info",
             @"key": openHourKey,
             @"value": openHourValue,
             @"height": [self calculateTextHeight:openHourValue forWidth:180.0]
             };
    return data;
}

- (NSDictionary *)noteRow {
    NSDictionary *data;
    if (self.notes.length == 0) {
        return nil;
    }
    data = @{
             @"cellType": @"longinfo",
             @"value": [self.notes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
             @"height": [self calculateTextHeight:self.notes forWidth:280.0]
             };
    return data;
}

- (NSDictionary *)emailRowForRow:(NSInteger)row {
    NSDictionary *data;
    NSString *emailKey = self.emails[row][@"key"];
    NSString *emailValue = self.emails[row][@"value"];
    if (emailValue.length == 0) {
        return nil;
    }
    data = @{
             @"cellType": @"info",
             @"key": emailKey,
             @"value": emailValue,
             @"height": [self calculateTextHeight:emailValue forWidth:180.0]
             };
    return data;
}

- (NSDictionary *)phoneRowForRow:(NSInteger)row {
    NSDictionary *data;
    NSString *phoneKey = self.phones[row][@"key"];
    NSString *phoneValue = self.phones[row][@"value"];
    if (phoneValue.length == 0) {
        return nil;
    }
    data = @{
             @"cellType": @"info",
             @"key": phoneKey,
             @"value": phoneValue,
             @"height": [self calculateTextHeight:phoneValue forWidth:180.0]
             };
    return data;
}

- (NSDictionary *)titleRow{


    if(self.name.length == 0) {
        return nil;
    }
    NSString *title = self.name;
    
    NSDictionary *data = @{
             @"cellType": @"name",
             @"data": title,
             @"height": [self calculateTextHeight:self.name forWidth:280.0 forFont:[GUIUtils fontWithSize:20.0]]
             };
    
    return data;
        
}
    
- (NSDictionary*)mapRow{
    NSDictionary *data;
    data = @{
             @"cellType": @"map",
             @"lat": @(self.coordinate.latitude),
             @"lng": @(self.coordinate.longitude),
             @"height": @(150)
             };

    return data;
}

- (NSNumber *)calculateTextHeight: (NSString *)string forWidth:(float)width{
    
    return[self calculateTextHeight:string forWidth:width forFont:[UIFont systemFontOfSize:17.0]];
}

- (NSNumber *)calculateTextHeight: (NSString *)string forWidth:(float)width forFont:(UIFont *)font{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return @(rect.size.height+20);
    
}

@end
