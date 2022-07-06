//
//  ProfessionalFinalRegistrationViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "ProfessionalFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "userTypeViewController.h"


@interface ProfessionalFinalRegistrationViewController ()

@end

@implementation ProfessionalFinalRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void) registerProfessional{
    PFObject *parseObject = [PFObject objectWithClassName:@"Professionals"];
    parseObject[@"Name"] = self.nameField.text;
    parseObject[@"Description"] = self.descriptionField.text;
    parseObject[@"username"] = self.usernameField.text;
    parseObject[@"password"] = self.passwordField.text;

    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"uploadPictureSegue" sender:nil];
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

- (IBAction)signupButton:(id)sender {
    [self registerProfessional];
}
@end
