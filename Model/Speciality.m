//
//  Speciality.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import "Speciality.h"

@implementation Speciality

+ (NSString *) convertLabelFromSpecialistType: (SpecialityFilterType) type{
    switch(type) {
        case SpecialityFilterTypeFamilyAndFriends:
            return @"Family & Friends";
        case SpecialityFilterTypeBehavioural:
            return @"Behavioural";
        case SpecialityFilterTypeChildTherapist:
            return @"Child Therapist";
        case SpecialityFilterTypeStressManagment:
            return @"Stress Managment";
        case SpecialityFilterTypeGeneral:
            return @"General";
        case SpecialityFilterTypeLifeCoaching:
            return @"Life Coaching";
            
        default:
            return @"Unknown";
    }
    return @"Unknown";
}

@end
