//
//  MapPin.h
//  MapView2
//
//  Created by Aditya Narayan on 11/24/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapPin : NSObject <MKAnnotation>


@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
