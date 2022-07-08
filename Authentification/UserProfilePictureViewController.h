//
//  UserProfilePictureViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFImageView.h"
#import "Profile.h"
#import "Parse/PFImageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserProfilePictureViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *chosenProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *uploadPictureLabel;
- (IBAction)didTapUploadButton:(id)sender;
- (IBAction)didSignup:(id)sender;


@end

NS_ASSUME_NONNULL_END
