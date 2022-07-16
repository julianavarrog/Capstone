//
//  Speciality.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 I would suggest you create an enum for speciality and languages in a helper file
 
 like this:
 
 typedef NS_ENUM(NSUInteger, SpecialityFilterType) {
   SpecialityFilterTypeUnknown = 0,
     SpecialityFilterTypeFamilyAndFriends,
     SpecialityFilterTypeBehavioural,
     SpecialityFilterTypeChildTherapist,
     ......
 };


 And we could create a convert function like
 
 (UILabel *) convertLabelFromSpecialistType: (SpecialityFilterType) type
 {
    switch (type)
        case SpecialityFilterTypeFamilyAndFriends:
                return @"familyandfriends";
        case ....
 }
 
 It could be helpful when we create a new speciality object.
 */


@interface Speciality : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *specialityButton;


@property (weak, nonatomic) IBOutlet UILabel *specialityLabel;

@end

NS_ASSUME_NONNULL_END
