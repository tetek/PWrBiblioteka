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

@property NSArray *infosToDisplay;
@property Library *library;
@property (weak) IBOutlet UITableView *tableView;

@end

@implementation LibraryInfoViewController

- (id) initWithLibrary:(Library *)library {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.library = library;
        [self.library setupTable];
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
    
    [[UITableViewHeaderFooterView appearance] setTintColor:[GUIUtils blueColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[GUIUtils fontWithSize:13]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[GUIUtils orangeColor]];

}


////////////////////////////////////////////////////////
#pragma mark - TableView delegates
////////////////////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.library.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.library.sections[section];
    return ((NSArray*)dict.allValues[0]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCellIndentifier];
    
    NSDictionary *dict = self.library.sections[indexPath.section];
    NSArray *rows =  ((NSArray*)dict.allValues[0]);
    
    NSDictionary *rowData = rows[indexPath.row];
    
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
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return [self.library heightForHeaderInSection:section];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = ((NSDictionary*)self.library.sections[section]).allKeys[0];
    return key.uppercaseString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.library.sections[indexPath.section];
    NSArray *rows =  ((NSArray*)dict.allValues[0]);
    
    NSDictionary *rowData = rows[indexPath.row];
    NSNumber *height = rowData[@"height"];
    return [height floatValue];
}

@end
