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
@property(strong, nonatomic) NSArray *infosToDisplay;
@property (nonatomic, strong) Library * library;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.library.uniq;
    [self.tableView registerNib:[UINib nibWithNibName:InformationCellIndentifier bundle:nil] forCellReuseIdentifier:InformationCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NameCellIndentifier bundle:nil] forCellReuseIdentifier:NameCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:MapCellIndentifier bundle:nil] forCellReuseIdentifier:MapCellIndentifier];
    [self.tableView registerNib:[UINib nibWithNibName:LongInfoCellIndentifier bundle:nil] forCellReuseIdentifier:LongInfoCellIndentifier];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.library numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.library numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIndentifier];
    
    NSDictionary *rowData = [self.library dataForRowAtIndexPath:indexPath];
    NSString *cellType = rowData[@"cellType"];
    if([cellType isEqualToString:@"name"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:NameCellIndentifier];
        NameCell *nameCell = (NameCell *)cell;
        nameCell.nameLabel.text = rowData[@"data"];
    }
    if([cellType isEqualToString:@"map"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:MapCellIndentifier];
        MapCell *cell2 = (MapCell *)cell;
        [cell2.mapView addAnnotation:self.library];
        cell2.mapView.centerCoordinate = self.library.coordinate;
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.library.coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [cell2.mapView regionThatFits:viewRegion];
        [cell2.mapView setRegion:adjustedRegion animated:YES];
        cell2.mapView.showsUserLocation = YES;
        
    }
    if([cellType isEqualToString:@"info"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:InformationCellIndentifier];
        InformationCell *cell2 = (InformationCell *)cell;
        cell2.keyLabel.text = rowData[@"key"];
        cell2.valueLabel.text = rowData[@"value"];
    }
    if([cellType isEqualToString:@"longinfo"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:LongInfoCellIndentifier];
        LongInfoCell *cell2 = (LongInfoCell *)cell;
        cell2.valueLabel.text = rowData[@"value"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.library heightForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.library titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *rowData = [self.library dataForRowAtIndexPath:indexPath];
    NSNumber *height = rowData[@"height"];
    return [height floatValue];
}

- (void)viewDidUnload {
    self.library = nil;
    self.tableView = nil;
    [super viewDidUnload];
}
@end
