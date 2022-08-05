//
//  NotificationsViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "NotificationsViewController.h"
#import "Parse/Parse.h"
#import "NotificationCell.h"
#import "Notification.h"
#import "Event.h"

@interface NotificationsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *notifications;
@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchNotifications];
}

- (void) fetchNotifications{
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"userID" equalTo: PFUser.currentUser.objectId];
    [query whereKey:@"isRead" equalTo: [NSNumber numberWithBool:NO]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable notifications, NSError * _Nullable error) {
        if (!error){
            NSLog(@"sucessfully retrived Notifications");
            self.notifications = [[NSMutableArray alloc]init];
            [self.notifications addObjectsFromArray:notifications];
            [self.notificationTableView reloadData];
        }else{
            NSLog(@"failed to retrived Notifications");
        }
    }];
}

-(void)updateEvent:(Notification*) notification and:(NSString *) state {
    PFQuery *query = [PFQuery queryWithClassName:@"Notification"];
    [query whereKey:@"objectId" equalTo: notification.objectId];
    [query getFirstObjectInBackgroundWithBlock:^ (PFObject * notification, NSError *error) {
        if (notification != nil) {
            notification[@"isRead"] = [NSNumber numberWithBool:YES];
            [notification save];
            
            NSString* eventID = notification[@"extraArgument"];
            if(![eventID isEqual:@""]){
                PFQuery *query = [PFQuery queryWithClassName:@"Event"];
                [query whereKey:@"objectId" equalTo: eventID];
                [query getFirstObjectInBackgroundWithBlock:^ (PFObject * event, NSError *error) {
                    event[@"state"] = state;
                    [event save];
                    [self fetchNotifications];
                    [self addNotification: event];
                }];
            } else {
                [self fetchNotifications];
            }
        }
    }];
}

- (void) addNotification:(PFObject *) event{
    PFObject *notification = [PFObject objectWithClassName:@"Notification"];
    notification[@"userID"] = event[@"userID"];
    notification[@"typeID"] = @"EVENT";
    notification[@"title"] = [NSString stringWithFormat:@"Event: %@", event[@"title"]];
    notification[@"description"] = [NSString stringWithFormat:@"New status: %@", event[@"state"]];
    notification[@"extraArgument"] = @"";
    
    [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Notification registered sucessfully");
        }else{
            NSLog(@"Notification registration failed");
        }
    }];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Notifications";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    Notification * notification = [self.notifications objectAtIndex: indexPath.row];
    cell.acceptButtonTapHandler = ^{
        [self updateEvent: notification and: @"accepted"];
    };
    cell.cancelButtonTapHandler = ^{
        [self updateEvent: notification and: @"canceled"];
    };
    [cell setup: notification];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 194;
}

@end
