//
//  ViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "MainViewController.h"
#import "HTMLParser.h"
#import "BookListFetcher.h"
#import "Book.h"
#import "GUIUtils.h"
#import "BookListViewController.h"

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *logo;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *scanButton;
@property (nonatomic, weak) IBOutlet UIButton *callButton;
@property (nonatomic, weak) IBOutlet UIButton *mailButton;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [GUIUtils setupTextField:_textField];
//    [GUIUtils setupButton:_scanButton];
//    _textField.delegate = self;
    [self addParallex:25];
    
}
- (void) addParallex:(int)value{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(value);
    verticalMotionEffect.maximumRelativeValue = @(-value);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-value);
    horizontalMotionEffect.maximumRelativeValue = @(value);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [_backgroundImageView addMotionEffect:group];
}

- (void) viewWillAppear:(BOOL)animated{
    //Animate background
    [self.navigationController setNavigationBarHidden:YES];    
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = _logo.frame;
        frame.origin.y = 50;
        _logo.frame = frame;
                    
    }];

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
//    [UIView animateWithDuration:10.0
//                          delay:0.0
//                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
//                     animations:^{
//                         _backgroundImageView.center = CGPointMake(_backgroundImageView.center.x + 50,_backgroundImageView.center.y+50);
//                     }
//                     completion:^(BOOL finished){
//                         _backgroundImageView.center = self.view.center;
//                     }];

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


- (void) searchForBookWithQuery:(NSString*)query{
//    [self.HUD showWhileExecuting:@selector(searchForBookWithQueryNoThread:) onTarget:self withObject:query animated:YES];
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
        [self.HUD dismiss:YES];
        if (books.count > 0) {
            BookListViewController *bookList = [[BookListViewController alloc] initWithBooks:books];
            [self.navigationController pushViewController:bookList animated:YES];
            
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Brak Wyników" message:@"Nie znaleziono pozycji w bibliotece" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
    
}


- (IBAction)sendMail:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"sekrbg@pwr.wroc.pl"]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Uwaga" message:@"Prawdopodobnie nie masz skonfigurowanej żadnej skrzynki. Przytrzymaj aby skopiować adres email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Szukaj";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 250.;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ALA"];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    if ([indexPath row] == 0) {
        if (!self.textField) {
            
            self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 300, 30)];
            self.textField.delegate = self;
            self.textField.textColor = [GUIUtils redColor];
            self.textField.textAlignment = NSTextAlignmentRight;
            self.textField.placeholder = @"słowo kluczowe";
            self.textField.returnKeyType = UIReturnKeySearch;
            
            [cell.contentView addSubview:self.textField];
        }
    }
    else{
        cell.textLabel.text = @"Zeskanuj kod kreskowy";
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.textColor = [GUIUtils redColor];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        [self.textField becomeFirstResponder];
    }
    else{
        [self scanButtonTapped];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
