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
    PFUser *user = [PFUser currentUser];
    self.profileUsername.text = user.username;
    PFQuery *checkInfo= [PFQuery queryWithClassName:@"UserDetail"];
    [checkInfo getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable checkObject, NSError * _Nullable error) {
        NSMutableArray *userInfoArray = checkObject[@"username"];
        if([userInfoArray containsObject: user.username]){
            PFQuery *userInfo= [PFQuery queryWithClassName:@"UserDetail"];
            [userInfo whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
            [userInfo getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable userObject, NSError * _Nullable error) {
                self.profileName.text = userObject[@"Name"];
                self.profilePicture.file = userObject[@"Image"];
                self.profilePicture.layer.cornerRadius  = self.profilePicture.frame.size.width/2;
            }];
        }else{
            PFQuery *professionalInfo = [PFQuery queryWithClassName:@"Professional"];
            [professionalInfo whereKey:@"professionalID" equalTo:PFUser.currentUser.objectId];
            [professionalInfo getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable professionalObject, NSError * _Nullable error) {
                self.profileName.text = professionalObject[@"Name"];
                self.profilePicture.file = professionalObject[@"Image"];
                self.profilePicture.layer.cornerRadius  = self.profilePicture.frame.size.width/2;
            }];
        }
    }];

    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *profile, NSError *error){
        [self.refreshControl endRefreshing];
        if(profile != nil){
            // do something with the array of object returned by call
            self.profileArray = profile;
            [self.profileTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}


-(nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell" forIndexPath:indexPath];
    Professional *profile = self.profileArray[indexPath.row];
    [cell setProfile:profile];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.profileArray.count;
}

- (IBAction)didTapSettings:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
}

@end
