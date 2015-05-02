//
//  LoginScreenViewController.m
//  WS MySQL
//
//  Created by DroidFx on 4/27/15.
//  Copyright (c) 2015 DroidFx. All rights reserved.
//

#import "LoginScreenViewController.h"
#import "UIActivityIndicatorViewWithText.h"

@interface LoginScreenViewController ()


@end

@implementation LoginScreenViewController

@synthesize userTextField, passTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *paddingUser = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [userTextField setLeftView:paddingUser];
    [userTextField setLeftViewMode:UITextFieldViewModeAlways];
    
    UIView *paddingPass = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [passTextField setLeftView:paddingPass];
    [passTextField setLeftViewMode:UITextFieldViewModeAlways];
    
    userTextField.delegate = self;
    passTextField.delegate = self;
    
    [userTextField addTarget:self action:@selector(nextTexFieldFocus:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [passTextField addTarget:self action:@selector(textFieldDidReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginActionCall:(id)sender {
    
    [self loginByResponse];

}

- (void)loginByResponse
{
    NSInteger success = 0;
    @try {
        
        if ([[userTextField text] isEqualToString:@""] || [[passTextField text] isEqualToString:@""]) {
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
        }
        else {
            
            
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[userTextField text],[passTextField text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://127.0.0.1/ios_example/jsonlogin.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                success = [jsonData[@"success"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }
            
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.frame = CGRectMake((self.view.frame.size.width - 100) / 2, (self.view.frame.size.height - 100) / 2, 100, 100);
        spinner.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        spinner.layer.cornerRadius = 100 * 0.1;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [spinner stopAnimating];
            [self performSegueWithIdentifier:@"login_success" sender:self];
            
        });
        
    }
    
}



- (void)nextTexFieldFocus:(UITextField *)textField
{
    [passTextField becomeFirstResponder];
}

- (void)textFieldDidReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self loginByResponse];
}




@end
