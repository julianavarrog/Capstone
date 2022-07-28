//
//  FilterViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "FilterViewController.h"
#import "Professional.h"
#import "Filter.h"

@interface FilterViewController ()
@property (strong, nonatomic) NSNumber *selectedPrice;
@end

@implementation FilterViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
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
    
}

- (void)setup {
    NSNumber * maxPrice = 0;
    for (Professional* professional in self.professionals) {
        NSNumber *price = professional[@"Price"];
        if ([price intValue] > [maxPrice intValue]) {
            maxPrice = professional[@"Price"];
        }
    }
    self.priceSlider.maximumValue = maxPrice.floatValue;
    self.priceSlider.value = maxPrice.floatValue;
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
    
    NSNumber * maxAge = 0;
    for (Professional* professional in self.professionals){
        NSNumber *age = professional[@"Age"];
        if ([age intValue]> [maxAge intValue]){
            maxAge = professional[@"Age"];
        }
    }
    self.ageSlider.maximumValue = maxAge.floatValue;
    self.ageSlider.value = maxAge.floatValue;
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
    
    /*
    NSNumber * maxDistance = 0;
    for (Professional* professional in self.professionals) {
        NSNumber *distance = professional[@"Distance"];
        if ([distance intValue] > [maxDistance intValue]) {
            maxDistance = professional[@"Distance"];
        }
    }
    self.distanceSlider.maximumValue = maxDistance.floatValue;
    self.distanceSlider.value = maxDistance.floatValue;
    self.distanceAmount.text = [NSString stringWithFormat:@"%0.0f", self.distanceSlider.value];
   */
}

- (IBAction)didApplyFilters:(id)sender {
    Filter* filter = [[Filter alloc] init];
    filter.selectedPrice = @(self.priceSlider.value);
    filter.selectedAge = @(self.ageSlider.value);
    //filter.selectedDistance = @(self.distanceSlider.value);
    filter.selectedSpeciality = self.specialityArray;
    filter.selectedLanguage = self.languageArray;
    
    [delegate sendDataToA: filter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tappedFamily:(id)sender {
    if ([_countFamily intValue] == 0){
        [_specialityArray addObject:@"Family & Friends"];
        _familyButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countFamily = @1;
    }else{
        [_specialityArray removeObject:@"Family & Friends"];
        _countFamily = 0;
        _familyButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];

    }
    NSLog(@"%@",_specialityArray);
}
- (IBAction)tappedBehavioural:(id)sender {

    if ([_countBehavioural intValue] == 0){
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
    if ([_countChild intValue] == 0){
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
    if ([_countStress intValue] == 0){
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
    if ([_countGeneral intValue] == 0){
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
    if ([_countLife intValue] == 0){
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
    if ([_countSpanish intValue] == 0){
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
    if ([_countEnglish intValue] == 0){
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
    if ([_countFrench intValue] == 0){
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
    if ([_countPortuguese intValue] == 0){
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
    if ([_countMandarin intValue]== 0){
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
    if ([_countOther intValue] == 0){
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


- (IBAction)didChangeAge:(id)sender {
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
}
- (IBAction)didChangePrice:(id)sender {
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
    self.selectedPrice =  @(self.priceSlider.value);
}

- (IBAction)didChangeDistance:(id)sender {
    self.distanceAmount.text = [NSString stringWithFormat:@"%0.0f", self.distanceSlider.value];
}

@end
