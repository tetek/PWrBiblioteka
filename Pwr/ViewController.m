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

@interface ViewController ()

@property (nonatomic, assign) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet UIButton *scanButton;
@property (nonatomic, assign) IBOutlet UIButton *infoButton;

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
    [UIView animateWithDuration:10.0
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         _backgroundImageView.center = CGPointMake(_backgroundImageView.center.x + 50,_backgroundImageView.center.y+50);
                     }
                     completion:NULL];
    
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
    [_HUD show:YES];
    NSArray *books = [BookListFetcher fetchBooksForQuery:query];
    for (Book *book in books) {
        NSLog(@"%@",book);
    }
    [_HUD hide:YES];
}
@end
