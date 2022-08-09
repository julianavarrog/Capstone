//
//  finalRegistrationViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "UserFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "UserTypeViewController.h"
#import "UserProfilePictureViewController.h"

@interface UserFinalRegistrationViewController ()<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) NSString *type;

@end

@implementation UserFinalRegistrationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _userLocation = [[NSMutableArray alloc] init];
    [self CurrentLocationIdentifier];
    
    self.signupButton.layer.cornerRadius = 20;
    self.signupButton.clipsToBounds = YES;
}

#pragma mark - Fetching user location

//initalizes Current Location.
- (void) CurrentLocationIdentifier{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

//create an array and add lat and long to it as strings.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    NSString *latitudeString = [NSString stringWithFormat:@"%0.0f",  location.coordinate.latitude];
    NSString *longitudeString = [NSString stringWithFormat:@"%0.0f", location.coordinate.longitude];
    [_userLocation addObject:latitudeString];
    [_userLocation addObject:longitudeString];
    NSLog(@"%@",_userLocation);
}

#pragma mark - Final Registration for PFUser and PFObject(UserDetail)

- (void) registerUser{
    // initialize a user object
    PFUser *newUser = [PFUser user];
    //set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    //newUser.name = self.passwordField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"PFUser for User registered successfully");
            //initalize PFObject
            PFObject *userDetail = [PFObject objectWithClassName:@"UserDetail"];
            userDetail[@"userID"] = newUser.objectId;
            userDetail[@"Name"]= self.nameField.text;
            userDetail[@"Location"] = self.userLocation;
            [userDetail saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self performSegueWithIdentifier:@"uploadPictureSegue" sender:newUser.objectId];
                }else{
                    NSLog(@"Error: %@", error.localizedDescription);
                }
            }];
        }
    }];
}

- (IBAction)signUpButton:(id)sender {
    [self registerUser];
}
#pragma mark - Navegation
//must send objectId to next View Controller to update its corresponding Parse table
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"uploadPictureSegue"]){
        NSString *objectId = (NSString *) sender;
        UserProfilePictureViewController * vc = [segue destinationViewController];
        vc.objectToUpdatePicture = objectId;
    }
}
    
@end
