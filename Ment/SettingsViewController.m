//
//  SettingsViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"



@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logoutButton:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        if(error) {
            // Failure
        } else {
            // Success
            //UIApplication.sharedApplication.delegate.window.rootViewController
            
            SceneDelegate *scenceDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            scenceDelegate.window.rootViewController = loginViewController;
        }
   }];
}
@end
