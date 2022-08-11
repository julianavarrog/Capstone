//
//  MapCircle.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/1/22.
//

#import <Foundation/Foundation.h>
#import "MapCircle.h"
#import <Parse/PFUser.h>
#import <Parse/PFObject+Subclass.h>
#import <Parse/PFQuery.h>
#import "FilterViewController.h"

@implementation MapCircle

@synthesize coordinate;
@synthesize selectedDistance;

- (instancetype)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord radius:(CLLocationDistance)radius{
    if (self != nil) {
        coordinate = coord;
        selectedDistance = @(radius);
    }
    return self;
}
@end
