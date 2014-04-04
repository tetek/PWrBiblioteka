//
//  ViewController.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "AbstractViewController.h"
#import "ZBarReaderViewController.h"

@interface MainViewController : AbstractViewController <UITextFieldDelegate, ZBarReaderDelegate>

@end
