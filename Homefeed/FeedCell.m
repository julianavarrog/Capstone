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

@synthesize containerView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bookAppointmentButton.layer.cornerRadius = 20;
    self.bookAppointmentButton.clipsToBounds = YES;
    [self setupContainerView];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.feedImage setFile: nil];
    [self.feedImage setImage: nil];
}

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

#pragma mark - Shadow container
-(void) setupContainerView {
    containerView.layer.cornerRadius = 15.0;
    containerView.layer.shadowRadius  = 3.0f;
    containerView.layer.shadowColor   = UIColor.grayColor.CGColor;
    containerView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    containerView.layer.shadowOpacity = 0.9f;
    containerView.layer.masksToBounds = NO;
}

@end

