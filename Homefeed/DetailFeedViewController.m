//
//  DetailFeedViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "DetailFeedViewController.h"
#import "CalendarViewController.h"
#import "Professional.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "FSCalendar/FSCalendar.h"
#import "Event.h"
#import "EventsCalendarTableViewController.h"
@import EventKit;
@import EventKitUI;


@interface DetailFeedViewController ()<FSCalendarDelegate, FSCalendarDataSource, UITextViewDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSDateFormatter * dateFormatterYMD;
@property (strong, nonatomic) NSDateFormatter * dateFormatterYMDHMA;
@property (strong, nonatomic) NSDateFormatter * dateFormatterHMA;
@property (strong, nonatomic) NSDateFormatter * dateFormatterMD;
@property (strong, nonatomic) NSMutableDictionary *orderEvents;
@property (strong, nonatomic) NSArray *distinctEvents;

@end

@implementation DetailFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchEvents];
    [self getInfo];
    
    self.dateFormatterYMD = [[NSDateFormatter alloc] init];
    self.dateFormatterYMD.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatterYMD.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatterYMDHMA = [[NSDateFormatter alloc] init];
    self.dateFormatterYMDHMA.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatterYMDHMA.dateFormat = @"yyyy/MM/dd hh:mm a";
    
    self.dateFormatterHMA = [[NSDateFormatter alloc] init];
    self.dateFormatterHMA.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatterHMA.dateFormat = @"hh:mm a";
    
    self.dateFormatterMD = [[NSDateFormatter alloc] init];
    self.dateFormatterMD.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatterMD.dateFormat = @"MMM d";
}

- (void) getInfo{

    self.detailName.text = [self.professional[@"Name"] capitalizedString];
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.professional[@"username"]];
    self.detailUsername.text = screenName;
    self.detailDescription.text = self.professional[@"Description"];
    NSString * specialityString = [[self.professional[@"Speciality"] valueForKey:@"description"] componentsJoinedByString:@", "];
    self.detailSpeciality.text = specialityString;
    NSString * languageString = [[self.professional[@"Language"] valueForKey:@"description"] componentsJoinedByString:@", "];
    self.detailLanguage.text = languageString;
    
    NSString* myNewString = [NSString stringWithFormat:@"%@", self.professional[@"Price"]];
    self.detailPrice.text = myNewString;
    
    self.detailImage.file = self.professional[@"Image"];
    self.detailImage.layer.cornerRadius  = self.detailImage.frame.size.width/2;
}

- (void) fetchEvents{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"professionalID" equalTo:self.professional[@"userID"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable events, NSError * _Nullable error) {
        if (!error){
            NSLog(@"sucessfully retrived Event");
            self.events = [[NSMutableArray alloc]init];
            [self.events addObjectsFromArray:events];
            
            for (Event * event in self.events){
                event.dateString = [self.dateFormatterYMD stringFromDate: event.date];
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
        }else{
            NSLog(@"failed to retrived Event");
        }
    }];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    if ([self.distinctEvents containsObject:[self.dateFormatterYMD stringFromDate:date]]){
        NSArray * events = [self.orderEvents objectForKey:[self.dateFormatterYMD stringFromDate:date]];
        return events.count;
    }
    return 0;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatterYMD stringFromDate:date]);
    
    [self showAlert: date];
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)showAlert:(NSDate *)date {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Selected Date"
                                 message:[NSString stringWithFormat:@"%@", [self.dateFormatterYMDHMA stringFromDate:date]]
                                 preferredStyle:UIAlertControllerStyleActionSheet];
  
    UIAlertAction* eventsButton = [UIAlertAction
                                actionWithTitle:@"View Events"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        [self performSegueWithIdentifier:@"detailCalendarSegue" sender:date];
    }];
    
    UIAlertAction* createEventButton = [UIAlertAction
                                actionWithTitle:@"Create Event"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        [self createCalendarEvent: date];
    }];
    
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDestructive
                                handler:nil];
    [alert addAction:eventsButton];
    [alert addAction:createEventButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - createEvent -

//
- (void) createCalendarEvent: (NSDate *) date{
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]){
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (!granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Permission Error" message:@"Permission of calendar is required for fetching events" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
                    addController.event = [self createEvent:eventStore and:date];
                    addController.eventStore = eventStore;
                    
                    [self presentViewController:addController animated:YES completion:nil];
                    addController.editViewDelegate = self;
                });
            }
        }];
    }
}

- (EKEvent*) createEvent:(EKEventStore*)eventStore and:(NSDate *) date{
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = @"New Event";
    
    event.startDate = date;
    event.endDate = date;
    
    event.allDay = NO;
    event.notes = @"Event description";
    
    NSString*calendarName = @"Calendar";
    EKCalendar * calendar;
    EKSource *localSource;
    for(EKSource *source in eventStore.sources){
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCould"]){
            localSource = source;
            break;
        }
    }
    if (localSource == nil){
        for(EKSource *source in eventStore.sources){
            if (source.sourceType == EKSourceTypeLocal){
                localSource = source;
                break;
            }
        }
    }
    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
    calendar.source = localSource;
    calendar.title = calendarName;
    NSError * error;
    [eventStore saveCalendar:calendar commit:YES error:&error];
    return event;
}

#pragma mark -eventEditDelegate-
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    if (action ==EKEventEditViewActionCanceled){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (action == EKEventEditViewActionSaved){
        [self addEvent:controller.event];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void) addEvent:(EKEvent *)eventCalendar {
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"userID" ] = PFUser.currentUser.objectId;
    event[@"professionalID"] = self.professional[@"userID"];
    event[@"title"] = eventCalendar.title;
    event[@"description"] = eventCalendar.notes;
    event[@"date"] = eventCalendar.startDate;
    event[@"endDate"] = eventCalendar.endDate;

    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Event registered sucessfully");
            [self addNotification:eventCalendar and: event];
            [self fetchEvents];
        }else{
            NSLog(@"Event registration failed");
            //there is a problem
        }
    }];
}

#pragma mark - Activity

- (void) addActivity:(PFObject *) event {
    PFObject* activity = [PFObject objectWithClassName:@"Activities"];
    activity[@"userId" ] = PFUser.currentUser.objectId;
    activity[@"professionalId"] = self.professional[@"userID"];
    activity[@"state1"] = [NSNumber numberWithBool: NO];
    activity[@"state2"] = [NSNumber numberWithBool: NO];
    activity[@"state3"] = [NSNumber numberWithBool: NO];
    activity[@"count"] = @(0);
    activity[@"dateEvent"] = [self.dateFormatterMD stringFromDate: event[@"date"]];
    activity[@"reflection"] = [NSString stringWithFormat:@"Complete Task for Event: %@", event[@"title"]];
    
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Activity registered sucessfully");
        }else{
            NSLog(@"Activity registration failed");
        }
    }];
}

#pragma mark - Notifications

- (void) addNotification:(EKEvent *) eventCalendar  and:(PFObject *) eventLocal{
    PFObject *notification = [PFObject objectWithClassName:@"Notification"];
    notification[@"userID"] = self.professional[@"userID"];
    notification[@"typeID"] = @"EVENT";
    notification[@"title"] = eventCalendar.title;
    notification[@"description"] = [NSString stringWithFormat:@"%@ %@ - %@",
                                    [self.dateFormatterYMD stringFromDate: eventCalendar.startDate],
                                    [self.dateFormatterHMA stringFromDate: eventCalendar.startDate],
                                    [self.dateFormatterHMA stringFromDate: eventCalendar.endDate]];
    notification[@"extraArgument"] = eventLocal.objectId;
    
    [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Notification registered sucessfully");
        }else{
            NSLog(@"Notification registration failed");
        }
    }];
}


#pragma mark - Navegation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailCalendarSegue"]){
        NSString *dateKey = [self.dateFormatterYMD stringFromDate: (NSDate *)sender];
        NSArray * eventsArray = (NSArray *)[self.orderEvents objectForKey:dateKey];
        NSMutableArray * events = [[NSMutableArray alloc]initWithArray: eventsArray];
        
        NSMutableDictionary * eventsDic = [[NSMutableDictionary alloc]init];
        eventsDic[@"App Calendar"] = events;
        
        EventsCalendarTableViewController *eventsCalendarVC = [segue destinationViewController];
        eventsCalendarVC.eventsDic = eventsDic;
    }
}
@end
