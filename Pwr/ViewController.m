//
//  ViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "ViewController.h"
#import "HTMLParser.h"
#import "BookListFetcher.h"
#import "Book.h"
#import "GUIUtils.h"
#import "MBProgressHUD.h"
#import "BookListViewController.h"

@interface ViewController ()

@property (nonatomic, assign) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, assign) IBOutlet UIImageView *logo;
@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet UIButton *scanButton;
@property (nonatomic, assign) IBOutlet UIButton *callButton;
@property (nonatomic, assign) IBOutlet UIButton *mailButton;

@property (nonatomic, retain) MBProgressHUD *HUD;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GUIUtils setupTextField:_textField];
    [GUIUtils setupButton:_scanButton];
    _textField.delegate = self;
    
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:_HUD];
}

- (void) viewWillAppear:(BOOL)animated{
    //Animate background
    [self.navigationController setNavigationBarHidden:YES];

    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = _logo.frame;
        frame.origin.y = 30;
        _logo.frame = frame;
                    
    }];
    _textField.hidden = NO;
    _textField.alpha = 0.01;
    [UIView animateWithDuration:2.0 animations:^{
        
        _textField.alpha = 1.0;
        _scanButton.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            
            _callButton.alpha = 1.0;
            _mailButton.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [self backgroundAnimation];
        }];
    }];
    
}
- (void) backgroundAnimation{
    [UIView animateWithDuration:10.0
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         _backgroundImageView.center = CGPointMake(_backgroundImageView.center.x + 50,_backgroundImageView.center.y+50);
                     }
                     completion:^(BOOL finished){
                         _backgroundImageView.center = self.view.center;
                     }];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    [self searchForBookWithQuery:textField.text];
    return YES;
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
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    

    NSString *text  = symbol.data;
    [self searchForBookWithQuery:text];

//    resultImage.image =
//    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchForBookWithQuery:(NSString*)query{
    [self.HUD showWhileExecuting:@selector(searchForBookWithQueryNoThread:) onTarget:self withObject:query animated:YES];
}
- (void) searchForBookWithQueryNoThread:(NSString*)query{
        
        
    NSArray *books;
    @try {
        
        books = [BookListFetcher fetchBooksForQuery:query];
    }
    
    @catch (NSException *exception) {
        [_HUD hide:YES];
        [[[[UIAlertView alloc] initWithTitle:exception.name message:exception.reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (books.count > 0) {
            BookListViewController *bookList = [[[BookListViewController alloc] initWithBooks:books] autorelease];
            [self.navigationController pushViewController:bookList animated:YES];
        }
        else{
            [[[[UIAlertView alloc] initWithTitle:@"Brak Wyników" message:@"Nie znaleziono pozycji w bibliotece" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
        }
    });
    
}


- (IBAction)sendMail:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"sekrbg@pwr.wroc.pl"]];
        [self presentViewController:controller animated:YES completion:Nil];
        [controller release];
    }
    else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Uwaga" message:@"Prawdopodobnie nie masz skonfigurowanej żadnej skrzynki. Przytrzymaj aby skopiować adres email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }

}
- (IBAction)call:(id)sender{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:713202331"]]];
    }
    else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Uwaga" message:@"Twoje urządzenie nie nie potrafi wykonywać połączeń." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
        [Notpermitted release];
    }

}
#pragma mark Mail Compose delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
