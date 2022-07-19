//
//  MapViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/18/22.
//

#import <Parse/Parse.h>
#import "MapKit/MapKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property(nonatomic, readonly) MKUserLocation *userLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

NS_ASSUME_NONNULL_END
