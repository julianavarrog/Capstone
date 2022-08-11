//
//  NotificationCell.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/14/22.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) void(^acceptButtonTapHandler)(void);
@property (nonatomic, copy) void(^cancelButtonTapHandler)(void);

-(void)setup:(Notification *) notification;
@end

NS_ASSUME_NONNULL_END
