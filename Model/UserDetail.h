//
//  UserDetail.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/18/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDetail : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFFileObject *Image;
@property (nonatomic, strong) NSString *Name;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
