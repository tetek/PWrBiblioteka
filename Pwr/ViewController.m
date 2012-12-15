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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *books = [BookListFetcher fetchBooksForQuery:@"analiza matematyczna"];
    for (Book *book in books) {
        NSLog(@"%@",book);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
