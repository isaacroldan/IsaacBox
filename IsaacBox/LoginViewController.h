//
//  LoginViewController.h
//  IsaacBox
//
//  Created by Isaac Roldan Armengol on 29/06/13.
//  Copyright (c) 2013 cowders. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@protocol LoginViewControllerDelegate
- (void)LoginViewControllerDidFinish:(LoginViewController *)controller;
@end


@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property(weak, nonatomic)  id <LoginViewControllerDelegate> delegate;
@property(nonatomic,strong) IBOutlet UITextField *username;
@property(nonatomic,strong) IBOutlet UITextField *password;
@end
