//
//  NewReportViewController.m
//  WS MySQL
//
//  Created by DroidFx on 4/4/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "NewReportViewController.h"
#import <CoreLocation/CoreLocation.h>

#define allTrim(object) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface NewReportViewController ()

@property CLLocationManager *locationManager;
@property CLLocation *location;

@property NSArray *dataLocation;
@property NSData *json;

@end

@implementation NewReportViewController

@synthesize locationManager, location;
@synthesize dataLocation;
@synthesize json;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    //[locationManager stopUpdatingLocation];
    
    location = [locationManager location];
    
    //set obtained coordinates in an NSArray
    dataLocation = [self getLocationWithData:location];
    
    //dem[locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        //TODO: animation
    }];
}

- (IBAction)sendAction:(id)sender {

    if (([allTrim(self.nameField.text) length] == 0)   ||
        ([allTrim(self.surnameField.text) length] == 0) ||
        ([allTrim(self.addressField.text) length] == 0))
          [self ShowAlerViewWithMessage:@"Error"
                                Message:@"Por favor complete los campos necesarios"];
    
    else
    {
        //TODO:Implementar Metodo POST
        [self showActivityIndicatorWhileLoading];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //code to be executed on the main queue after delay
            [self PostValues];
        });
        
        //[self PostValues];
        //[self stopLoadingIndicator];
    }
    
    
}

- (void)ShowAlerViewWithMessage:(NSString *)titleMessage Message:(NSString *)stringMessage {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleMessage message:stringMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
}


# pragma mark - PostValues implementation

- (void)PostValues {
    
    //build up the request that is to be sent to the server
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
                                        [NSURL URLWithString:@"http://127.0.0.1/ios_example/post_service_alter.php"]];
    
    [request setHTTPMethod:@"POST"];
    //[request addValue:@"postValues" forHTTPHeaderField:@"METHOD"];
    
    NSString *name = self.nameField.text;
    NSString *surname = self.surnameField.text;
    NSString *address = self.addressField.text;
    NSString *dateTime = [self getDateTime];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSString stringWithFormat:@"%@ %@", name, surname] forKey:@"name"];
    [dictionary setValue:[NSString stringWithFormat:@"%@", address] forKey:@"address"];
    [dictionary setValue:[dataLocation objectAtIndex:0] forKey:@"latitude"];
    [dictionary setValue:[dataLocation objectAtIndex:1] forKey:@"longitude"];
    [dictionary setValue:[NSString stringWithFormat:@"%@", dateTime] forKey:@"datetime"];
    
    
    if([NSJSONSerialization isValidJSONObject:dictionary])
    {
        NSError *error = nil;
        NSData *result = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
        if (error == nil && result != nil) {
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", [result length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody: result];
            
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"RESULT: %@", resultData);
            
            if (error){
                [self ShowAlerViewWithMessage:@"Fallo la conexión" Message:@"Por favor vuelva a intentarlo"];
            }
            else {
                [self ShowAlerViewWithMessage:@"Listo!!" Message:@"Su reporte ha sido enviado, en breve recibirá respuesta"];
                [locationManager stopUpdatingLocation];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    }
    
    [self stopLoadingIndicator];
    
    
}


# pragma mark - getData for Post

- (NSString *) getDateTime {
    
    NSDate *dateNow = self.datetimePicker.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [dateFormat stringFromDate:dateNow];
    
    return dateTime;
}


- (NSArray *) getLocationWithData:(CLLocation *)locationInfo {
    
    NSNumber *latitude = [NSNumber numberWithDouble:locationInfo.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:locationInfo.coordinate.longitude];
    
    NSArray *coordinates = [NSArray arrayWithObjects:[latitude stringValue], [longitude stringValue], nil];
    
    return coordinates;
}


- (void) showActivityIndicatorWhileLoading {
    
    if(!_loadingIndicator)
    {
        CGFloat width = self.view.bounds.size.width * 0.4;
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-width)/2, (self.view.bounds.size.height-width)/2, width , width)];
        _loadingIndicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _loadingIndicator.layer.cornerRadius = width * 0.1;
        
        CGFloat labelX = (_loadingIndicator.bounds.size.width / 4);
        CGFloat labelY = (_loadingIndicator.bounds.size.height - 40.f);
        CGFloat labelWidth = _loadingIndicator.bounds.size.width;
        CGFloat labelHeight = (_loadingIndicator.bounds.size.height / 4);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:12.0f];
        label.numberOfLines = 1;
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = @"Enviando...";
        
        [_loadingIndicator addSubview:label];
        
    }
    
    [self startLoadingIndicator];
}


-(void)startLoadingIndicator
{
    if(!_loadingIndicator.superview)
    {
        [self.view addSubview:_loadingIndicator];
    }
    [_loadingIndicator startAnimating];
}
-(void)stopLoadingIndicator
{
    if(_loadingIndicator.superview)
    {
        [_loadingIndicator removeFromSuperview];
    }
    [_loadingIndicator stopAnimating];
}




@end









