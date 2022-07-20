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


@interface DetailFeedViewController ()<FSCalendarDelegate, FSCalendarDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *events;
@property (strong, nonatomic) NSDateFormatter * dateFormatter1;
@property (strong, nonatomic) NSDateFormatter * dateFormatter2;
@property (strong, nonatomic) NSMutableDictionary *orderEvents;
@property (strong, nonatomic) NSArray *distinctEvents;



@end

@implementation DetailFeedViewController

UIToolbar* toolbar;
UIDatePicker* picker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchEvents];
    [self getInfo];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.dateFormatter2.dateFormat = @"yyyy/MM/dd hh:mm a";
    
    
}

- (void) getInfo{

    self.detailName.text = [self.professional[@"Name"] capitalizedString];
    self.detailUsername.text = self.professional[@"username"];
    self.detailDescription.text = self.professional[@"Description"];
    NSString * specialityString = [[self.professional[@"Speciality"] valueForKey:@"description"] componentsJoinedByString:@", "];
    self.detailSpeciality.text = specialityString;
    NSString * languageString = [[self.professional[@"Language"] valueForKey:@"description"] componentsJoinedByString:@", "];
    self.detailLanguage.text = languageString;
    
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




- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
    [self selectDate: date];
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
}

- (void)showAlert:(NSDate *)date {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Book Appointment"
                                 message:[NSString stringWithFormat:@"Date: %@", [self.dateFormatter2 stringFromDate:date]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Book Now"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        //Handle your yes please button action here
        [self addEvent: date];
    }];
    
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDestructive
                                handler:nil];
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) addEvent:(NSDate *)date {
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"userID" ] = PFUser.currentUser.objectId;
    event[@"professionalID"] = self.professional[@"userID"];
    event[@"title"] = [NSString stringWithFormat:@"Date: %@", [self.dateFormatter1 stringFromDate:date]];
    event[@"date"] = date;
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Event registered sucessfully");
            [self fetchEvents];
        }else{
            NSLog(@"Event registration failed");
            //there is a problem
        }
    }];
}


- (void) selectDate:(NSDate *)date{
    picker = [[UIDatePicker alloc]init];
    picker.backgroundColor = [UIColor whiteColor];
    [picker setValue:[UIColor blackColor] forKey:@"textColor"];
    
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [picker setDate: date];
    
    [picker addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 300);
    [self.view addSubview:picker];
    
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300, [UIScreen mainScreen].bounds.size.width, 50)];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButtonClick)]];
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
}

- (void) dueDateChanged:(UIDatePicker *)sender{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    
}

- (void)onDoneButtonClick{
    [toolbar removeFromSuperview];
    [picker removeFromSuperview];
    [self showAlert:[picker date]];
}
@end
