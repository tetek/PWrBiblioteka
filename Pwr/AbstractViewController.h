//
//  AbstractViewController.h
//  PWrBiblioteka
//
//  Created by Wojciech Mandrysz on 10/15/13.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"
#import "M13ProgressHUD.h"

@interface AbstractViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) M13ProgressHUD *HUD;

- (void)openWebsiteForURL:(NSURL*)url;
@end
