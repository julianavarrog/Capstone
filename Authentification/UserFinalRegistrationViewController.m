//
//  finalRegistrationViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "UserFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "userTypeViewController.h"

@interface UserFinalRegistrationViewController ()
@property (strong, nonatomic) NSString *type;

@end

@implementation UserFinalRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void) registerUser{
    // initialize a user object
    PFUser *newUser = [PFUser user];
    //set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    //newUser.name = self.passwordField.text;
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"secondSegue" sender:nil];
            NSLog(@"Segue called");
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signUpButton:(id)sender {
    [self registerUser];
}
    
@end
