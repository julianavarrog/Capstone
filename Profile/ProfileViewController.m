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


@interface ProfileViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) NSArray *profileArray;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property Boolean isUser;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCurrentUserInfo];
    
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getCurrentUserInfo) forControlEvents:UIControlEventValueChanged];
    [self.profileTableView insertSubview:self.refreshControl atIndex:0];
}


/*
- (IBAction)segmentedTapped:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0){
        [self.calendar setHidden:false];
        [self.calendarlist setHidden:true];
    }else{
        [self.calendar setHidden:true];
        [self.calendarlist setHidden:false];
    }
}
*/

-(void) getCurrentUserInfo  {
    self.isUser = NO;
    PFUser *currentUser = [PFUser currentUser];
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:currentUser.username];
    self.profileUsername.text = screenName;
    PFQuery *checkInfo= [PFQuery queryWithClassName:@"UserDetail"];
    [checkInfo findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        for (PFObject* user in users){
            NSString *userID = user[@"userID"];
            if([userID isEqual: currentUser.objectId]){
                self.profileName.text = user[@"Name"];
                self.profilePicture.file = user[@"Image"];
                self.profilePicture.layer.cornerRadius  = self.profilePicture.frame.size.width/2;
                self.isUser = YES;
                
                PFQuery *query = [PFQuery queryWithClassName:@"Event"];
                [query whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
                [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error){
                    [self.refreshControl endRefreshing];
                    if(events != nil){
                        // do something with the array of object returned by call
                        self.profileArray = events;
                        [self.profileTableView reloadData];
                    } else {
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
        }
        if (self.isUser == NO){
            PFQuery *professionalInfo = [PFQuery queryWithClassName:@"Professionals"];
            [professionalInfo whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
            [professionalInfo getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable professionalObject, NSError * _Nullable error) {
                self.profileName.text = professionalObject[@"Name"];
                self.profilePicture.file = professionalObject[@"Image"];
                self.profilePicture.layer.cornerRadius  = self.profilePicture.frame.size.width/2;
            }];
            PFQuery *query = [PFQuery queryWithClassName:@"Event"];
            [query whereKey:@"professionalID" equalTo:PFUser.currentUser.objectId];
            [query findObjectsInBackgroundWithBlock:^(NSArray *events, NSError *error){
                [self.refreshControl endRefreshing];
                if(events != nil){
                    // do something with the array of object returned by call
                    self.profileArray = events;
                    [self.profileTableView reloadData];
                } else {
                    NSLog(@"%@", error.localizedDescription);
                }
            }];
        }
    }];
}


-(nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Professional *profile = self.profileArray[indexPath.row];
    [cell setProfile:profile];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileArray.count;
}

- (IBAction)didTapSettings:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
}

@end
