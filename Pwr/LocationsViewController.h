//
//  LocationsViewController.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import "AbstractViewController.h"

@interface LocationsViewController : AbstractViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>

- (id) initWithPlaces:(NSDictionary*)fetched AndTableData:(NSArray *) data;

@end
