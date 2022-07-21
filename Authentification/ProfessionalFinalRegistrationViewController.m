//
//  ProfessionalFinalRegistrationViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "ProfessionalFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "UserTypeViewController.h"
#import "NewFilterInfoViewController.h"


@interface ProfessionalFinalRegistrationViewController ()

@end

@implementation ProfessionalFinalRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void) registerProfessional{
    
    PFUser *newUser = [PFUser user];
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@" PFUser for professional registered successfully");
            PFObject *profesionals = [PFObject objectWithClassName:@"Professionals"];
            profesionals[@"userID" ] = newUser.objectId;
            profesionals[@"Name"] = self.nameField.text;
            profesionals[@"username"] = self.usernameField.text;
            profesionals[@"Description"] = self.descriptionField.text;
            [profesionals saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"Professional registered sucessfully");
                    [self performSegueWithIdentifier:@"filterInfoSegue" sender:newUser.objectId];
                }else{
                    NSLog(@"Professional registration failed");
                    [self displayMessageToUser:error.localizedDescription];
                }
            }];
        }
    }];
}

- (void)displayMessageToUser:(NSString*)message {
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
     UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
     popPresenter.sourceView = self.view;
     UIAlertAction *Okbutton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

     }];
     [alert addAction:Okbutton];
     popPresenter.sourceRect = self.view.frame;
     alert.modalPresentationStyle = UIModalPresentationPopover;
     [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"filterInfoSegue"]){
        NSString *objectId = (NSString *) sender;
        NewFilterInfoViewController * vc = [segue destinationViewController];
        vc.objectToUpdate = objectId;
    }
}

- (IBAction)signupButton:(id)sender {
    [self registerProfessional];
}
@end
