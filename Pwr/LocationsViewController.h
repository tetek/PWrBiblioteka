//
//  LocationsViewController.h
//  Pwr
//
//  Created by Wojciech Mandrysz on 12/15/12.
//  Copyright (c) 2012 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AbstractViewController.h"
@interface LocationsViewController : AbstractViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
- (id) initWithPlaces:(NSDictionary*)arr AndTableData:(NSArray *) data;
@end
