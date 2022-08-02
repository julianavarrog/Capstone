//
//  NotificationCell.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/14/22.
//

#import "NotificationCell.h"
#import "Notification.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cancelButton.layer.cornerRadius = 15;
    self.cancelButton.clipsToBounds = YES;
    
    self.acceptButton.layer.cornerRadius = 15;
    self.acceptButton.clipsToBounds = YES;
}

- (void)setup:(Notification *) notification {
    self.titleLabel.text = notification[@"title"];
    self.descriptionLabel.text = notification[@"description"];
}

- (IBAction)acceptButtonTapped:(UIButton *)sender {
    self.acceptButtonTapHandler();
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    self.cancelButtonTapHandler();
}


@end

