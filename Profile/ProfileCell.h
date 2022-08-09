
//  ProfileCellTableViewCell.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Professional.h"
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell: UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profileCellImage;
@property (weak, nonatomic) IBOutlet UILabel *profileCellDate;
@property (strong, nonatomic) Professional *profile;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet UIProgressView *activityProgressView;
@property (weak, nonatomic) IBOutlet UILabel *activityAmount;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property(nonatomic, readonly, strong) UISceneOpenURLOptions *options;

- (void)setActivity:(PFObject*) activity with:(PFObject*) user;
@property (nonatomic, copy) void(^viewButtonTapHandler)(void);
@property (nonatomic, copy) void(^cancelButtonTapHandler)(void);

@end

NS_ASSUME_NONNULL_END
