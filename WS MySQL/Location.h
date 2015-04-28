//
//  Location.h
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *dateTime;

@end
