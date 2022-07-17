//
//  Filter.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/16/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Filter: NSObject

@property (nonatomic, strong) NSNumber* selectedPrice;
@property (nonatomic, strong) NSNumber* selectedAge;
@property (nonatomic, strong) NSArray * selectedSpeciality;
@property (nonatomic, strong) NSArray * selectedLanguage;

- (void) setSelectedPrice:(NSNumber * _Nonnull)selectedPrice;
- (void) setSelectedAge:(NSNumber * _Nonnull)selectedAge;
- (void) setSpeciality:(NSString * _Nonnull)speciality;
- (void) setLanguage:(NSString * _Nonnull)language;

@end

NS_ASSUME_NONNULL_END
