//
//  LibraryInfo.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LibraryInfoViewController.h"
#import "GUIUtils.h"
#import "InformationCell.h"
#import "NameCell.h"
#import "MapCell.h"
#import "LongInfoCell.h"

#define METERS_PER_MILE 1609.344
#define InformationCellIndentifier @"InformationCell"
#define NameCellIndentifier @"NameCell"
#define LongInfoCellIndentifier @"LongInfoCell"
#define MapCellIndentifier @"MapCell"

@interface LibraryInfoViewController ()
@property(retain, nonatomic) NSArray *infosToDisplay;
@property (nonatomic, retain) Library * library;
@end 
/*
 "uniq: %@ \n title: %@ \n shorttitle: %@ \n phone: %@ \n email: %@ \n adress: %@ \n open: %@ \n notes: %@ \n  --------- \n ", self.uniq, self.title, self.shorttitle, self.phone, self.email, self.adress, self.openHours, self.notes];
 */
@implementation LibraryInfoViewController
@synthesize  infosToDisplay = _infosToDisplay;
- (id) initWithLibrary:(Library *)library {
    self = [super initWithNibName:@"LibraryInfoViewController" bundle:nil];
    if (self) {
        self.library = library;
    }
    return self;
}

- (void)generateDictionaryWithInfosToDisplay
{
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    if(self.library.title) {
        NSNumber *size = [self calculateTextHeight:self.library.title forWidth:280.0 forFont:[UIFont boldSystemFontOfSize:20.0]];
        [infos addObject:@[@"Nazwa:", self.library.title, @"name", size]];
    }
    if(self.library.coordinate.latitude || self.library.coordinate.longitude) {
        [infos addObject:@[@(self.library.coordinate.latitude), @(self.library.coordinate.longitude), @"map", @(150)]];
    }
    NSLog(@"Email: %@", self.library.email);
    if(self.library.email!=nil && ![self.library.email isEqualToString:@""]) {
        NSNumber *size = [self calculateTextHeight:self.library.email forWidth:180.0];
        [infos addObject:@[@"Email:", self.library.email, @"info", size]];
    }
    if(self.library.phone && ![self.library.phone isEqualToString:@""]) {
        NSNumber *size = [self calculateTextHeight:self.library.phone forWidth:180.0];
        [infos addObject:@[@"Telefon:", self.library.phone, @"info", size]];
    }
    if(self.library.openHours != nil && self.library.openHours.count>0) {
        [infos addObject:@[@"Godziny otwarcia:", @"", @"info-no-line"]];
        if([self.library.openHours objectForKey:@"poniedziałek"]) {
            [infos addObject:@[@"     poniedziałek", [self.library.openHours objectForKey:@"poniedziałek"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"wtorek"]) {
            [infos addObject:@[@"     wtorek", [self.library.openHours objectForKey:@"wtorek"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"środa"]) {
            [infos addObject:@[@"     środa", [self.library.openHours objectForKey:@"środa"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"czwartek"]) {
            [infos addObject:@[@"     czwartek", [self.library.openHours objectForKey:@"czwartek"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"piątek"]) {
            [infos addObject:@[@"     piątek", [self.library.openHours objectForKey:@"piątek"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"sobota"]) {
            [infos addObject:@[@"     sobota", [self.library.openHours objectForKey:@"sobota"], @"info-no-line", @(25)]];
        }
        if([self.library.openHours objectForKey:@"niedziela"]) {
            [infos addObject:@[@"     niedziela", [self.library.openHours objectForKey:@"niedziela"], @"info-no-line", @(25)]];
        }
        NSMutableArray *lastObj = [NSMutableArray arrayWithArray:[infos lastObject]];
        lastObj[2] = @"line";
        [infos removeLastObject];
        [infos addObject:lastObj];
    }
    if(self.library.notes && ![self.library.notes isEqualToString:@""]) {
        NSNumber *size = [self calculateTextHeight:self.library.notes forWidth:280.0];
        
        [infos addObject:@[@"Notatki:", self.library.notes, @"longinfo", @([size floatValue]+30.0)]];
    }
    self.infosToDisplay = infos;
    [self.tableView reloadData];
    [infos release];
    
}
- (NSNumber *) calculateTextHeight: (NSString *)string forWidth:(float)width
{
    
    return[self calculateTextHeight:string forWidth:width forFont:[UIFont systemFontOfSize:17.0]];
}
- (NSNumber *) calculateTextHeight: (NSString *)string forWidth:(float)width forFont:(UIFont *)font
{
    CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    return @(size.height+20);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.library.uniq;
    [self generateDictionaryWithInfosToDisplay];
    [self.tableView registerNib:[UINib nibWithNibName:InformationCellIndentifier bundle:nil] forCellReuseIdentifier:InformationCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NameCellIndentifier bundle:nil] forCellReuseIdentifier:NameCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:MapCellIndentifier bundle:nil] forCellReuseIdentifier:MapCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:LongInfoCellIndentifier bundle:nil] forCellReuseIdentifier:LongInfoCellIndentifier];

    
//    //Wyświetl godziny otwarcia
//    self.poniedzialekInfoLabel.text = [self.library.openHours objectForKey:@"poniedziałek"];
//    self.wtorekInfoLabel.text = [self.library.openHours objectForKey:@"wtorek"];
//    self.srodaInfoLabel.text = [self.library.openHours objectForKey:@"środa"];
//    self.czwartekInfoLabel.text = [self.library.openHours objectForKey:@"czwartek"];
//    self.piatekInfoLabel.text = [self.library.openHours objectForKey:@"piątek"];
//    self.sobotaInfoLabel.text = [self.library.openHours objectForKey:@"sobota"];
//    self.niedzielaInfoLabel.text = [self.library.openHours objectForKey:@"niedziela"];
//    
//    //Pokaż odpowiednie dane
//    self.title = self.library.uniq;
//    self.titleLabel.text = self.library.title;
//    self.phoneLabel.text = self.library.phone;
//    if(!self.emailLabel.text || ![self.emailLabel.text isEqualToString:@" "])
//    {
//        self.emailLabel.text = @"brak informacji";
//    }
//    self.adressLabel.text = self.library.adress;
//    self.notesLabel.text = self.library.notes;
//    
//    if(!self.library.notes || [self.library.notes isEqualToString:@" "])
//    {
//        self.notesLabel.text = @"brak informacji";
//        self.notesLabel.textAlignment = NSTextAlignmentCenter;
//    }
    
//    
//    
//    
//    //Wycentruj mape na bibliotece
//    [self.mapView addAnnotation:self.library];
//    self.mapView.centerCoordinate = self.library.coordinate;
//    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.library.coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
//    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
//    [self.mapView setRegion:adjustedRegion animated:YES];
//    self.mapView.showsUserLocation = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.infosToDisplay count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if([self.infosToDisplay[indexPath.row][2] isEqualToString:@"name"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NameCellIndentifier];
        NameCell *cell2 = (NameCell *)cell;
        cell2.nameLabel.text = self.infosToDisplay[indexPath.row][1];
    } else if([self.infosToDisplay[indexPath.row][2] isEqualToString:@"longinfo"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:LongInfoCellIndentifier];
        LongInfoCell *cell2 = (LongInfoCell *)cell;
        cell2.keyLabel.text = self.infosToDisplay[indexPath.row][0];
        cell2.valueLabel.text = self.infosToDisplay[indexPath.row][1];
    } else if([self.infosToDisplay[indexPath.row][2] isEqualToString:@"map"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:MapCellIndentifier];
        MapCell *cell2 = (MapCell *)cell;
        [cell2.mapView addAnnotation:self.library];
        cell2.mapView.centerCoordinate = self.library.coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.library.coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [cell2.mapView regionThatFits:viewRegion];
        [cell2.mapView setRegion:adjustedRegion animated:YES];
        cell2.mapView.showsUserLocation = YES;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:InformationCellIndentifier];
        InformationCell *cell2 = (InformationCell *)cell;
        
        cell2.separator.hidden = NO;
        if([self.infosToDisplay[indexPath.row][2] isEqualToString:@"info-no-line"]) {
            cell2.separator.hidden = YES;
        }
        cell2.keyLabel.text = self.infosToDisplay[indexPath.row][0];
        cell2.valueLabel.text = self.infosToDisplay[indexPath.row][1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = 0;
    if([self.infosToDisplay[indexPath.row] count] >=4) {
        size = [self.infosToDisplay[indexPath.row][3] intValue];
    } else {
        size = 40;
    }
    
    return size;
}
- (void)viewDidUnload {
    self.library = nil;
    self.tableView = nil;
    self.infosToDisplay = nil;
    [super viewDidUnload];
}
@end
