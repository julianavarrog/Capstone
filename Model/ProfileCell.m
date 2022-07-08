//
//  ProfileCellTableViewCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "ProfileCell.h"
#import "Profile.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProfile:(Profile *)profile {
    _profile = profile;
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:profile[@"username"]];
    self.profileUsername.text = screenName;
    //self.
    
    
    self.profileCellImage.file = profile[@"image"];
    self.profileCellImage.layer.cornerRadius  = self.profileCellImage.frame.size.width/2;
    self.profileDescription.text = profile.description;
    [self.profileCellImage loadInBackground];
    
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

@end
