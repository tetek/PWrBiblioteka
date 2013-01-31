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
@property (nonatomic, assign) IBOutlet UILabel *notesLabel;
@property (retain, nonatomic) IBOutlet UILabel *notesText;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIView *mapViewBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *contactBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *hoursBackgroundView;
@property (retain, nonatomic) IBOutlet UIView *notesBackgroundView;


@property (retain, nonatomic) IBOutlet UILabel *poniedzialekInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *wtorekInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *srodaInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *czwartekInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *piatekInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *sobotaInfoLabel;
@property (retain, nonatomic) IBOutlet UILabel *niedzielaInfoLabel;


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
    
    //Cienie do teł z tekstami
    [GUIUtils addShadowAndCornersToView:self.mapViewBackgroundView];
    [GUIUtils addShadowAndCornersToView:self.contactBackgroundView];
    [GUIUtils addShadowAndCornersToView:self.hoursBackgroundView];
    [GUIUtils addShadowAndCornersToView:self.notesBackgroundView];
    
    //Wyświetl godziny otwarcia
    self.poniedzialekInfoLabel.text = [self.library.openHours objectForKey:@"poniedziałek"];
    self.wtorekInfoLabel.text = [self.library.openHours objectForKey:@"wtorek"];
    self.srodaInfoLabel.text = [self.library.openHours objectForKey:@"środa"];
    self.czwartekInfoLabel.text = [self.library.openHours objectForKey:@"czwartek"];
    self.piatekInfoLabel.text = [self.library.openHours objectForKey:@"piątek"];
    self.sobotaInfoLabel.text = [self.library.openHours objectForKey:@"sobota"];
    self.niedzielaInfoLabel.text = [self.library.openHours objectForKey:@"niedziela"];
    
    //Pokaż odpowiednie dane
    self.title = self.library.uniq;
    self.titleLabel.text = self.library.title;
    self.phoneLabel.text = self.library.phone;
    if(!self.emailLabel.text || ![self.emailLabel.text isEqualToString:@" "])
    {
        self.emailLabel.text = @"brak informacji";
    }
    self.adressLabel.text = self.library.adress;
    self.notesLabel.text = self.library.notes;
    
    if(!self.library.notes || [self.library.notes isEqualToString:@" "])
    {
        self.notesLabel.text = @"brak informacji";
        self.notesLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    
    //Ściskamy ściskamy
    self.scrollView.contentSize = [self.masterView sizeThatFits:CGSizeZero];
    [self.scrollView sizeToFit];
    
    [self.view sizeToFit];
    [self.masterView sizeToFit];
    
    
    //Wycentruj mape na bibliotece
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
    [self setNotesLabel:nil];
    self.library = nil;
    [self setScrollView:nil];
    [self setMasterView:nil];
    [self setMapView:nil];
    [self setMapViewBackgroundView:nil];
    [self setContactBackgroundView:nil];
    [self setHoursBackgroundView:nil];
    [self setNotesBackgroundView:nil];
    [self setPoniedzialekInfoLabel:nil];
    [self setWtorekInfoLabel:nil];
    [self setSrodaInfoLabel:nil];
    [self setCzwartekInfoLabel:nil];
    [self setPiatekInfoLabel:nil];
    [self setSobotaInfoLabel:nil];
    [self setNiedzielaInfoLabel:nil];
    [self setNotesText:nil];
    [super viewDidUnload];
}
@end
