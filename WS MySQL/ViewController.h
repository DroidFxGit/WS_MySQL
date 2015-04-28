//
//  ViewController.h
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *nameDetail;
@property (strong, nonatomic) IBOutlet UILabel *addressDetail;
@property (strong, nonatomic) IBOutlet MKMapView *locationDetail;

@property (strong, nonatomic) Location *selectedLocation;

@end

