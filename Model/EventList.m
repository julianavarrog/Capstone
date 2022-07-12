//
//  EventList.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import "EventList.h"

@implementation EventList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEvent:(Event*)event{
    [self.profesionalName setText: event.title];
}

@end
