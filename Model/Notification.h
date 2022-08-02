//
//  Notification.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/2/22.
//

#import <Parse/Parse.h>
#import "Parse/PFObject+Subclass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Notification : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic) Boolean isRead;
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) NSString *extraArgument;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;


@end

NS_ASSUME_NONNULL_END
