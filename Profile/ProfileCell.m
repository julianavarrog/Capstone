//
//  ProfileCellTableViewCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "ProfileCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.cancelButton.layer.cornerRadius = 15;
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelButton.layer.borderWidth = 1;
    
    self.viewButton.layer.cornerRadius = 15;
    self.viewButton.clipsToBounds = YES;
}

- (IBAction)venmoClicked:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"https://venmo.com/account/sign-in"];
    
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

@end
