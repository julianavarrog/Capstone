//
//  LoginViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import <UIKit/UIKit.h>
#import "AuthenticationServices/AuthenticationServices.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController
<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, UIWindowSceneDelegate>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UITextField * appleIDLoginInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *appleButton;

- (IBAction)loginButton:(id)sender;
- (IBAction)signupButton:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end

NS_ASSUME_NONNULL_END
