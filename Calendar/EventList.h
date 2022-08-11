//
//  EventList.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Professional.h"
#import "Parse/PFImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventList : UITableViewCell

@property (strong, nonatomic) NSDateFormatter * eventFormatter;
@property (weak, nonatomic) IBOutlet PFImageView *profesionalImage;
@property (weak, nonatomic) IBOutlet UILabel *profesionalName;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UILabel *eventState;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;

- (void)setEvent:(Event*)event with:(Professional*) professional;

@end

NS_ASSUME_NONNULL_END
