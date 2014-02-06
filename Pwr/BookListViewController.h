//
//  BookListViewController.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
@interface BookListViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate>
- (id)initWithBooks:(NSArray*)books;
@end
