//
//  SettingsViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsViewController : UIViewController
- (IBAction)logoutButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changePicture;
@property (weak, nonatomic) IBOutlet UIButton *changePassword;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

NS_ASSUME_NONNULL_END
