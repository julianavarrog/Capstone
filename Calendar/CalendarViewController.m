//
//  CalendarViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "Parse/Parse.h"
#import "FSCalendar.h"


@interface CalendarViewController()<FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarlist;

@property (strong, nonatomic) NSMutableArray *events;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    // Do any additional setup after loading the view.
}
- (IBAction)segmentedTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0){
        [self.calendar setHidden:false];
        [self.calendarlist setHidden:true];
    }else{
        [self.calendar setHidden:true];
        [self.calendarlist setHidden:false];
    }
}

- (void) fetchEvents{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable events, NSError * _Nullable error) {
        if (!error){
            NSLog(@"sucessfully retrived Event");
            self.events = [[NSMutableArray alloc]init];
            [self.events addObjectsFromArray:events];
        }else{
            NSLog(@"failed to retrived Event");
        }
    }];
        //[self.refreshControl endRefreshing];
}

@end

