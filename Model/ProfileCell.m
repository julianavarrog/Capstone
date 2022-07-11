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
#import "Event.h"

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSession:(Event *)event {
    _event = event;
    // self.feedImage.file = profile[@"Image"];
    
    
    
    //self.
    
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
