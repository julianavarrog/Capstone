//  SessionSummaryViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/27/22.
//

#import "SessionSummaryViewController.h"
#import "Parse/Parse.h"

@interface SessionSummaryViewController ()
@property NSInteger *activityCount;

@end

@implementation SessionSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.updateButton.layer.cornerRadius = 20;
    self.updateButton.clipsToBounds = YES;
    
    self.reflectionBox.layer.cornerRadius = 20;
    self.reflectionBox.clipsToBounds = YES;
}

- (IBAction)switchThreeAction:(id)sender {
    if(self.switchForTaskOne.isOn){
        self.activityCount += 1;
    }else{
        self.activityCount -= 1;
    }
}

- (IBAction)switchTwoAction:(id)sender {
    if(self.switchForTaskTwo.isOn){
        self.activityCount += 1;
    }else{
        self.activityCount -= 1;
    }
}

- (IBAction)switchOneAction:(id)sender {
    if(self.switchForTaskThree.isOn){
        self.activityCount += 1;
    }else{
        self.activityCount -= 1;
    }
}

- (IBAction)updateLog:(id)sender {
    PFQuery *queryActivities = [PFQuery queryWithClassName:@"Activities"];
    //[query whereKey:@"eventId" equalTo:currentEvent];
    [queryActivities getFirstObjectInBackgroundWithBlock:^ (PFObject * activity, NSError *error) {
        //activity[@"count"] = @(@(self.activityCount).intValue);
        activity[@"Task1"] = self.taskOne.text;
        activity[@"Task2"] = self.taskTwo.text;
        activity[@"Task3"] = self.taskTwo.text;
        [activity save];
    }];
    
}
@end
