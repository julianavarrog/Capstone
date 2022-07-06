//
//  Profile.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/3/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Profile : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
//@property (nonatomic, strong) PFUser *author;

@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *Name;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;


@end

NS_ASSUME_NONNULL_END
