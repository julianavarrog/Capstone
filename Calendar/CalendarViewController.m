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
#import "Professional.h"
#import "DetailFeedViewController.h"
#import "EventKit/EventKit.h"


@interface CalendarViewController()<FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calendarlist;
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
@property (strong, nonatomic) NSDateFormatter * timeFormatter;


// A mutable dictionary ordered by the events in the same date.
// It will take this format [["2022/07/18": [Event1, Event2]]]
// Dates can be accessed as keys and events as values.
@property (strong, nonatomic) NSMutableDictionary *orderEvents;

// All the events for that particular professional or user
@property (strong, nonatomic) NSArray *distinctEvents;

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;

@property (strong, nonatomic) NSMutableArray *events;

@property (strong, nonatomic) NSMutableArray *professionals;

@property (strong, nonatomic) NSMutableArray *calendarEvents;
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;



@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProfesionals];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    

    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.timeFormatter.dateFormat = @"MMM d";
    
    self.minimumDate = [self.dateFormatter dateFromString:@"2022/01/01"];
    self.maximumDate = [self.dateFormatter dateFromString:@"2024/01/01"];
    
    [self loadCalendarEvents];

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

// will load professional data again
- (void) viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchProfesionals];
}


//The predicate will add to selectProfessioals Array if True (in this case if they are professionals)
// depending on the result it will query a Professional's or User's Events.
- (void) fetchEvents{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID =%@", PFUser.currentUser.objectId];
    NSArray *selectProfessional = [self.professionals filteredArrayUsingPredicate:predicate];
    if([self.professionals containsObject: selectProfessional.firstObject]){
        [query whereKey:@"professionalID" equalTo:PFUser.currentUser.objectId];
    }else{
        [query whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable events, NSError * _Nullable error) {
        if (!error){
            NSLog(@"sucessfully retrived Event");
            self.events = [[NSMutableArray alloc]init];
            [self.events addObjectsFromArray:events];
            
            for (Event * event in self.events){
                event.dateString = [self.dateFormatter stringFromDate: event.date];
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
}

- (void) fetchProfesionals{
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable professionals, NSError * _Nullable error) {
        if (!error){
            NSLog(@"sucessfully retrived Event");
            self.professionals = [[NSMutableArray alloc]init];
            [self.professionals addObjectsFromArray:professionals];
            
            [self fetchEvents];
        }else{
            NSLog(@"failed to retrived Event");
        }
    }];
}

//adding to Apple Events
- (void) loadCalendarEvents{
    __weak typeof(self) weakSelf = self;
    EKEventStore * store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted){
            NSDate *startDate = self.minimumDate;
            NSDate *endDate = self.maximumDate;
            NSPredicate *fechCalendarEvents = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray<EKEvent*> *eventList = [store eventsMatchingPredicate:fechCalendarEvents];
            NSArray<EKEvent*> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                return event.calendar.type == EKCalendarTypeLocal || event.calendar.type == EKCalendarTypeCalDAV;
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!weakSelf) return;
                weakSelf.calendarEvents = [[NSMutableArray alloc] initWithArray: events];
                [weakSelf.calendar reloadData];
            });
        }else{
            //Alert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Permission Error" message:@"Permission fo calendar is required for fetching events" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
   
}
 

// Returns the number of events per date using orderEvents
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    if ([self.distinctEvents containsObject:[self.dateFormatter stringFromDate:date]]){
        int eventCount = 0;
        NSArray * events = [self.orderEvents objectForKey:[self.dateFormatter stringFromDate:date]];
        eventCount = (int)events.count;
        
        for (EKEvent* event in self.calendarEvents){
            NSString * startDateEvent = (NSString*)[self.dateFormatter stringFromDate:event.startDate];
            if ([startDateEvent isEqual:[self.dateFormatter stringFromDate:date]]){
                eventCount += 1;
            }
        }
        return eventCount;
    }else{
        for (EKEvent* event in self.calendarEvents){
            NSString * startDateEvent = (NSString*)[self.dateFormatter stringFromDate:event.startDate];
            if ([startDateEvent isEqual:[self.dateFormatter stringFromDate:date]]){
                return 1;
            }
        }
    }
    return 0;
}

-(NSArray *)calendar: (FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
    
    if ([self.distinctEvents containsObject:[self.dateFormatter stringFromDate:date]]){
        int eventCount = 0;
        NSArray * events = [self.orderEvents objectForKey:[self.dateFormatter stringFromDate:date]];
        eventCount = (int)events.count;
        
        for (EKEvent* event in self.calendarEvents){
            NSString * startDateEvent = (NSString*)[self.dateFormatter stringFromDate:event.startDate];
            if ([startDateEvent isEqual:[self.dateFormatter stringFromDate:date]]){
                return @[appearance.eventDefaultColor, [UIColor blackColor]];
            }
        }
        return @[appearance.eventDefaultColor];;
    }else{
        for (EKEvent* event in self.calendarEvents){
            NSString * startDateEvent = (NSString*)[self.dateFormatter stringFromDate:event.startDate];
            if ([startDateEvent isEqual:[self.dateFormatter stringFromDate:date]]){
                return @[[UIColor blackColor]];
            }
        }
    }
    return nil;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

//[["2022/07/18": [Event1, Event2]]]
//first line obtains all the keys in the dictionary (all the dates)
//object for keys are the events per dates

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSArray *keys = [self.orderEvents allKeys];
    id aKey = [keys objectAtIndex: section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey: aKey];
    Event * event = [events firstObject];
    return [self.timeFormatter stringFromDate:event.date];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EventList * cell = [tableView dequeueReusableCellWithIdentifier:@"EventListCell" forIndexPath:indexPath];
    NSArray *keys = [self.orderEvents allKeys];
    id aKey = [keys objectAtIndex:indexPath.section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aKey];
    Event * event = [events objectAtIndex:indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID =%@", event.professionalID];
    NSArray *selectProfesional = [self.professionals filteredArrayUsingPredicate:predicate];
    [cell setEvent: event with:selectProfesional.firstObject];
    [cell.viewButton addTarget:self action:@selector(viewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)viewButtonTapped:(UIButton*)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.eventsTableView];
    NSIndexPath *clickedButtonIndexPath = [self.eventsTableView indexPathForRowAtPoint:touchPoint];
    NSLog(@"index path.section ==%ld",(long)clickedButtonIndexPath.section);
    NSLog(@"index path.row ==%ld",(long)clickedButtonIndexPath.row);
    [self performSegueWithIdentifier:@"professionalDetail" sender:clickedButtonIndexPath];
}

-(void)cancelButtonTapped:(UIButton*)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.eventsTableView];
    NSIndexPath *clickedButtonIndexPath = [self.eventsTableView indexPathForRowAtPoint:touchPoint];
    NSLog(@"index path.section ==%ld",(long)clickedButtonIndexPath.section);
    NSLog(@"index path.row ==%ld",(long)clickedButtonIndexPath.row);
    NSArray *allDates = [self.orderEvents allKeys];
    id aDate = [allDates objectAtIndex:clickedButtonIndexPath.section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aDate];
    Event * event = [events objectAtIndex:clickedButtonIndexPath.row];
    [self showAlert: event];
}


- (void)showAlert:(Event *)event {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Cancel Event"
                                 message:[NSString stringWithFormat:@"Date: %@", [self.dateFormatter stringFromDate:event.date]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Delete Event"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        PFQuery *query = [PFQuery queryWithClassName:@"Event"];
        [query whereKey:@"objectId" equalTo:event.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            [PFObject deleteAllInBackground:objects];
            [self fetchEvents];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@", error);
        }
       }];
    }];
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Hold Event"
                                style:UIAlertActionStyleDestructive
                                handler:nil];
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderEvents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *keys = [self.orderEvents allKeys];
    id aKey = [keys objectAtIndex:section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aKey];
    return events.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 160;
}

// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath * indexPath = (NSIndexPath*)sender;
    NSArray *allDates = [self.orderEvents allKeys];
    id aDate = [allDates objectAtIndex:indexPath.section];
    NSArray * events = (NSArray *)[self.orderEvents objectForKey:aDate];
    Event * event = [events objectAtIndex:indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID =%@", event.professionalID];
    NSArray *selectProfesional = [self.professionals filteredArrayUsingPredicate:predicate];
    Professional *professional = selectProfesional.firstObject;
    DetailFeedViewController *detailsVC = [segue destinationViewController];
    detailsVC.professional = professional;
}

@end
