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
        self.title = [title copy];
        // @bartek: ma być poprostu  = title, jesteś odpowiedzialny za zwolnienie wszyskiego co retainujesz. (copy i  mutableCopy retainują o jeden)
        // Dlaczego tutaj copy nie jest potrzebne ? Ponieważ mamy property do title. Taki: @property (nonatomic, retain) NSString * title;
        // Property to nic innego, jak automatycznie generowany setter i getter dla zmiennej.
        // @property (nonatomic, retain) - słówko retain znaczy, ze setter retainuje nam zmienną.
        // kiedyś się pisało, @synthesize title = _title. od jakiegoś czasu XCode robi to za nas.
        // Mamy więc setter który możemy użyć na dwa sposoby. self.title = ... lub [self setTitle:...]
        // i getter _title. Dlatego za każdym razem jak tylko korzystasz z zmiennej i nie nadpisujesz jej, możesz pisać _title
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
    //@bartek, np tutaj mógłbyś mieć _uniq, _title, .... zajełoby dużo mniej miejsca
}

// @bartek nadpisałem setter do title, on w rzeczywistości wygląda +- tak samo (apple sie chyba nie zdradza;p). jak widzisz on sam sobie retainuje
// możesz go usunąć ;]
-(void)setTitle:(NSString *)title{
    [_title release];
    _title = [title retain];
}
- (void)dealloc
{
    //@bartek No i teraz widzisz, czemu używam self.zmienna = nil a nie [_zmienna relase], bo to jest praktycznie to samo oprócz tego, że dodatkowo przypisuje nila do zmiennej, także sam profit ;]

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
