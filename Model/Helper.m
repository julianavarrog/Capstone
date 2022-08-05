//
//  Helper.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/4/22.
//

#import <Foundation/Foundation.h>
#import "Helper.h"

@implementation Helper

+ (Helper *)sharedObject {
    static Helper *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}

- (id)init {
    if (self = [super init]) {
        self.currentUser = PFUser.currentUser;
        self.isUser = YES;
    }
    return self;
}

@end
