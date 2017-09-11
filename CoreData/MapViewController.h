//
//  MapViewController.h
//  CoreData
//
//  Created by Blaze Automation on 24/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@protocol BOLocationManagerDelegate <NSObject>
@end
@interface MapViewController : UIViewController <CLLocationManagerDelegate>
{
//    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (strong) CLLocationManager *locationManager;
@property (nonatomic,weak) id <BOLocationManagerDelegate> delegate;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
