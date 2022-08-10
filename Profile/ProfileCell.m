//
//  ProfileCellTableViewCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "ProfileCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileCell

@synthesize containerView;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelButton.layer.cornerRadius = 15;
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelButton.layer.borderWidth = 1;
    
    self.viewButton.layer.cornerRadius = 15;
    self.viewButton.clipsToBounds = YES;
    
    [self setupContainerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)venmoClicked:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"https://venmo.com/account/sign-in"];
    [[UIApplication sharedApplication] openURL: myURL];
    
}

- (void)setActivity:(PFObject*) activity with:(PFObject*) user {
    [self.profileName setText: [user[@"Name"] capitalizedString]];
    [self.profileCellDate setText: activity[@"dateEvent"]];
    NSString* countString = [NSString stringWithFormat:@"%@", activity[@"count"]];
    self.activityAmount.text = countString;
    self.activityProgressView.progress = [(NSNumber *)activity[@"count"] floatValue] / 3;
    self.profileCellImage.file = user[@"Image"];
    self.profileCellImage.layer.cornerRadius = self.profileCellImage.frame.size.width/2;
    [self.profileCellImage loadInBackground];
    [self.cancelButton setHidden: [(NSNumber *)activity[@"count"] intValue] == 3 ? YES : NO];
}

- (IBAction)viewButtonTapped:(id)sender {
    self.viewButtonTapHandler();
}

- (IBAction)cancelButtonTapped:(id)sender {
    self.cancelButtonTapHandler();
}

-(void) setupContainerView {
    containerView.layer.cornerRadius = 10.0;
    containerView.layer.shadowRadius  = 3.0f;
    containerView.layer.shadowColor   = UIColor.grayColor.CGColor;
    containerView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    containerView.layer.shadowOpacity = 0.9f;
    containerView.layer.masksToBounds = NO;
}

@end
