//
//  MapView.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/28/22.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@interface MapPin : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;

@end

