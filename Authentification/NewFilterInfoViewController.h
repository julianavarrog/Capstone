//
//  NewFilterInfoViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/13/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewFilterInfoViewController : UIViewController

- (IBAction)ageSliderAction:(id)sender;
- (IBAction)priceSliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UILabel *priceAmount;
@property (weak, nonatomic) IBOutlet UILabel *ageAmount;

@property (strong, nonatomic) NSMutableArray *specialityArray;
@property (strong, nonatomic) NSMutableArray *languageArray;

@property (strong, nonatomic) NSNumber * countFamily;
@property (strong, nonatomic) NSNumber * countBehavioural;
@property (strong, nonatomic) NSNumber * countChild;
@property (strong, nonatomic) NSNumber * countStress;
@property (strong, nonatomic) NSNumber * countGeneral;
@property (strong, nonatomic) NSNumber * countLife;

@property (strong, nonatomic) NSNumber * countSpanish;
@property (strong, nonatomic) NSNumber * countEnglish;
@property (strong, nonatomic) NSNumber * countFrench;
@property (strong, nonatomic) NSNumber * countPortuguese;
@property (strong, nonatomic) NSNumber * countMandarin;
@property (strong, nonatomic) NSNumber * countOther;

@property (weak, nonatomic) IBOutlet UIButton *familyButton;
@property (weak, nonatomic) IBOutlet UIButton *childButton;
@property (weak, nonatomic) IBOutlet UIButton *stressButton;
@property (weak, nonatomic) IBOutlet UIButton *generalButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeButton;
@property (weak, nonatomic) IBOutlet UIButton *behaviouralButton;

@property (weak, nonatomic) IBOutlet UIButton *spanishButton;
@property (weak, nonatomic) IBOutlet UIButton *englishButton;
@property (weak, nonatomic) IBOutlet UIButton *frenchButton;
@property (weak, nonatomic) IBOutlet UIButton *portugueseButton;
@property (weak, nonatomic) IBOutlet UIButton *mandarinButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (strong, nonatomic) NSString * objectToUpdate;

@property (strong, nonatomic) NSMutableArray * userLocation;


@end

NS_ASSUME_NONNULL_END
