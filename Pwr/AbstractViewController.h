//
//  AbstractViewController.h
//  PWrBiblioteka
//
//  Created by Wojciech Mandrysz on 10/15/13.
//  Copyright (c) 2013 tetek. All rights reserved.
//

@class M13ProgressHUD;

@interface AbstractViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) M13ProgressHUD *HUD;

+ (instancetype)newFromNib;

- (void)openWebsiteForURL:(NSURL*)url;

@end
