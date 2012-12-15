//
//  ViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "ViewController.h"
#import "HTMLParser.h"
#import "BookListFetcher.h"
#import "Book.h"
#import "GUIUtils.h"

@interface ViewController ()

@property (nonatomic, assign) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet UIButton *scanButton;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GUIUtils setupTextField:_textField];
    [GUIUtils setupButton:_scanButton];
    _textField.delegate = self;
    
    NSArray *books = [BookListFetcher fetchBooksForQuery:@"dupa smoka"];
    for (Book *book in books) {
        NSLog(@"%@",book);
    }
}

- (void) viewWillAppear:(BOOL)animated{
    //Animate background
    [UIView animateWithDuration:10.0
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         _backgroundImageView.center = CGPointMake(_backgroundImageView.center.x + 50,_backgroundImageView.center.y+50);
                     }
                     completion:NULL];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
