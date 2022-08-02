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
    //https://venmo.com/account/sign-in
}

- (void)setEvent:(Event*)event with:(Professional*) professional {
    
    [self.profileName setText: [professional[@"Name"] capitalizedString]];
    self.profileCellImage.file = professional[@"Image"];
    self.profileCellImage.layer.cornerRadius = self.profileCellImage.frame.size.width/2;
    [self.profileCellImage loadInBackground];
    
}



@end
