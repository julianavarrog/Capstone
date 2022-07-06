//
//  FeedCell.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "Profile.h"


NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *feedUsername;
@property (weak, nonatomic) IBOutlet UILabel *feedDescription;
@property (weak, nonatomic) IBOutlet UILabel *feedName;
@property (weak, nonatomic) IBOutlet PFImageView *feedImage;
@property (strong, nonatomic) Profile *profile;

- (IBAction)feedBookAppointmentButton:(id)sender;


@end

NS_ASSUME_NONNULL_END
