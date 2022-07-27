//
//  NewFilterInfoViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/13/22.
//

#import "NewFilterInfoViewController.h"
#import "ProfessionalFinalRegistrationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Parse/Parse.h"
#import "Professional.h"
#import "ProfessionalProfilePictureViewController.h"
#import "Speciality.h"


@interface NewFilterInfoViewController ()<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (strong, nonatomic) NSMutableArray *professional;
@property CLLocation *location;

@end

@implementation NewFilterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _countFamily = 0;
    _countBehavioural = 0;
    _countChild = 0;
    _countStress = 0;
    _countGeneral = 0;
    _countLife = 0;
    
    _countSpanish = 0;
    _countEnglish = 0;
    _countFrench = 0;
    _countPortuguese = 0;
    _countMandarin = 0;
    _countOther = 0;
    
    _specialityArray = [[NSMutableArray alloc] init];
    _languageArray = [[NSMutableArray alloc] init];
    
    _userLocation = [[NSMutableArray alloc] init];
    
    [self CurrentLocationIdentifier];
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
    self.location = location;
}

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


//change to accept enums
//initalize speciality

- (void)didTapSpeciality:(SpecialityFilterType)speciality {
    
    NSString *filterString = [Speciality convertLabelFromSpecialistType:speciality];
 //   [_specialityArray addObject:filterString];
//    if(!speciality.isSelected) {
//        [_specialityArray addObject:speciality.specialityLabel];
//        speciality.specialityButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
//        speciality.isSelected = YES;
//    } else {
//        [_specialityArray removeObject:speciality.specialityLabel];
//        speciality.isSelected = NO;
//        speciality.specialityButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
//    }
}
 
 - (IBAction)tappedFamily:(id)sender
 {
     [self didTapSpeciality: SpecialityFilterTypeFamilyAndFriends];
     if (self.familyButton.isSelected) {
         self.familyButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
     } else {
         self.familyButton.backgroundColor  = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
     }
 }





//Speciality
//- (IBAction)tappedFamily:(id)sender {
//    if (_countFamily == 0){
//        [_specialityArray addObject:@"Family & Friends"];
//        _familyButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
//        _countFamily = @1;
//    }else{
//        [_specialityArray removeObject:@"Family & Friends"];
//        _countFamily = 0;
//        _familyButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
//
//    }
//    NSLog(@"%@",_specialityArray);
//}
 
- (IBAction)tappedBehavioural:(id)sender {

    if (_countBehavioural == 0){
        [_specialityArray addObject:@"Behavioural"];
        _behaviouralButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countBehavioural = @1;
    }else{
        [_specialityArray removeObject:@"Behavioural"];
        _countBehavioural = @0;
        _behaviouralButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    }
    NSLog(@"%@",_specialityArray);

}
- (IBAction)tappedChild:(id)sender {
    if (_countChild == 0){
        [_specialityArray addObject:@"Child Therapist"];
        _childButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countChild = @1;
    }else{
        [_specialityArray removeObject:@"Child Therapist"];
        _childButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countChild = @0;
    }
    NSLog(@"%@",_specialityArray);

}

- (IBAction)tappedStress:(id)sender {
    if (_countStress == 0){
        [_specialityArray addObject:@"Stress Managment"];
        _stressButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countStress = @1;
    }else{
        [_specialityArray removeObject:@"Stress Managment"];
        _stressButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countStress = @0;
    }
    NSLog(@"%@",_specialityArray);
}

- (IBAction)tappedGeneral:(id)sender {
    if (_countGeneral == 0){
        [_specialityArray addObject:@"General"];
        _generalButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countGeneral = @1;
    }else{
        [_specialityArray removeObject:@"General"];
        _generalButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countGeneral = @0;
    }
    NSLog(@"%@",_specialityArray);

}
- (IBAction)tappedLife:(id)sender {
    if (_countLife == 0){
        [_specialityArray addObject:@"Life Coaching"];
        _lifeButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countLife = @1;
    }else{
        [_specialityArray removeObject:@"Life Coaching"];
        _lifeButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countLife = @0;
    }
    NSLog(@"%@",_specialityArray);
}

//Languages
- (IBAction)tappedSpanish:(id)sender {
    if (_countSpanish == 0){
        [_languageArray addObject:@"Spanish"];
        _spanishButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countSpanish = @1;
    }else{
        [_languageArray removeObject:@"Spanish"];
        _spanishButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countSpanish = @0;
    }
    NSLog(@"%@",_languageArray);
}
- (IBAction)tappedEnglish:(id)sender {
    if (_countEnglish == 0){
        [_languageArray addObject:@"English"];
        _englishButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countSpanish = @1;
    }else{
        [_languageArray removeObject:@"English"];
        _englishButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countEnglish = @0;
    }
    NSLog(@"%@",_languageArray);
}
- (IBAction)tappedFrench:(id)sender {
    if (_countFrench == 0){
        [_languageArray addObject:@"French"];
        _frenchButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countFrench = @1;
    }else{
        [_languageArray removeObject:@"French"];
        _frenchButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countFrench = @0;
    }
    NSLog(@"%@",_languageArray);
}
- (IBAction)tappedPortuguese:(id)sender {
    if (_countPortuguese == 0){
        [_languageArray addObject:@"Portuguese"];
        _portugueseButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countPortuguese = @1;
    }else{
        [_languageArray removeObject:@"Portuguese"];
        _portugueseButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countPortuguese = @0;
    }
    NSLog(@"%@",_languageArray);
}
- (IBAction)tappedMandarin:(id)sender {
    if (_countMandarin == 0){
        [_languageArray addObject:@"Mandarin"];
        _mandarinButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countMandarin = @1;
    }else{
        [_languageArray removeObject:@"Mandarin"];
        _mandarinButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countMandarin = @0;
    }
    NSLog(@"%@",_languageArray);
}
- (IBAction)tappedOther:(id)sender {
    if (_countOther == 0){
        [_languageArray addObject:@"Other"];
        _otherButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countOther = @1;
    }else{
        [_languageArray removeObject:@"Other"];
        _otherButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countOther = @0;
    }
    NSLog(@"%@",_languageArray);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"uploadPictureSegue"]){
//        NSString*objectToUpdate = (NSString *) sender;
        ProfessionalProfilePictureViewController * vc = [segue destinationViewController];
        vc.objectToUpdatePicture = self.objectToUpdate;
    }
}


@end
