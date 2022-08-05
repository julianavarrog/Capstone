
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
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property(nonatomic, getter=isPitchEnabled) BOOL pitchEnabled;
@property (strong, nonatomic) NSMutableArray *professionals;
@property (strong, nonatomic) NSMutableArray *professionalsFiltered;

@end

NS_ASSUME_NONNULL_END
