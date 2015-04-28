//
//  HomeModel.h
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeModelProtocol <NSObject>

- (void) itemsDownloaded:(NSArray *)items;

@end


@interface HomeModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<HomeModelProtocol> delegate;

- (void)downloadItems;

@end
