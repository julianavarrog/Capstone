//
//  LoginViewController2.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "LoginViewController2.h"
#import "Parse/Parse.h"
#import "AuthenticationServices/AuthenticationServices.h"

@interface LoginViewController2 ()

@end

@implementation LoginViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.dataSource = self;
    //self.delegate = self;
    // Do any additional setup after loading the view.
}


- (void) loginUser{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"firstSegue" sender:nil];
        }
    }];
}

- (IBAction)googleSignUp:(id)sender {
}

- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)signupButton:(id)sender {
    // NSString *username = self.usernameField.text;
    // NSString *password = self.passwordField.text;
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
    
    //After we sign up, I feel we don't need the navigation bar anymore. Is it possible to 

}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}
@end

