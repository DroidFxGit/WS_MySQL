//
//  LoginScreenViewController.h
//  WS MySQL
//
//  Created by DroidFx on 4/27/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginScreenViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;

@property (strong, nonatomic) UIActivityIndicatorView *loadingIndicator;


- (IBAction)loginActionCall:(id)sender;



@end
