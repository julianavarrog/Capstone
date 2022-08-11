//
//  ProfessionalProfilePictureViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "Professional.h"
#import "Parse/PFImageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProfessionalProfilePictureViewController : UIViewController

@property (strong, nonatomic) NSString * objectToUpdatePicture;
@property (weak, nonatomic) IBOutlet PFImageView *chosenProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)didChooseImage:(id)sender;
- (IBAction)didSignUp:(id)sender;


@end

NS_ASSUME_NONNULL_END
