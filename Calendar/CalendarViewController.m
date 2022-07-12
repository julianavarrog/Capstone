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
#import "Event.h"
#import "EventList.h"


@interface CalendarViewController()<FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarlist;
@property (strong, nonatomic) NSDateFormatter * dateFormatter1;
@property (strong, nonatomic) NSMutableDictionary *orderEvents;
@property (strong, nonatomic) NSArray *distinctEvents;

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;



@property (strong, nonatomic) NSMutableArray *events;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
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
            
            for (Event * event in self.events){
                event.dateString = [self.dateFormatter1 stringFromDate: event.date];
            }
            
            self.orderEvents = [NSMutableDictionary new];
            self.distinctEvents = [self.events valueForKeyPath:@"@distinctUnionOfObjects.dateString"];
            for (NSString *date in self.distinctEvents){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dateString =%@", date];
                NSArray *events = [self.events filteredArrayUsingPredicate:predicate];
                [self.orderEvents setObject:events forKey:date];
            }
            NSLog(@"%@", self.orderEvents);
            [self.calendar reloadData];
            [self.eventsTableView reloadData];
        }else{
            NSLog(@"failed to retrived Event");
        }
    }];
        //[self.refreshControl endRefreshing];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    if ([self.distinctEvents containsObject:[self.dateFormatter1 stringFromDate:date]]){
        NSArray * events = [self.orderEvents objectForKey:[self.dateFormatter1 stringFromDate:date]];
        return events.count;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *keys = [self.orderEvents allKeys];
    NSString *date = (NSString *)[keys objectAtIndex:section];
    return date;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EventList * cell = [tableView dequeueReusableCellWithIdentifier:@"EventListCell" forIndexPath:indexPath];
    NSArray *keys = [self.orderEvents allKeys];
    id aKey = [keys objectAtIndex:indexPath.section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aKey];
    Event * event = [events objectAtIndex:indexPath.row];
    [cell setEvent: event];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderEvents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [self.orderEvents allKeys];
    id aKey = [keys objectAtIndex:section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aKey];
    return events.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 160;
}

@end

