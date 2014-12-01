//
//  ViewController.m
//  MapView2
//
//  Created by Aditya Narayan on 11/24/14.
//  Copyright (c) 2014 John Bogil. All rights reserved.
//  40.74727,	-73.9800645

#import "ViewController.h"


@interface ViewController ()

@end

#define TTT_LAT  40.741444;
#define TTT_LONG  -73.990070;
#define API_KEY @""
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Set the TTT logo
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 25, 180, 45)];
    UIImage *image = [UIImage imageNamed:@"logo2.png"];
    imageView.image = image;
    [imageView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [imageView.layer setBorderWidth:1.0];
    [self.view addSubview:imageView];

    [self pinTurnToTech];

    NSString *search = @"bar";
    [self queryGooglePlaces:search];
    
    
}

-(void)pinTurnToTech{
    
   
    CLLocationCoordinate2D turnToTechLocation;
    turnToTechLocation.latitude = TTT_LAT;
    turnToTechLocation.longitude = TTT_LONG;
    
    // Create a region
    MKCoordinateRegion region;
    
    // Set the region's bounds
    region = MKCoordinateRegionMakeWithDistance(turnToTechLocation, 1000, 1000);
    
    // Add the region to the map
    [self.mapView setRegion: region animated: YES];
    
    MapPin *myAnnotation = [MapPin alloc];
    myAnnotation.coordinate = turnToTechLocation;
    myAnnotation.title = @"TurnToTech";
    myAnnotation.subtitle = @"iOS Development Bootcamp";
    
    [self.mapView addAnnotation:myAnnotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Segment Control
-(IBAction)setMap:(id)sender{
    
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
            
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
            
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
            
        default:
            break;
    }
}


-(void)queryGooglePlaces: (NSString*) googleType {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", 40.741444, -73.990070, [NSString stringWithFormat:@"%i", 1500], googleType, API_KEY];
    
    NSURL *gooleRequestURL = [NSURL URLWithString:url];
    

    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL: gooleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData*)responseData{
    NSError *error;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *places = [json objectForKey:@"results"];
    
    NSLog(@"Google Data: %@", places);
    
    [self plotPositions:places];
}


-(void)plotPositions:(NSArray*)data{
    
    // Need to remove previous annotations, excluding TTT
    for(id<MKAnnotation> annotation in self.mapView.annotations){
        if (!([annotation.title isEqual:@"TurnToTech"])) {
            [self.mapView removeAnnotation:annotation];
        }
        }

    
    for(int i=0; i< [data count]; i++){
        
        // Retrieve the NSDictionary object in each index of the array
        NSDictionary *place = [data objectAtIndex:i];
        
        // Retrieve location info for place
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        // Retrieve lat/long info for geo info
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        // Retrieve name/adddress info for place info
        NSString *name = [place objectForKey:@"name"];
        NSString *vicinity = [place objectForKey:@"vicinity"];
        
        // Create a special variable to hold this coordinate info
        CLLocationCoordinate2D placeCoord;
        
        // Set the lat/long
        placeCoord.latitude = [[loc objectForKey:@"lat"]doubleValue];
        placeCoord.longitude = [[loc objectForKey:@"lng"]doubleValue];
        
        // Create a new annotation
        MapPin *placeObject = [[MapPin alloc]init];
        placeObject.title = name;
        placeObject.subtitle = vicinity;
        placeObject.coordinate = placeCoord;
        [self.mapView addAnnotation:placeObject];
    }
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    

    static NSString *identifier = @"MapPin";
    
    if([annotation isKindOfClass:[MapPin class]]){
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annotationView == nil){
            
            annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        else{
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
        }
    return nil;
    }
@end
