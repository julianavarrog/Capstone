//
//  FilterViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "FilterViewController.h"
#import "Professional.h"
#import "Filter.h"
#import "Speciality.h"
#import "Language.h"


@interface FilterViewController ()
@property (strong, nonatomic) NSNumber *selectedPrice;
@end

@implementation FilterViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
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
    NSNumber * maxDistance = 0;
    for (Professional* professional in self.professionals) {
        NSNumber *distance = professional[@"distance"];
        if ([distance floatValue] > [maxDistance floatValue]) {
            maxDistance = professional[@"distance"];
        }
    }
    self.distanceSlider.maximumValue = maxDistance.floatValue;
    self.distanceSlider.value = maxDistance.floatValue;
    self.distanceAmount.text = [NSString stringWithFormat:@"%0.0f KM", (maxDistance.floatValue/1000.0)];
    
    self.applyFilters.layer.cornerRadius = 10;
    self.applyFilters.clipsToBounds = YES;

}

- (IBAction)didApplyFilters:(id)sender {
    Filter* filter = [[Filter alloc] init];
    filter.selectedPrice = @(self.priceSlider.value);
    filter.selectedAge = @(self.ageSlider.value);
    filter.selectedDistance = @(self.distanceSlider.value);
    filter.selectedSpeciality = self.specialityArray;
    filter.selectedLanguage = self.languageArray;
    
    [delegate sendDataToFilter:filter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Speciality
-(IBAction)tappedSpeciality:(id)sender
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

//Languages
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
