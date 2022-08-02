//
//  SessionSummaryViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/27/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SessionSummaryViewController : UIViewController
//update Button
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
- (IBAction)updateLog:(id)sender;
//switch definitions
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskThree;
- (IBAction)switch1Action:(id)sender;
- (IBAction)switch2Action:(id)sender;
- (IBAction)switch3Action:(id)sender;
//task definitions
@property (weak, nonatomic) IBOutlet UITextField *taskOne;
@property (weak, nonatomic) IBOutlet UITextField *taskTwo;
@property (weak, nonatomic) IBOutlet UITextField *taskThree;
@property (weak, nonatomic) IBOutlet UITextView *reflectionBox;


@end

NS_ASSUME_NONNULL_END
