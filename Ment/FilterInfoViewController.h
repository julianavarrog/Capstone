//
//  FilterInfoViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// had initalized it as UIViewController. Which one is it? UIViewController or UICollectionViewController
@interface FilterInfoViewController : UIViewController 


@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *priceAmount;


@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageAmount;



- (IBAction)sliderPriceAction:(id)sender;
- (IBAction)sliderAgeAction:(id)sender;

- (IBAction)didTapSpeciality:(id)sender;
- (IBAction)didTapLanguage:(id)sender;

@end

NS_ASSUME_NONNULL_END
