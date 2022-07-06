//
//  Profile.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/3/22.
//

#import "Profile.h"
#import <Parse/PFObject+Subclass.h>


@implementation Profile

@dynamic userID;
//@dynamic author;
@dynamic Description;
@dynamic image;
@dynamic Name;

+ (nonnull NSString *)parseClassName {
    return @"Profile";
}

+ (void) postUserImage:( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Profile *newProfile = [Profile new];
    newProfile.image = [self getPFFileFromImage:image];
    //newProfile.author = [PFUser currentUser];
    // por que es caption y no description?
    //newProfile.description = caption;
    
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

