//
//  GUIUtils.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "GUIUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation GUIUtils

+ (void)setupTextField:(UITextField *)textField{
    textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, 280, 50);
    textField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    textField.returnKeyType = UIReturnKeySearch;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:16];
}

+ (void)setupButton:(UIButton*)button{
    button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
+ (void)addShadowAndCornersToView:(UIView*)view{
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 0; // if you like rounded corners
    view.layer.shadowOffset = CGSizeMake(-5, 5);
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.2;
    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
}
+ (UIBarButtonItem*)makeBackButtonforNavigationController:(UINavigationController *)navigationController{
    UIImage *image = [UIImage imageNamed:@"back-arrow"];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [but setImage:image forState:UIControlStateNormal];
    [but setFrame:CGRectMake(0, 0, image.size.width*1.5, image.size.height)];
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView:but] autorelease];
    
    return backButton;
}
@end
