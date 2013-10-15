//
//  MapCell.h
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 31.03.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapCell : UITableViewCell
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
