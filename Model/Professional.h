//
//  Professional.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/16/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Professional : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSNumber *Price;
@property (nonatomic, strong) NSNumber *Age;
@property (nonatomic, strong) NSArray *Speciality;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END

