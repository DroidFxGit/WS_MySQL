//
//  ViewController.m
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //asign values to labels
    self.nameDetail.text = self.selectedLocation.name;
    self.addressDetail.text = self.selectedLocation.address;
    
    self.locationDetail.frame = CGRectMake(0.0f, 212.0f, self.view.frame.size.width, 380.0f);
    NSLog(@"width frame: %f", self.view.frame.size.width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated
{
    
    
    // Create coordinates from location lat/long
    CLLocationCoordinate2D poiCoodinates;
    poiCoodinates.latitude = [self.selectedLocation.latitude doubleValue];
    poiCoodinates.longitude= [self.selectedLocation.longitude doubleValue];
    
    // Zoom to region
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(poiCoodinates, 750, 750);
    
    [self.locationDetail setRegion:viewRegion animated:YES];
    
    // Plot pin
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = poiCoodinates;
    [self.locationDetail addAnnotation:pin];
}

@end
