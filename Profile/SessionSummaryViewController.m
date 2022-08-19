//  SessionSummaryViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/27/22.
//

#import "SessionSummaryViewController.h"
#import "Parse/Parse.h"

@interface SessionSummaryViewController ()
@property NSInteger activityCount;

@end

@implementation SessionSummaryViewController

@synthesize delegate;
@synthesize activity;
@synthesize confettiAnimation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updateButton.layer.cornerRadius = 20;
    self.updateButton.clipsToBounds = YES;
    
    self.reflectionBox.layer.cornerRadius = 20;
    self.reflectionBox.clipsToBounds = YES;
    [self setupActivity];
}

- (void) setupActivity {
    self.taskOne.text = activity[@"Task1"];
    self.taskTwo.text = activity[@"Task2"];
    self.taskThree.text = activity[@"Task3"];
    
    [self.switchForTaskOne setOn: [activity[@"state1"] boolValue] ];
    [self.switchForTaskTwo setOn: [activity[@"state2"] boolValue] ];
    [self.switchForTaskThree setOn: [activity[@"state3"] boolValue] ];
    
    [self.reflectionBox setText: activity[@"reflection"]];
    
    if (!self.isUser) {
        [self.reflectionBox  setEditable: NO];
        self.switchForTaskOne.userInteractionEnabled = NO;
        self.switchForTaskTwo.userInteractionEnabled = NO;
        self.switchForTaskThree.userInteractionEnabled = NO;
        [self.updateButton setHidden: YES];
    }
}

- (IBAction)updateLog:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Activities"];
    [query whereKey:@"objectId" equalTo: self.activity.objectId];
    [query getFirstObjectInBackgroundWithBlock:^ (PFObject * activity, NSError *error) {
        activity[@"Task1"] = self.taskOne.text;
        activity[@"Task2"] = self.taskTwo.text;
        activity[@"Task3"] = self.taskThree.text;
        
        activity[@"state1"] = [NSNumber numberWithBool: self.switchForTaskOne.isOn];
        activity[@"state2"] = [NSNumber numberWithBool: self.switchForTaskTwo.isOn];
        activity[@"state3"] = [NSNumber numberWithBool: self.switchForTaskThree.isOn];
        
        self.activityCount = (self.switchForTaskOne.isOn ? 1 : 0) + (self.switchForTaskTwo.isOn ? 1 : 0) + (self.switchForTaskThree.isOn ? 1 : 0);
        
        activity[@"count"] = [NSNumber numberWithInteger: self.activityCount];
        activity[@"reflection"] = self.reflectionBox.text;
        
        [activity save];
        [self.delegate dismissActivity];
        [self dismissViewControllerAnimated: true completion: nil];
    }];
    
}
@end
