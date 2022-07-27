//
//  FeedViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//


#import "FeedViewController.h"
#import "FeedCell.h"
#import "Professional.h"
#import "UserDetail.h"
#import "Parse/Parse.h"
#import <Parse/PFObject+Subclass.h>
#import "DetailFeedViewController.h"
#import "FilterViewController.h"
#import <CoreLocation/CoreLocation.h>




@interface FeedViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, CLLocationManagerDelegate>{
        CLLocationManager *locationManager;
        CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray *profileArray;
@property (strong, nonatomic) NSMutableArray *userDetails;
@property (strong, nonatomic) NSMutableArray *profesionals;
@property (strong, nonatomic) NSMutableArray *profesionalsFiltered;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSMutableArray *userLocation;
@property (strong, nonatomic) NSMutableArray *professionalLocation;

@property CLLocation *location;



// attempt at searchBar

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredProfessionals;


@property BOOL isFiltered;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFiltered = false;
    self.searchBar.delegate = self;
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    [self getProfessionals];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getProfessionals) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:self.refreshControl atIndex:0];
    [self calculateDistance];
    [self currentLocationIdentifier];
}

- (void) currentLocationIdentifier{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];

    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    self.location = location;
    
    
}



-(void) getProfessionals {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [self refreshControl];
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *profesionals, NSError *error){
        [self.refreshControl endRefreshing];
        if(profesionals != nil){
            // do something with the array of object returned by call
            self.profesionals = [[NSMutableArray alloc] initWithArray:profesionals];
            self.profesionalsFiltered = [[NSMutableArray alloc] initWithArray:profesionals];
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltered = false;
        [self.searchBar endEditing:YES];
    } else {
        self.isFiltered = true;
        PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
        [query whereKey:@"Name" containsString:searchText];
        [query findObjectsInBackgroundWithBlock:^(NSArray *profesionals, NSError *error){
            [self.refreshControl endRefreshing];
            self.filteredProfessionals = [[NSMutableArray alloc] initWithArray:profesionals];
            [self.feedTableView reloadData];
        /*
        for (Professional *professional in self.profile) {
            NSRange range = [professional[@"Name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [self.filteredProfessionals addObject:professional];
            }
        }
         */
        }];
    }
    [self.feedTableView reloadData];
}

-(nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    Professional *profile = self.profesionalsFiltered[indexPath.row];
    [cell setProfile:profile];
    [cell.bookAppointmentButton addTarget:self action:@selector(viewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.profesionalsFiltered.count;
}

-(void)viewButtonTapped:(UIButton*)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.feedTableView];
    NSIndexPath *clickedButtonIndexPath = [self.feedTableView indexPathForRowAtPoint:touchPoint];

    NSLog(@"index path.section ==%ld",(long)clickedButtonIndexPath.section);
    NSLog(@"index path.row ==%ld",(long)clickedButtonIndexPath.row);

    [self performSegueWithIdentifier:@"professionalDetail" sender:clickedButtonIndexPath];
}

- (IBAction)feedFilterButton:(id)sender {
    
    [self performSegueWithIdentifier:@"professionalsFilter" sender:nil];

}

- (void) calculateDistance{
    //Query professionals
    PFQuery *professionalDistanceQuery = [PFQuery queryWithClassName:@"Professionals"];
    [professionalDistanceQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable professionals, NSError * _Nullable error) {
        NSLog(@"sucessfully retrived Professional Object");
        NSLog(@"%@", self.professionals);
        for (Professional * professional in professionals){
            
            NSNumber *latitude = professional[@"latitude"];
            NSNumber *longitude = professional[@"longitude"];
    
            CLLocation *professionalLocation = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
            CLLocationDistance distance = [self.location distanceFromLocation:professionalLocation];
            NSLog (@"Current Location: [%f,%f] - Professional Location: [%f,%f] -> Distance: %f", self.location.coordinate.latitude, self.location.coordinate.longitude, latitude.doubleValue, longitude.doubleValue,distance);
        }
    }];
}


- (IBAction)feedNotificationButton:(id)sender {
    
}

- (void)sendDataToA:(nonnull Filter *)filter {
    
    // predicates are conditionals to array.
    NSPredicate *predicateLocation = [NSPredicate predicateWithFormat:@"Location <= %d", filter.selectedDistance.intValue];
    NSPredicate *predicatePrice = [NSPredicate predicateWithFormat:@"Price <= %d", filter.selectedPrice.intValue];
    NSPredicate *predicateAge = [NSPredicate predicateWithFormat:@"Age <= %d", filter.selectedAge.intValue];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateLocation, predicatePrice, predicateAge]];
    NSMutableArray* firstFiltered = [[NSMutableArray alloc] initWithArray:[self.profesionals filteredArrayUsingPredicate:predicate]];
    NSMutableArray * specialityFiltered = [[NSMutableArray alloc]init];
    
    if (filter.selectedSpeciality.count > 0){
        for (Professional* professional in firstFiltered){
            NSArray * specialitys = professional[@"Speciality"];
            for (NSString * speciality in specialitys){
                if([filter.selectedSpeciality containsObject:speciality]){
                    if(![specialityFiltered containsObject:professional]){
                        [specialityFiltered addObject:professional];
                    }
                }
            }
        }
        self.profesionalsFiltered = [[NSMutableArray alloc] initWithArray:specialityFiltered];
    } else{
        self.profesionalsFiltered = [[NSMutableArray alloc] initWithArray: firstFiltered];
    }
    
    NSMutableArray* languagesFiltered = [[NSMutableArray alloc] init];
    if (filter.selectedLanguage.count > 0){
        for (Professional* professional in self.profesionalsFiltered){
            NSArray * languages = professional[@"Language"];
            for (NSString * language in languages){
                if([filter.selectedLanguage containsObject:language]){
                    if(![languagesFiltered containsObject:professional]){
                        [languagesFiltered addObject:professional];
                    }
                }
            }
        }
        self.profesionalsFiltered = [[NSMutableArray alloc] initWithArray:languagesFiltered];
    }
    [self.feedTableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"professionalDetail"]) {
        NSIndexPath * indexPath = (NSIndexPath*)sender;
        Professional *professional = self.profesionalsFiltered[indexPath.row];
        DetailFeedViewController *detailsVC = [segue destinationViewController];
        detailsVC.professional = professional;
    } else if ([segue.identifier isEqual:@"professionalsFilter"]) {
        FilterViewController *filterVC = [segue destinationViewController];
        filterVC.delegate = self;
        filterVC.professionals = self.profesionals;
    }
}

@end




