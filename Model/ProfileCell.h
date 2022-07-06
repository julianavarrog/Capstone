//
//  ProfileCellTableViewCell.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "Parse/PFImageView.h"
#import "Profile.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileCell: UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *profileCellImage;
@property (strong, nonatomic) Profile *profile;
@property (weak, nonatomic) IBOutlet UILabel *profileDescription;
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@end

NS_ASSUME_NONNULL_END
