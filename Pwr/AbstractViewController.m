//
//  AbstractViewController.m
//  PWrBiblioteka
//
//  Created by Wojciech Mandrysz on 10/15/13.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "AbstractViewController.h"
#import "M13ProgressViewRing.h"
#import "PBWebViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    [self.HUD setIndeterminate:YES];
    self.HUD.progressViewSize = CGSizeMake(60.0, 60.0);
    [self.view addSubview:self.HUD];
    self.view.backgroundColor = [GUIUtils brightColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationController.navigationBar.barTintColor = [GUIUtils brightColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [GUIUtils blueColor],NSFontAttributeName:[GUIUtils fontWithSize:20]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)openWebsiteForURL:(NSURL*)url{
    PBWebViewController *controller = [PBWebViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-down"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    controller.navigationItem.leftBarButtonItem.action = @selector(dismiss);
    controller.navigationItem.leftBarButtonItem.target = self;
    controller.URL = url;
    [self presentViewController:nav animated:YES completion:nil];
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


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
@end
