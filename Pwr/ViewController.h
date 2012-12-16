//
//  ViewController.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarImageScanner.h"
#import "ZBarReaderViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface ViewController : UIViewController <UITextFieldDelegate, ZBarReaderDelegate, MFMailComposeViewControllerDelegate>

@end
