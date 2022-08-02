//
//  MapCircle.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/1/22.
//
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapCircle : MKShape<MKOverlay> {
    CLLocationCoordinate2D coordinate;
    NSNumber *selectedDistance;
}

+ (instancetype)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord
                                    radius:(CLLocationDistance)radius;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSNumber *selectedDistance;

@end

NS_ASSUME_NONNULL_END
