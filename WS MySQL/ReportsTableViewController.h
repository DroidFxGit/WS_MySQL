//
//  ReportsTableViewController.h
//  WS MySQL
//
//  Created by DroidFx on 4/2/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface ReportsTableViewController : UITableViewController < UITableViewDataSource,
                                                                UITableViewDelegate,
                                                                HomeModelProtocol>

- (IBAction)performAdd:(id)sender;

@end
