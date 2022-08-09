//
//  FeedViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "Professional.h"
#import "UserDetail.h"


NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController


- (IBAction)feedNotificationButton:(id)sender;
- (IBAction)feedFilterButton:(id)sender;

@property (weak, nonatomic) UserDetail *userDetail;
@property (strong, nonatomic) Professional *profile;
@property (strong, nonatomic) NSMutableArray *professionals;


@end

NS_ASSUME_NONNULL_END


