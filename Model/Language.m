//
//  Languages.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@implementation Language
+ (NSString *) convertLabelFromLanguageType: (LanguageFilterType) type{
    switch(type) {
        case LanguageFilterTypeFrench:
            return @"French";
        case LanguageFilterTypeSpanish:
            return @"Spanish";
        case LanguageFilterTypeEnglish:
            return @"English";
        case LanguageFilterTypePortuguese:
            return @"Portuguese";
        case LanguageFilterTypeMandarin:
            return @"Mandarin";
        case LanguageFilterTypeOther:
            return @"Other";
            
        default:
            return @"Unknown";
    }
    return @"Unknown";
}

@end
