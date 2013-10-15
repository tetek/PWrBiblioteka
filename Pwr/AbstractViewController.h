//
//  AbstractViewController.h
//  PWrBiblioteka
//
//  Created by Wojciech Mandrysz on 10/15/13.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AbstractViewController : UIViewController
@property (nonatomic, strong) MBProgressHUD *HUD;
@end
