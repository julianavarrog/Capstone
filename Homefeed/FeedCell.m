//
//  FeedCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "FeedCell.h"
#import "Professional.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bookAppointmentButton.layer.cornerRadius = 20; // this value vary as per your desire
    self.bookAppointmentButton.clipsToBounds = YES;
}

// trying to fix the reusability of my PFImageView in the Homefeed.
/*
- (void) prepareForReuse{
    [super prepareForReuse];
}
*/

- (void)setProfile:(Professional *)profile {
    _profile = profile;
    // set image
    self.feedImage.file = profile[@"Image"];
    self.feedImage.layer.cornerRadius  = self.feedImage.frame.size.width/2;
    //set username
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:profile[@"username"]];
    self.feedUsername.text = screenName;
    //set name
    self.feedName.text = profile[@"Name"];
    //set description
    self.feedDescription.text = profile[@"Description"];
    [self.feedImage loadInBackground];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)feedBookAppointmentButton:(id)sender {
}

@end

