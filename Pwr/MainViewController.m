//
//  ViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "MainViewController.h"
#import "BookListFetcher.h"
#import "BookListViewController.h"

@interface MainViewController ()

@property (weak) IBOutlet UILabel *header;
@property (weak) IBOutlet UILabel *subheader;

@property (weak) IBOutlet UIButton *searchButton;
@property (weak) IBOutlet UITextField *textField;

@property (weak) IBOutlet UIButton *scanButton;

@property (weak) IBOutlet UIView *infoView;
@property (weak) IBOutlet UIButton *infoButton;

-(IBAction)searchTapped:(id)sender;
-(IBAction)info:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.header.textColor = [GUIUtils blueColor];

    self.subheader.textColor = [GUIUtils orangeColor];
    
    self.textField.font = [GUIUtils fontWithSize:20];
    self.textField.textColor = [GUIUtils orangeColor];
    self.textField.delegate = self;
    
    self.infoView.backgroundColor = [GUIUtils blueColor];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

////////////////////////////////////////////////////////
#pragma mark - TextField Setup
////////////////////////////////////////////////////////

- (BOOL)isTextFieldActive{
    return self.textField.userInteractionEnabled;
}

- (void)showTextField{
    CGPoint buttonCenter = self.searchButton.center;
    buttonCenter.x = self.searchButton.frame.size.width/2.;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.searchButton.center = buttonCenter;
        self.textField.userInteractionEnabled = YES;
        [self.textField becomeFirstResponder];
        
    } completion:nil];
}
- (void)hideTextField{
    
    CGPoint buttonCenter = self.searchButton.center;
    buttonCenter.x = self.view.frame.size.width/2.;
    
    self.textField.text = @"";
    self.textField.userInteractionEnabled = NO;
    [self.textField resignFirstResponder];

    [UIView animateWithDuration:0.4 animations:^{
        self.searchButton.center = buttonCenter;
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    [self searchForBookWithQuery:textField.text];
    return YES;
}

////////////////////////////////////////////////////////
#pragma mark - Info page
////////////////////////////////////////////////////////


- (BOOL)isInfoPresented{
    return self.infoView.frame.origin.y < 400;
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}


////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////


- (IBAction)info:(id)sender{
    
    CGRect rect = self.infoView.frame;
    rect.origin.y = self.isInfoPresented ? self.view.frame.size.height - 60 : self.view.frame.size.height - rect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.infoButton.transform = CGAffineTransformMakeRotation(self.isInfoPresented ? 0 : M_PI);
        self.infoView.frame = rect;
    }];
    
}

- (IBAction)openGithub:(id)sender{
    [self openWebsiteForURL:[NSURL URLWithString:@"http://github.com/tetek/PwrBiblioteka"]];
}

- (IBAction)openAuthor:(id)sender{
    [self openWebsiteForURL:[NSURL URLWithString:@"http://tetek.wordpress.com"]];    
}

- (IBAction)openContributors:(id)sender{
    [self openWebsiteForURL:[NSURL URLWithString:@"http://hern.as"]];
}


- (IBAction)searchTapped:(id)sender{

    if (self.isTextFieldActive) {
    
        if (self.textField.text.length > 0) {
            [self.textField resignFirstResponder];
            [self searchForBookWithQuery:self.textField.text];
        }
        else{
            [self hideTextField];
        }
    }
    else{
        [self showTextField];
    }
}

- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];

    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    NSString *text  = symbol.data;
    [self searchForBookWithQuery:text];

    [reader dismissViewControllerAnimated:YES completion:nil];
}


- (void) searchForBookWithQuery:(NSString*)query{
    [self.HUD show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self searchForBookWithQueryNoThread:query];
    });
}

- (void) searchForBookWithQueryNoThread:(NSString*)query{
    
    NSArray *books;
    @try {
        
        books = [BookListFetcher fetchBooksForQuery:query];
    }
    
    @catch (NSException *exception) {
        [self.HUD hide:YES];
        [[[UIAlertView alloc] initWithTitle:exception.name message:exception.reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.HUD hide:YES];
        if (books.count > 0) {
            BookListViewController *bookList = [[BookListViewController alloc] initWithBooks:books];
            [self.navigationController pushViewController:bookList animated:YES];
            
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Brak Wyników" message:@"Nie znaleziono pozycji w bibliotece" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
    
}

@end
