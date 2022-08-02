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

@interface MapViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic)  CLLocationManager *locationManager;
@property CLLocation *location;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zoomEnabled = YES;
    self.scrollEnabled = YES;
    self.pitchEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self startUserLocationSearch];
}

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
     //CGFloat usersLatitude = self.locationManager.location.coordinate.latitude;
     //CGFloat usersLongidute = self.locationManager.location.coordinate.longitude;

    //Now you have your user's cooridinates
    self.location = self.locationManager.location;
    [self.mapView setCenterCoordinate: self.locationManager.location.coordinate];
    [self getProfessionals];
}

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
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

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
- (IBAction)filterButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"mapFilter" sender:nil];
}

// What is A ??
- (void)sendDataToA:(nonnull Filter *)filter {
    
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
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"mapFilter"]) {
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
        filterVC.professionals = self.professionals;
    }
}

@end
