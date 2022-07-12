//
//  EventList.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventList : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profesionalImage;
@property (weak, nonatomic) IBOutlet UILabel *profesionalName;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;

- (void)setEvent:(Event*)event;

@end

NS_ASSUME_NONNULL_END
