//
//  ProfessionalInfoViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/13/22.
//

#import "ProfessionalInfoViewController.h"
#import "ProfessionalFinalRegistrationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Parse/Parse.h"
#import "Professional.h"
#import "ProfessionalProfilePictureViewController.h"
#import "Speciality.h"
#import "Language.h"



@interface ProfessionalInfoViewController ()<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) NSMutableArray *professional;
@property CLLocation *location;

@end

@implementation ProfessionalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _specialityArray = [[NSMutableArray alloc] init];
    _languageArray = [[NSMutableArray alloc] init];
    _userLocation = [[NSMutableArray alloc] init];
    [self CurrentLocationIdentifier];
    
    self.continueButton.layer.cornerRadius = 20;
    self.continueButton.clipsToBounds = YES;
    }

#pragma mark - Location Manager for Professionals

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
    self.location = location;
}

#pragma mark - Update Filter Information

- (IBAction)priceSliderAction:(id)sender {
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
}

- (IBAction)ageSliderAction:(id)sender {
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
}

- (IBAction)finalSignUp:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query whereKey:@"userID" equalTo:self.objectToUpdate];
    [query getFirstObjectInBackgroundWithBlock:^ (PFObject * professional, NSError *error) {
        professional[@"Price"] = @(@(self.priceSlider.value).intValue);
        professional[@"Age"] = @(@(self.ageSlider.value).intValue);
        professional[@"Speciality"] = self.specialityArray;
        professional[@"Language"] = self.languageArray;
        professional[@"Location"] = self.userLocation;
        professional[@"latitude"] = @(self.location.coordinate.latitude);
        professional[@"longitude"] = @(self.location.coordinate.longitude);

        [professional save];
        
        [self performSegueWithIdentifier:@"uploadPictureSegue" sender: self.objectToUpdate];

    }];
}

// accepts enum tag
#pragma mark - Specialities
- (IBAction)tappedSpeciality:(id)sender
{
    [self didTapSpeciality:(UIButton*) sender];
}

- (void)didTapSpeciality:(UIButton *) button {
   NSString *filterString = [Speciality convertLabelFromSpecialistType:button.tag];
   if ([_specialityArray containsObject: filterString]) {
       [_specialityArray removeObject: filterString];
       button.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
   } else {
       [_specialityArray addObject: filterString];
       button.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
   }
   
   NSLog(@"%@",_specialityArray);
}

#pragma mark - Languages
- (IBAction)tappedLanguage:(id)sender
{
    [self didTapLanguage:(UIButton*) sender];
}

- (void)didTapLanguage:(UIButton *) button {
    NSString *filterString = [Language convertLabelFromLanguageType:button.tag];
    if ([_languageArray containsObject: filterString]) {
        [_languageArray removeObject: filterString];
        button.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    } else {
        [_languageArray addObject: filterString];
        button.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
    }
    
    NSLog(@"%@",_languageArray);
}

#pragma mark - Navegation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"uploadPictureSegue"]){
//        NSString*objectToUpdate = (NSString *) sender;
        ProfessionalProfilePictureViewController * vc = [segue destinationViewController];
        vc.objectToUpdatePicture = self.objectToUpdate;
    }
}


@end
