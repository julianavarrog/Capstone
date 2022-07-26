//
//  Speciality.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Speciality : NSObject
@property (weak, nonatomic) IBOutlet UIButton *specialityButton;
@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;
@property (nonatomic, assign) BOOL isSelected;

/*
@property (strong, nonatomic) BOOL * countFamily;
@property (strong, nonatomic) BOOL * countBehavioural;
@property (strong, nonatomic) BOOL * countChild;
@property (strong, nonatomic) BOOL * countStress;
@property (strong, nonatomic) BOOL * countGeneral;
@property (strong, nonatomic) BOOL * countLife;

@property (strong, nonatomic) BOOL * countSpanish;
@property (strong, nonatomic) BOOL * countEnglish;
@property (strong, nonatomic) BOOL * countFrench;
@property (strong, nonatomic) BOOL * countPortuguese;
@property (strong, nonatomic) BOOL * countMandarin;
@property (strong, nonatomic) BOOL * countOther;
*/

typedef NS_ENUM(NSUInteger, SpecialityFilterType) {
    // SpecialityFilterTypeUnknown = 0,
     SpecialityFilterTypeFamilyAndFriends,
     SpecialityFilterTypeBehavioural,
     SpecialityFilterTypeChildTherapist,
     SpecialityFilterTypeStressManagment,
     SpecialityFilterTypeGeneral,
     SpecialityFilterTypeLifeCoaching
 };

+ (NSString *) convertLabelFromSpecialistType: (SpecialityFilterType) type;

@end
NS_ASSUME_NONNULL_END
