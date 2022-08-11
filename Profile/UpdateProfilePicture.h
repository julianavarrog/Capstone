//
//  UpdateProfilePicture.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateProfilePicture : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *ChosenImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *chosenProfilePicture;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

- (IBAction)didChooseImage:(id)sender;


@end

NS_ASSUME_NONNULL_END
