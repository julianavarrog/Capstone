//
//  Professional.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/16/22.
//

#import "Professional.h"
#import <Parse/PFObject+Subclass.h>

@implementation Professional

@dynamic userID;
@dynamic username;
@dynamic Description;
@dynamic image;
@dynamic Name;
@dynamic price;

+ (nonnull NSString *)parseClassName {
    return @"Professional";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Professional *newProfile = [Professional new];
    newProfile.image = [self getPFFileFromImage:image];
    
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

