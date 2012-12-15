//
//  ViewController.m
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "ViewController.h"
#import "NSString+POST.h"
#import "HTMLParser.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *lol = @"http://aleph.bg.pwr.wroc.pl/F/BJU6EDE67CYTAKMUDD6KT7RDMCXS3UKN1IXCFHI6MPSKRCR2KF-28962?func=find-b&REQUEST=algebra+liniowa&x=0&y=0&find_code=WRD&ADJACENT=N";
    lol = [lol stringByEscapingURL];
    NSLog(@"%@",lol);
    NSString *elo = [NSString stringWithContentsOfURL:[NSURL URLWithString:lol] encoding:NSUTF8StringEncoding error:nil];
    
    
    NSError *error = nil;

    HTMLParser *parser = [[HTMLParser alloc] initWithString:elo error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *tableNode = [bodyNode findChildWithAttribute:@"id" matchingName:@"short_table" allowPartial:YES];
//    NSArray *inputNodes = [bodyNode findChildTags:@"table"];

    for (HTMLNode *inputNode in tableNode.children) {
//        if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
            NSLog(@"%@", [inputNode allContents]); //Answer to first question
//        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
