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

-(void)sendDataToA:(Filter *)filter;

@end

@interface FilterViewController : UIViewController

@property (weak, nonatomic) NSArray *specialityFilterArray;
@property (weak, nonatomic) NSArray *languageFilterArray;

@property (weak, nonatomic) IBOutlet UILabel *priceAmount;
@property (weak, nonatomic) IBOutlet UISlider *priceSlider;


@property (weak, nonatomic) IBOutlet UILabel *ageAmount;
@property (weak, nonatomic) IBOutlet UISlider *ageSlider;


@property (strong, nonatomic) NSMutableArray *professionals;
@property(nonatomic,assign)id delegate;

- (IBAction)didApplyFilters:(id)sender;

@end

NS_ASSUME_NONNULL_END
