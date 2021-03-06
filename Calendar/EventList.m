//
//  EventList.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import "EventList.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

- (void)setEvent:(Event*)event with:(Professional*) professional {
    
    [self.profesionalName setText: [professional[@"Name"] capitalizedString]];
    [self.eventState setText: [event[@"state"] capitalizedString]];
    
    self.profesionalImage.file = professional[@"Image"];
    self.profesionalImage.layer.cornerRadius = self.profesionalImage.frame.size.width/2;
    [self.profesionalImage loadInBackground];
    
}

@end
