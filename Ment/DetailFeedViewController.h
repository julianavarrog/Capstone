//
//  DetailFeedViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "Professional.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailFeedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *detailUsername;
@property (weak, nonatomic) IBOutlet UILabel *detailSpeciality;
@property (weak, nonatomic) IBOutlet UILabel *detailDescription;
@property (weak, nonatomic) IBOutlet UILabel *detailLanguage;
@property (weak, nonatomic) IBOutlet PFImageView *detailImage;

@property (strong, nonatomic) Professional *professional;

@end

NS_ASSUME_NONNULL_END
