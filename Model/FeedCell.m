//
//  FeedCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "FeedCell.h"
#import "Profile.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setProfile:(Profile *)profile {
    _profile = profile;
    
    self.feedImage.file = profile[@"Image"];
    self.feedImage.layer.cornerRadius  = self.feedImage.frame.size.width/2;
    
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:profile[@"username"]];
    self.feedUsername.text = screenName;
    
    self.feedName.text = profile[@"Name"];
    
    self.feedDescription.text = profile[@"Description"];
    [self.feedImage loadInBackground];
    
    /*
    PFUser *user = [PFUser currentUser];
    user[@"profilePic"] = self.feedProfilePicture.file;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
     */
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)feedBookAppointmentButton:(id)sender {
}
@end
