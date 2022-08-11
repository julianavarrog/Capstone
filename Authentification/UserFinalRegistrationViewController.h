//
//  finalRegistrationViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserFinalRegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) NSMutableArray * userLocation;

- (IBAction)signUpButton:(id)sender;

@end

NS_ASSUME_NONNULL_END
