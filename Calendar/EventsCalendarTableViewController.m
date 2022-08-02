//
//  EventsCalendarTableViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/22/22.
//

#import "EventsCalendarTableViewController.h"
#import "Event.h"


@interface EventsCalendarTableViewController ()
@property (strong, nonatomic) NSDateFormatter * eventFormatter;

@end

@implementation EventsCalendarTableViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    
    self.eventFormatter = [[NSDateFormatter alloc]init];
    self.eventFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.eventFormatter.dateFormat = @"yyyy/MM/dd hh:mm a";
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *keys = [self.eventsDic allKeys];
    id aKey = [keys objectAtIndex:section];
    return aKey;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.eventsDic.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *keys = [self.eventsDic allKeys];
    id aKey = [keys objectAtIndex:section];
    NSMutableArray * events = (NSMutableArray *)[self.eventsDic objectForKey: aKey];
    return events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventsCalendarCell"];
    NSArray *keys = [self.eventsDic allKeys];
    id aKey = [keys objectAtIndex : indexPath.section]; // What is aKey? Please use more clear naming :)
    NSMutableArray * events = (NSMutableArray *)[self.eventsDic objectForKey:aKey];
    Event * event = [events objectAtIndex:indexPath.row];
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.dateString;
    return cell;
}


@end
