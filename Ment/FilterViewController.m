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
}

- (void)setup {
    NSNumber * maxPrice = 0;
    for (Professional* professional in self.professionals) {
        if (professional[@"price"] > maxPrice) {
            maxPrice = professional[@"price"];
        }
    }
    self.priceSlider.maximumValue = maxPrice.floatValue;
    self.priceSlider.value = maxPrice.floatValue;
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
}

- (IBAction)didApplyFilters:(id)sender {
    Filter* filter = [[Filter alloc] init];
    filter.selectedPrice = @(self.priceSlider.value);
    [delegate sendDataToA: filter];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didChangeAge:(id)sender {
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
}
- (IBAction)didChangePrice:(id)sender {
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
    self.selectedPrice =  @(self.priceSlider.value);
}

@end
