//
//  LocationsViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"
#import "GUIUtils.h"
#import "Library.h"
#import "BookListFetcher.h"
#import "LibraryInfoViewController.h"

#define METERS_PER_MILE 1609.344

@interface LocationsViewController ()
@property (nonatomic, assign) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) NSDictionary *placesFetched;
@property (nonatomic, retain) NSArray *tableData;
@end

@implementation LocationsViewController

- (id) initWithPlaces:(NSDictionary*)arr AndTableData:(NSArray *) data {
    self = [super initWithNibName:@"LocationsViewController" bundle:nil];
    if (self) {
        self.placesFetched = [arr retain];
        self.tableData = [data retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"LocationCell" bundle:nil] forCellReuseIdentifier:@"LocationCell"];
    self.title = @"Znaleziono w";
    
    
    
    self.mapView.delegate = self;
    
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 51.1071497;
    zoomLocation.longitude= 17.0611262;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    // 4
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    [self.mapView removeAnnotations:[self.placesFetched allValues]];
    [self.mapView addAnnotations:[self.placesFetched allValues]];
    self.mapView.showsUserLocation = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    if (!cell) {
        //we are fucked
    }
    NSString * uniq = self.tableData[indexPath.row];
    Library * lib = ((Library *)[self.placesFetched valueForKey:uniq]);
    NSString *placeName = lib.shorttitle;
    cell.placeName.text = [NSString stringWithFormat:@"w %@",placeName];
    cell.placeName.textColor = [UIColor blackColor];
    NSNumber *number = lib.available;
    cell.availability.text = [NSString stringWithFormat:@"%d",number.intValue];
    cell.ending.text = number.intValue > 1 ? @"sztuki" : number.intValue == 1 ? @"sztuka" : @"sztuk";
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * uniq = self.tableData[indexPath.row];
    [self.mapView selectAnnotation:[self.placesFetched valueForKey:uniq] animated:YES];
    
    
}
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString * uniq = self.tableData[indexPath.row];
    [self showLibraryInfoWithName:uniq];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"LibraryAnnotation";
        annotation = (Library *) annotation;
        MKPinAnnotationView *annotationView = [(MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier] retain];
        if (annotationView == nil) {
            annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            UIButton* rightButton = [[UIButton buttonWithType:
                                     UIButtonTypeDetailDisclosure] retain];
            
            annotationView.rightCalloutAccessoryView = rightButton;
            annotationView.annotation = annotation;
        }
        annotationView.annotation = annotation;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    Library * annotation = [aView.annotation retain];
    int index = [self.tableData indexOfObject:annotation.uniq];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Library * annotation = [view.annotation retain];
    [self showLibraryInfoWithName:annotation.uniq];
}

- (void) showLibraryInfoWithName: (NSString *) uniq
{
    Library * lib = [self.placesFetched objectForKey:uniq];
    LibraryInfoViewController *libraryInfo = [[[LibraryInfoViewController alloc] initWithLibrary:lib] autorelease];
    [self.navigationController pushViewController:libraryInfo animated:YES];
}
- (void)dealloc
{
    self.placesFetched = nil;
    [_mapView release];
    [super dealloc];
}
@end
