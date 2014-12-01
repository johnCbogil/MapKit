//
//  ViewController.h
//  MapView2
//
//  Created by Aditya Narayan on 11/24/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "MapPin.h"




// Create delegates for LocationManager and MapView
@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currentDist;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

// Action tied to the segmentController
-(IBAction)setMap:(id)sender;



@end

