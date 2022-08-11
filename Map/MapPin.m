//
//  MapView.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/28/22.
//

#import <Foundation/Foundation.h>
#import "MapPin.h"

@implementation MapPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    return self;
}

@end
