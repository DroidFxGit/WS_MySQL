//
//  HomeModel.m
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "HomeModel.h"
#import "Location.h"

@interface HomeModel ()
{
    NSMutableData *_downloadedData;
}
@end

@implementation HomeModel

- (void)downloadItems {
    
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://127.0.0.1/ios_example/response_service.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
}


#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // Append the newly downloaded data
    [_downloadedData appendData:data];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Create an array to store the locations
    NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    
    for (int i = 0; i<jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        // Create a new location object and set its props to JsonElement properties
        Location *newLocation = [[Location alloc] init];
        newLocation.name = jsonElement[@"name"];
        newLocation.address = jsonElement[@"address"];
        newLocation.latitude = jsonElement[@"latitude"];
        newLocation.longitude = jsonElement[@"longitude"];
        newLocation.dateTime = jsonElement[@"datetime"];
        
        // Add this question to the locations array
        [_locations addObject:newLocation];
        
    }
    
    if (jsonArray.count == 0) {
        NSLog(@"No Data available...");
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_locations];
    }
}


@end
