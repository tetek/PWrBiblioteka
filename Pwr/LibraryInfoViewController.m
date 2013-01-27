//
//  LibraryInfo.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LibraryInfoViewController.h"
#import "GUIUtils.h"

#define METERS_PER_MILE 1609.344

@interface LibraryInfoViewController ()
@property (retain, nonatomic) IBOutlet UIView *masterView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) IBOutlet UILabel *phoneLabel;
@property (nonatomic, assign) IBOutlet UILabel *emailLabel;
@property (nonatomic, assign) IBOutlet UILabel *adressLabel;
@property (nonatomic, assign) IBOutlet UILabel *openHoursLabel;
@property (nonatomic, assign) IBOutlet UILabel *notesLabel;
@property (nonatomic, assign) IBOutlet UIView *bgAdres;
@property (nonatomic, assign) IBOutlet UIView *bgNotes;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, retain) Library * library;
@end 
/*
 "uniq: %@ \n title: %@ \n shorttitle: %@ \n phone: %@ \n email: %@ \n adress: %@ \n open: %@ \n notes: %@ \n  --------- \n ", self.uniq, self.title, self.shorttitle, self.phone, self.email, self.adress, self.openHours, self.notes];
 */
@implementation LibraryInfoViewController

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
    
    [self.view sizeToFit];
    [self.masterView sizeToFit];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"lib.jpg"]];
    self.view.backgroundColor = background;
    [background release];
    
    self.scrollView.contentSize = [self.masterView sizeThatFits:CGSizeZero];
    [self.scrollView sizeToFit];
    
    self.title = self.library.uniq;
    self.bgAdres.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    self.bgNotes.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    self.titleLabel.text = self.library.title;
    self.phoneLabel.text = self.library.phone;
    self.emailLabel.text = self.library.email;
    self.adressLabel.text = self.library.adress;
    //self.openHoursLabel.text = self.library.openHours;
    self.notesLabel.text = self.library.notes;
    
    [self.mapView addAnnotation:self.library];
    self.mapView.centerCoordinate = self.library.coordinate;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.library.coordinate, 0.25*METERS_PER_MILE, 0.25*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    self.mapView.showsUserLocation = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}
- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [self setPhoneLabel:nil];
    [self setEmailLabel:nil];
    [self setAdressLabel:nil];
    [self setOpenHoursLabel:nil];
    [self setNotesLabel:nil];
    [self setBgAdres:nil];
    [self setBgNotes:nil];
    self.library = nil;
    [self setScrollView:nil];
    [self setMasterView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [_mapView release];
    [super dealloc];
}
@end
