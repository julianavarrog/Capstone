//
//  UserTypeViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTypeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *professionalButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
- (IBAction)didTapUser:(id)sender;
- (IBAction)didTapProfessional:(id)sender;

@end

NS_ASSUME_NONNULL_END
