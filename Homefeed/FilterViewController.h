//
//  FilterViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol senddataProtocol <NSObject>

-(void)sendDataToFilter:(Filter *)filter;

@end

@interface FilterViewController : UIViewController

@property (weak, nonatomic) NSArray *specialityFilterArray;
@property (weak, nonatomic) NSArray *languageFilterArray;
@property (weak, nonatomic) IBOutlet UILabel *priceAmount;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;
@property (weak, nonatomic) IBOutlet UILabel *ageAmount;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceAmount;
@property (strong, nonatomic) NSMutableArray *professionals;
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UIButton *applyFilters;
@property (strong, nonatomic) NSMutableArray *specialityArray;
@property (strong, nonatomic) NSMutableArray *languageArray;
//specialities
@property (weak, nonatomic) IBOutlet UIButton *familyButton;
@property (weak, nonatomic) IBOutlet UIButton *childButton;
@property (weak, nonatomic) IBOutlet UIButton *stressButton;
@property (weak, nonatomic) IBOutlet UIButton *generalButton;
@property (weak, nonatomic) IBOutlet UIButton *lifeButton;
@property (weak, nonatomic) IBOutlet UIButton *behaviouralButton;
//languages
@property (weak, nonatomic) IBOutlet UIButton *spanishButton;
@property (weak, nonatomic) IBOutlet UIButton *englishButton;
@property (weak, nonatomic) IBOutlet UIButton *frenchButton;
@property (weak, nonatomic) IBOutlet UIButton *portugueseButton;
@property (weak, nonatomic) IBOutlet UIButton *mandarinButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;


- (IBAction)didApplyFilters:(id)sender;


@end

NS_ASSUME_NONNULL_END
