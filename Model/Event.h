//
//  Event.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/7/22.
//

#import <Parse/Parse.h>
#import "Parse/PFObject+Subclass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *professionalID;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *dateString;


@end

NS_ASSUME_NONNULL_END
