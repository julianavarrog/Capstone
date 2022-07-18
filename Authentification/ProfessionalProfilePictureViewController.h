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

@property (weak, nonatomic) IBOutlet PFImageView *chosenProfilePicture;
- (IBAction)didChooseImage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *uploadPictureLabel;
- (IBAction)didSignUp:(id)sender;

@property (strong, nonatomic) NSString * objectToUpdatePicture;

@end

NS_ASSUME_NONNULL_END
