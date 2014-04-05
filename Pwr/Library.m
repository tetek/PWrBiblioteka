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

- (NSInteger)numberOfSections {
    return 5;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfItems = 0;
    if(section==0) {
        numberOfItems = 2; //name, map
    } else if (section==1) {
        numberOfItems = self.emails.count;
    } else if(section==2) {
        numberOfItems = self.phones.count;
    } else if(section==3) {
        numberOfItems = self.openHours.count;
    } else if(section==4) {
        numberOfItems = 1;
    }
    return numberOfItems;
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
    }
    return self;
}

- (NSDictionary *)dataForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data;
    if(indexPath.section==0) {
        data = [self dataForGeneralSectionForRow:indexPath.row];
    }
    if(indexPath.section==1) {
        data = [self dataForEmailsSectionForRow:indexPath.row];
    }
    if(indexPath.section==2) {
        data = [self dataForPhonesSectionForRow:indexPath.row];
    }
    if(indexPath.section==3) {
        data = [self dataForOpenHoursSectionForRow:indexPath.row];
    }
    if(indexPath.section==4) {
        data = [self dataForNoteSectionForRow:indexPath.row];
    }
    
    return data;
}

- (NSInteger)heightForHeaderInSection:(NSUInteger)section {
    NSInteger height = 0;
    if([self numberOfItemsInSection:section]>0 && section>0) {
        height = 40;
    }
    return height;
}

- (NSString *)titleForHeaderInSection:(NSUInteger)section {
    NSString *title = @"";
    switch (section) {
        case 0:
            break;
        case 1:
            title = @"Email";
            break;
        case 2:
            title = @"Telefon";
            break;
        case 3:
            title = @"Godziny otwarcia";
            break;
        case 4:
            title = @"Notatka";
            break;
        default:
            break;
    }
    return title;
}


- (NSDictionary *)dataForOpenHoursSectionForRow:(NSInteger)row {
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

- (NSDictionary *)dataForNoteSectionForRow:(NSInteger)row {
    NSDictionary *data;
    
    data = @{
             @"cellType": @"longinfo",
             @"value": self.notes,
             @"height": [self calculateTextHeight:self.notes forWidth:280.0]
             };
    return data;
}



- (NSDictionary *)dataForEmailsSectionForRow:(NSInteger)row {
    NSDictionary *data;
    NSString *emailKey = self.emails[row][@"key"];
    NSString *emailValue = self.emails[row][@"value"];
    
    data = @{
             @"cellType": @"info",
             @"key": emailKey,
             @"value": emailValue,
             @"height": [self calculateTextHeight:emailValue forWidth:180.0]
             };
    return data;
}

- (NSDictionary *)dataForPhonesSectionForRow:(NSInteger)row {
    NSDictionary *data;
    NSString *phoneKey = self.phones[row][@"key"];
    NSString *phoneValue = self.phones[row][@"value"];
    
    data = @{
             @"cellType": @"info",
             @"key": phoneKey,
             @"value": phoneValue,
             @"height": [self calculateTextHeight:phoneValue forWidth:180.0]
             };
    return data;
}

- (NSDictionary *)dataForGeneralSectionForRow:(NSInteger)row {
    NSDictionary *data;
    if(row==0) {
        NSString *title = @"";
        if(self.name) {
            title = self.name;
        }
        data = @{
                 @"cellType": @"name",
                 @"data": title,
                 @"height": [self calculateTextHeight:self.name forWidth:280.0 forFont:[GUIUtils fontWithSize:20.0]]
                 };
    } else if(row==1) {
        data = @{
                 @"cellType": @"map",
                 @"lat": @(self.coordinate.latitude),
                 @"lng": @(self.coordinate.longitude),
                 @"height": @(150)
                 };
    }
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
