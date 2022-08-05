//
//  SessionSummaryViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/27/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SessionSummaryProtocol <NSObject>
-(void) dismissActivity;
@end

@interface SessionSummaryViewController : UIViewController
//update Button
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
- (IBAction)updateLog:(id)sender;
//switch definitions
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskOne;
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskTwo;
@property (weak, nonatomic) IBOutlet UISwitch *switchForTaskThree;

//task definitions
@property (weak, nonatomic) IBOutlet UITextField *taskOne;
@property (weak, nonatomic) IBOutlet UITextField *taskTwo;
@property (weak, nonatomic) IBOutlet UITextField *taskThree;
@property (weak, nonatomic) IBOutlet UITextView *reflectionBox;

@property (strong, nonatomic) PFObject * activity;
@property bool isUser;
@property(nonatomic,assign)id delegate;
@end

NS_ASSUME_NONNULL_END
