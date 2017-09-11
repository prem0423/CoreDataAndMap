//
//  MapViewController.m
//  CoreData
//
//  Created by Blaze Automation on 24/08/17.
//  Copyright © 2017 Blaze Automation. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize locationManager;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }

    [self CurrentLocationIdentifier]; // call this method
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            if ([CLLocationManager locationServicesEnabled]){
                
                NSLog(@"Location Services Enabled");
                
                if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                       message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                    [alert show];
                }
            }
        } break;
        case kCLAuthorizationStatusDenied: {
            
            NSLog(@"User denied location access request!!");
            // show text on label
            //            label.text = @"To re-enable, please go to Settings and turn on Location Service for this app.";
            
            //            [locationManager stopUpdatingLocation];
            //            [loadingView stopLoading];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            
            // clear text
            //            label.text = @"";
            //            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
    
    if (_delegate != nil) {
//        [_delegate locationManager:manager didChangeAuthorizationStatus:status];
    }
}
//------------ Current Location Address-----
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
//    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
//             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//             NSLog(@"Address: %@",Address);
//             NSLog(@"CountryArea: %@",CountryArea);
             
             NSLog(@"placemark.location: %@", placemark.location);
             
             NSString *latString = [[NSNumber numberWithFloat:currentLocation.coordinate.latitude] stringValue];
             NSString *lngString = [[NSNumber numberWithFloat:currentLocation.coordinate.longitude] stringValue];
             
             NSLog(@"latString: %@", latString);
             NSLog(@"lngString: %@", lngString);
             
             NSDictionary *locationInfo = @{
                                            kAccuracyKey : @"",
                                            kCourseKey : @"",
                                            kDateKey : [NSDate date],
                                            kLatitudeKey : latString,
                                            kLongitudeKey : lngString,
                                            kSpeedKey : @""
                                            };
             [CoreDataModel insertLocationDataWithInfo:locationInfo];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
//             CountryArea = NULL;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
-(void) showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message viewcontroller:(UIViewController*)viewController
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [viewController presentViewController:alert animated:YES completion:nil];
    
}

@end
