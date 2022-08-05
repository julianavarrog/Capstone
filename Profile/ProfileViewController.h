//
//  ProfileViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "UserDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedProfile;
@property (strong, nonatomic) UserDetail *userDetail;

- (IBAction)didTapSettings:(id)sender;

@end

NS_ASSUME_NONNULL_END
