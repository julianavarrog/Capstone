//
//  Languages.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Language : NSObject

typedef NS_ENUM(NSUInteger, LanguageFilterType) {

    LanguageFilterTypeFrench = 0,
    LanguageFilterTypeSpanish = 1,
    LanguageFilterTypeEnglish = 2,
    LanguageFilterTypePortuguese = 3,
    LanguageFilterTypeMandarin = 4,
    LanguageFilterTypeOther = 5,
};

+ (NSString *) convertLabelFromLanguageType: (LanguageFilterType) type;

@end
NS_ASSUME_NONNULL_END
