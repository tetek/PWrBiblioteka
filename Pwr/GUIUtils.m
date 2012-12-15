//
//  GUIUtils.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "GUIUtils.h"

@implementation GUIUtils

+ (void)setupTextField:(UITextField *)textField{
    textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, 280, 50);
    textField.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    textField.returnKeyType = UIReturnKeySearch;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:14];
}

+ (void)setupButton:(UIButton*)button{
    button.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
@end
