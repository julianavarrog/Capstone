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

@property (weak, nonatomic) NSMutableArray *specialityArray;
@property (weak, nonatomic) NSMutableArray *languageArray;

@property (strong, nonatomic) NSNumber * countFamily;
@property (strong, nonatomic) NSNumber * countBehavioural;
@property (strong, nonatomic) NSNumber * countChild;
@property (strong, nonatomic) NSNumber * countStress;
@property (strong, nonatomic) NSNumber * countGeneral;
@property (strong, nonatomic) NSNumber * countLife;

@property (weak, nonatomic) IBOutlet UIButton *familyButton;
@property (weak, nonatomic) IBOutlet UIButton *childButton;
@property (weak, nonatomic) IBOutlet UIButton *stressButton;
@property (weak, nonatomic) IBOutlet UIButton *generalButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeButton;
@property (weak, nonatomic) IBOutlet UIButton *behaviouralButton;





@end

NS_ASSUME_NONNULL_END
