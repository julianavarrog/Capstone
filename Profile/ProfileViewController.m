//
//  ProfileViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//

#import "ProfileViewController.h"
#import "ProfileCell.h"
#import "Parse/Parse.h"
#import "Professional.h"
#import <Parse/PFObject+Subclass.h>
#import "SessionSummaryViewController.h"
#import "Helper.h"



@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) NSMutableArray * activities;
@property (strong, nonatomic) NSMutableArray * activitiesFiltered;
@property (strong, nonatomic) NSMutableArray * professionals;
@property (strong, nonatomic) NSMutableArray * users;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSDateFormatter * timeFormatter;

@property Boolean isUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProfessionals];
    
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchProfessionals) forControlEvents:UIControlEventValueChanged];
    [self.profileTableView insertSubview:self.refreshControl atIndex:0];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    self.timeFormatter.dateFormat = @"MMM d";
    
    //swipe gesture initialization
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(detectSwipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self  action:@selector(detectSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

# pragma mark - Query Parse Data
-(void) fetchProfessionals {
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [self refreshControl];
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *professionals, NSError *error){
        [self.refreshControl endRefreshing];
        if(professionals != nil){
            self.professionals = [[NSMutableArray alloc] initWithArray: professionals];
            [self fetchUsers];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void) fetchUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"UserDetail"];
    [self refreshControl];
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error){
        [self.refreshControl endRefreshing];
        if(users != nil){
            self.users = [[NSMutableArray alloc] initWithArray: users];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", PFUser.currentUser.objectId];
            UserDetail * user = [[NSMutableArray alloc] initWithArray:[self.users filteredArrayUsingPredicate:predicate]].firstObject;
            
            PFQuery *query = [PFQuery queryWithClassName:@"Activities"];
            if (user != nil) {
                self.isUser = YES;
                [self setupProfileInfo: user];
                [query whereKey:@"userId" equalTo:PFUser.currentUser.objectId];
            } else {
                Professional * professional = [[NSMutableArray alloc] initWithArray:[self.professionals filteredArrayUsingPredicate:predicate]].firstObject;
                [self setupProfileInfo: professional];
                self.isUser = NO;
                [query whereKey:@"professionalId" equalTo:PFUser.currentUser.objectId];
            }
            [query findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error){
                [self.refreshControl endRefreshing];
                if(activities != nil){
                    // do something with the array of object returned by call
                    self.activities = [[NSMutableArray alloc] initWithArray: activities];
                    [self updateActivitiesByState: self.segmentedProfile.selectedSegmentIndex];
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(void) setupProfileInfo:(PFObject *) currentUser {
    self.profileName.text = currentUser[@"Name"];
    self.profilePicture.file = currentUser[@"Image"];
    NSString *atName = @"@";
    if (currentUser[@"username"] != nil){
        NSString *screenName = [atName stringByAppendingString:currentUser[@"username"]];
        self.profileUsername.text = screenName;
    }else{
        [self.profileUsername setHidden:YES];
    }
    self.profilePicture.layer.cornerRadius  = self.profilePicture.frame.size.width/2;
}

# pragma mark - Update Activities
- (void) updateActivitiesByState:(NSInteger) complete {
    if (complete == 1) {
        NSPredicate *predicateComplete = [NSPredicate predicateWithFormat:@"count == %d", 3];
        self.activitiesFiltered = [[NSMutableArray alloc] initWithArray:[self.activities filteredArrayUsingPredicate:predicateComplete]];
    } else {
        NSPredicate *predicateComplete = [NSPredicate predicateWithFormat:@"count < %d", 3];
        self.activitiesFiltered =  [[NSMutableArray alloc] initWithArray:[self.activities filteredArrayUsingPredicate:predicateComplete]];
    }
    [self.profileTableView reloadData];
}

- (void) dismissActivity {
    [self fetchProfessionals];
}

#pragma mark - Swipe Gesture Recognizer

- (IBAction)detectSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"%lu",self.tabBarController.selectedIndex);
        self.tabBarController.selectedIndex +=1;
        NSLog(@"%lu",self.tabBarController.selectedIndex);
   } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
       self.tabBarController.selectedIndex -=1;
   }
}
#pragma mark - UITableView

-(nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
    PFObject *activity = self.activitiesFiltered[indexPath.row];
    
    if (self.isUser) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", activity[@"professionalId"]];
        Professional * professional = [[NSMutableArray alloc] initWithArray:[self.professionals filteredArrayUsingPredicate:predicate]].firstObject;
        [cell setActivity: activity with: professional];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", activity[@"userId"]];
        UserDetail * user = [[NSMutableArray alloc] initWithArray:[self.users filteredArrayUsingPredicate:predicate]].firstObject;
        [cell setActivity: activity with: user];
    }
    cell.viewButtonTapHandler = ^{
        [self performSegueWithIdentifier:@"activityDetailSegue" sender:activity];
    };
    cell.cancelButtonTapHandler = ^{
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activitiesFiltered.count;
}


#pragma mark - Navegation

- (IBAction)segmentedTapped:(UISegmentedControl *)sender {
    [self updateActivitiesByState: sender.selectedSegmentIndex];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"activityDetailSegue"]) {
        SessionSummaryViewController *viewController = [segue destinationViewController];
        PFObject* activity = (PFObject *)sender;
        viewController.activity = activity;
        viewController.isUser = self.isUser;
        viewController.delegate = self;
    }
}

- (IBAction)didTapSettings:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
}


@end
