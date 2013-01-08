//
//  LibraryInfo.m
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 08.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "LibraryInfoViewController.h"
#import "GUIUtils.h"

@interface LibraryInfoViewController ()
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *emailLabel;
@property (retain, nonatomic) IBOutlet UILabel *adressLabel;
@property (retain, nonatomic) IBOutlet UILabel *openHoursLabel;
@property (retain, nonatomic) IBOutlet UILabel *notesLabel;
@property (retain, nonatomic) IBOutlet UIView *bgAdres;
@property (retain, nonatomic) IBOutlet UIView *bgNotes;

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
    self.title = self.library.uniq;
    self.bgAdres.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    self.bgNotes.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    self.titleLabel.text = self.library.title;
    self.phoneLabel.text = self.library.phone;
    self.emailLabel.text = self.library.email;
    self.adressLabel.text = self.library.adress;
    //self.openHoursLabel.text = self.library.openHours;
    self.notesLabel.text = self.library.notes;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}

- (void)dealloc {
    [_titleLabel release];
    [_phoneLabel release];
    [_emailLabel release];
    [_adressLabel release];
    [_openHoursLabel release];
    [_notesLabel release];
    [_bgAdres release];
    [_bgNotes release];
    [super dealloc];
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
    [super viewDidUnload];
}
@end
