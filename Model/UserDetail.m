//
//  UserDetail.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/18/22.
//

#import "UserDetail.h"
#import <Parse/PFObject+Subclass.h>

@implementation UserDetail

@dynamic userID;
@dynamic username;
@dynamic Image;
@dynamic Name;

+ (nonnull NSString *)parseClassName {
    return @"UserDetail";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    UserDetail *newProfile = [UserDetail new];
    newProfile.Image = [self getPFFileFromImage:image];
    [newProfile saveInBackgroundWithBlock: completion];
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
