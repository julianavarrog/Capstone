//
//  Speciality.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Speciality : NSObject

typedef NS_ENUM(NSUInteger, SpecialityFilterType) {
    SpecialityFilterTypeFamilyAndFriends = 0,
    SpecialityFilterTypeBehavioural = 1,
    SpecialityFilterTypeLifeCoaching = 2,
    SpecialityFilterTypeStressManagment = 3,
    SpecialityFilterTypeChildTherapist = 4,
    SpecialityFilterTypeGeneral = 5,
    
};

+ (NSString *) convertLabelFromSpecialistType: (SpecialityFilterType) type;

@end
NS_ASSUME_NONNULL_END
