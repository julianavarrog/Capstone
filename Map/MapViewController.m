//
//  MapViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/18/22.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "Professional.h"
#import "FilterViewController.h"
#import "MapCircle.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property CLLocation *location;
@property CLLocationCoordinate2D *coordinate;


@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.zoomEnabled = YES;
    self.scrollEnabled = YES;
    self.pitchEnabled = YES;
    [self.mapView setDelegate: self];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(detectSwipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self  action:@selector(detectSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    [self startUserLocationSearch];
}

#pragma mark - Swipe Gesture Recognizer
- (IBAction)detectSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"%lu",self.tabBarController.selectedIndex);
        self.tabBarController.selectedIndex +=1;
        NSLog(@"%lu",self.tabBarController.selectedIndex);
   } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
       self.tabBarController.selectedIndex -=1;
   }
}

#pragma mark - CLLocation Manager
-(void)startUserLocationSearch{

     self.locationManager = [[CLLocationManager alloc]init];
     self.locationManager.delegate = self;
     self.locationManager.distanceFilter = kCLDistanceFilterNone;
     self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;

     if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
         [self.locationManager requestWhenInUseAuthorization];
     }
     [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    [self.locationManager stopUpdatingLocation];
    self.location = self.locationManager.location;
    self.mapView.showsUserLocation = YES;
    self.mapView.zoomEnabled = YES;
    [self.mapView setCenterCoordinate: self.locationManager.location.coordinate];
    [self getProfessionals];
}

#pragma mark - Query Professional's location
-(void) getProfessionals {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *professionals, NSError *error){
        if(professionals != nil){
            self.professionals = [[NSMutableArray alloc] init];
            self.professionalsFiltered = [[NSMutableArray alloc] init];
            for (Professional * professional in professionals){
                NSNumber *latitude = professional[@"latitude"];
                NSNumber *longitude = professional[@"longitude"];
        
                CLLocation *professionalLocation = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
                CLLocationDistance distance = [self.location distanceFromLocation:professionalLocation];
                NSLog (@"Current Location %@: [%f,%f] - Professional Location: [%f,%f] -> Distance: %f",professional[@"Name"], self.location.coordinate.latitude, self.location.coordinate.longitude, latitude.doubleValue, longitude.doubleValue,distance);
                
                professional[@"distance"] = @(distance);
                
                [self.professionals addObject:professional];
                [self.professionalsFiltered addObject:professional];
            }
            [self buildPointsInMap];
            [self buildCircleInMap: @300000 andMaxCoordinate: self.location.coordinate];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Map Annotations and Overlays

-(void)buildPointsInMap {
    [self.mapView removeAnnotations: self.mapView.annotations];
    for(Professional* professional in self.professionalsFiltered) {
        MapPin * point = [[MapPin alloc]
                          initWithCoordinates:CLLocationCoordinate2DMake([professional[@"latitude"] floatValue],[professional[@"longitude"] floatValue])
                          placeName: professional[@"Name"]
                          description: [NSString stringWithFormat:@"Distance: %0.0f KM", ([professional[@"distance"] floatValue]/1000.0)]];
        
        [self.mapView addAnnotation:point];
    }
}

-(void) buildCircleInMap:(NSNumber *) distance andMaxCoordinate: (CLLocationCoordinate2D) coordinate {
    [self.mapView removeOverlays: self.mapView.overlays];
    CLLocationDistance fenceDistance = [distance intValue] <= 3000000 ? [distance doubleValue] : 0;
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.location.coordinate radius:fenceDistance];
    [self.mapView addOverlay: circle];
    
    if ( [distance intValue] > 3000000) {
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.location.coordinate, [distance intValue], [distance intValue]);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
    }
}

- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay {
    MKCircleRenderer* aRenderer = [[MKCircleRenderer
                                    alloc]initWithCircle:(MKCircle *)overlay];
    aRenderer.fillColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.5];
    aRenderer.strokeColor = [[UIColor systemPurpleColor] colorWithAlphaComponent:0.9];
    aRenderer.lineWidth = 2;
    aRenderer.lineDashPattern = @[@2, @5];
    aRenderer.alpha = 0.5;
    return aRenderer;
}

#pragma mark - Filter Map
- (IBAction)filterButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"mapFilter" sender:nil];
}


- (void)sendDataToFilter:(nonnull Filter *)filter {
    
    // predicates are conditionals to array.
    NSPredicate *predicateLocation = [NSPredicate predicateWithFormat:@"distance <= %d", filter.selectedDistance.intValue];
    NSPredicate *predicatePrice = [NSPredicate predicateWithFormat:@"Price <= %d", filter.selectedPrice.intValue];
    NSPredicate *predicateAge = [NSPredicate predicateWithFormat:@"Age <= %d", filter.selectedAge.intValue];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicatePrice, predicateAge, predicateLocation]];
    NSMutableArray* firstFiltered = [[NSMutableArray alloc] initWithArray:[self.professionals filteredArrayUsingPredicate:predicate]];
    NSMutableArray * specialityFiltered = [[NSMutableArray alloc]init];
    
    if (filter.selectedSpeciality.count > 0){
        for (Professional* professional in firstFiltered){
            NSArray * specialitys = professional[@"Speciality"];
            for (NSString * speciality in specialitys){
                if([filter.selectedSpeciality containsObject:speciality]){
                    if(![specialityFiltered containsObject:professional]){
                        [specialityFiltered addObject:professional];
                    }
                }
            }
        }
        self.professionalsFiltered = [[NSMutableArray alloc] initWithArray:specialityFiltered];
    } else{
        self.professionalsFiltered = [[NSMutableArray alloc] initWithArray: firstFiltered];
    }
    NSMutableArray* languagesFiltered = [[NSMutableArray alloc] init];
    if (filter.selectedLanguage.count > 0){
        for (Professional* professional in self.professionalsFiltered){
            NSArray * languages = professional[@"Language"];
            for (NSString * language in languages){
                if([filter.selectedLanguage containsObject:language]){
                    if(![languagesFiltered containsObject:professional]){
                        [languagesFiltered addObject:professional];
                    }
                }
            }
        }
        self.professionalsFiltered = [[NSMutableArray alloc] initWithArray:languagesFiltered];
    }
    [self buildPointsInMap];
    [self buildCircleInMap: filter.selectedDistance andMaxCoordinate: self.location.coordinate];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual:@"mapFilter"]) {
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
        filterVC.professionals = self.professionals;
    }
}

@end
