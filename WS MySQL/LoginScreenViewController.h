//
//  LoginScreenViewController.h
//  WS MySQL
//
//  Created by DroidFx on 4/27/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;

- (IBAction)loginActionCall:(id)sender;



@end
