//
//  SessionSummaryViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionSummaryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *switch1;
@property (weak, nonatomic) IBOutlet UISwitch *switch2;
@property (weak, nonatomic) IBOutlet UISwitch *switch3;
- (IBAction)switch1Action:(id)sender;
- (IBAction)switch2Action:(id)sender;
- (IBAction)switch3Action:(id)sender;

@end

NS_ASSUME_NONNULL_END
