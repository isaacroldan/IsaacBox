//
//  LoginViewController.m
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


//OAuth2 using AFOAuth2Client, an extension of AFNetworking.
-(IBAction)login:(id)sender{
    
    [SVProgressHUD showWithStatus:@"Logging in..."];
    [self.view endEditing:YES];
    NSURL *url = [NSURL URLWithString:@"https://teambox.com/"];

    
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:kClientID secret:kClientSecret];
    [oauthClient authenticateUsingOAuthWithPath:@"/oauth/token"
                                       username:[self.username text]
                                       password:[self.password text]
                                          scope:@"read_projects write_projects offline_access"
                                        success:^(AFOAuthCredential *credential) {
                                            NSLog(@"I have a token! %@", credential.accessToken);
                                            [AFOAuthCredential storeCredential:credential withIdentifier:@"IsaacBox"];
                                            [SVProgressHUD showSuccessWithStatus:@"Ok!"];
                                            [self.delegate LoginViewControllerDidFinish:self];
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"Error: %@", error);
                                            [SVProgressHUD showErrorWithStatus:@"Error Logging in"];
                                        }];
    
}

@end
