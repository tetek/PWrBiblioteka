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

@property (nonatomic, strong) NSString * uniq;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * shorttitle;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * adress;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSDictionary * openHours;
@property (nonatomic, strong) NSNumber * available;
@property (nonatomic) CLLocationCoordinate2D cord;

- (Library *) initWithTitle: (NSString *) title coordinate: (CLLocationCoordinate2D)coordinate;
- (Library *) initWithDictionaryData: (NSDictionary *) data;
- (NSDictionary *) asDictionary;
@end
