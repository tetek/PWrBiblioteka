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
@property (retain, nonatomic) IBOutlet UILabel *testLabel;
@property (nonatomic, retain) Library * library;
@end

@implementation LibraryInfoViewController

- (id) initWithLibrary:(Library *)library {
    self = [super initWithNibName:@"LibraryInfoViewController" bundle:nil];
    if (self) {
        self.library = [library retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.library.title;
    self.testLabel.text = [self.library description];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[GUIUtils makeBackButtonforNavigationController:self.navigationController]];
}

- (void)dealloc {
    [_testLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTestLabel:nil];
    [super viewDidUnload];
}
@end
