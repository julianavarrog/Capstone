//
//  OpenViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenViewController : UIViewController
- (IBAction)didTapStart:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *animationView;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@end

NS_ASSUME_NONNULL_END
