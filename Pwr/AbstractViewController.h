//
//  AbstractViewController.h
//  PWrBiblioteka
//
//  Created by Wojciech Mandrysz on 10/15/13.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import "M13ProgressHUD.h"

@class M13ProgressHUD;

@interface AbstractViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) M13ProgressHUD *HUD;

+ (instancetype)newFromNib;

- (void)openWebsiteForURL:(NSURL*)url;
- (void)call:(NSString*)phoneNumber;
- (void)sendEmailTo:(NSString*)email;
@end
