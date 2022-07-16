//
//  LoginViewController2.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Could you avoid number in the name? Naming should be easy to understand. Instead of using LoginViewController2, we could just do LoginViewController.
 
@interface LoginViewController2 : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *loginLabel; 
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginButton:(id)sender;
- (IBAction)signupButton:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)googleSignUp:(id)sender;

@end

NS_ASSUME_NONNULL_END
