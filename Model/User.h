//
//  User.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/8/22.
//

#import <Parse/Parse.h>
#import "PFUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser

@property (strong, nonatomic) PFFileObject *profilePic;

@end

NS_ASSUME_NONNULL_END
