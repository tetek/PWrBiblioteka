//
//  Library.h
//  PWrBiblioteka
//
//  Created by Bartosz Hernas on 07.01.2013.
//  Copyright (c) 2013 tetek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Library : NSObject <MKAnnotation>
+library;

@property (nonatomic, retain) NSString * uniq;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * shorttitle;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * adress;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDictionary * openHours;
@property (nonatomic, retain) NSNumber * available;
@property (nonatomic) CLLocationCoordinate2D cord;

- (Library *) initWithTitle: (NSString *) title coordinate: (CLLocationCoordinate2D)coordinate;
@end
