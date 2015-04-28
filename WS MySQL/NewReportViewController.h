//
//  NewReportViewController.h
//  WS MySQL
//
//  Created by DroidFx on 4/4/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface NewReportViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *surnameField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UIDatePicker *datetimePicker;

@property(nonatomic,readonly) UIActivityIndicatorView *loadingIndicator;

#pragma mark events

- (IBAction)cancelAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end
