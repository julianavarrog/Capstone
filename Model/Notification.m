//
//  Notification.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/2/22.
//

#import "Notification.h"
#import "Parse/PFObject+Subclass.h"

@implementation Notification

@dynamic userID;
@dynamic isRead;
@dynamic typeID;
@dynamic extraArgument;
@dynamic title;
@dynamic description;

+ (nonnull NSString *)parseClassName{
    return @"Notification";
}

@end
