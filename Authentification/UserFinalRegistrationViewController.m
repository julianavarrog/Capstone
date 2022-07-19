//
//  finalRegistrationViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "UserFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "userTypeViewController.h"
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
    // Do any additional setup after loading the view.
}


- (void) CurrentLocationIdentifier{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];

    [locationManager startUpdatingLocation];
    
}

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
            PFObject *userDetail = [PFObject objectWithClassName:@"UserDetail"];
            userDetail[@"userID"] = newUser.objectId;
            userDetail[@"Name"]= self.nameField.text;
            userDetail[@"Location"] = self.userLocation;
            [userDetail saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    [self performSegueWithIdentifier:@"uploadPictureSegue" sender:newUser.objectId];
                }else{
                    //there is a problem
                }
            }];
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signUpButton:(id)sender {
    [self registerUser];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"uploadPictureSegue"]){
        NSString *objectId = (NSString *) sender;
        UserProfilePictureViewController * vc = [segue destinationViewController];
        vc.objectToUpdatePicture = objectId;
    }
}
    
@end
