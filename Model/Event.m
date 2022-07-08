//
//  Event.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/7/22.
//

#import "Event.h"
#import "Parse/PFObject+Subclass.h"

@implementation Event

@dynamic userID;
@dynamic profesionalID;
@dynamic title;
@dynamic date;

+ (nonnull NSString *)parseClassName{
    return @"Event";
}

@end
