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
#import "Helper.h"


@interface FeedViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, CLLocationManagerDelegate>{
        CLLocationManager *locationManager;
        CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray *profileArray;
@property (strong, nonatomic) NSMutableArray *userDetails;
@property (strong, nonatomic) NSMutableArray *profesionalsFiltered;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *userLocation;
@property (strong, nonatomic) NSMutableArray *professionalLocation;
@property CLLocation *location;
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
    [self currentLocationIdentifier];
}

-(void) getProfessionals {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [self refreshControl];
    //fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *professionals, NSError *error){
        [self.refreshControl endRefreshing];
        if(professionals != nil){
            self.professionals = [[NSMutableArray alloc] init];
            self.profesionalsFiltered = [[NSMutableArray alloc] init];
            
            for (Professional * professional in professionals){
                
                NSNumber *latitude = professional[@"latitude"];
                NSNumber *longitude = professional[@"longitude"];
        
                CLLocation *professionalLocation = [[CLLocation alloc]initWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
                CLLocationDistance distance = [self.location distanceFromLocation:professionalLocation];
                NSLog (@"Current Location %@: [%f,%f] - Professional Location: [%f,%f] -> Distance: %f",professional[@"Name"], self.location.coordinate.latitude, self.location.coordinate.longitude, latitude.doubleValue, longitude.doubleValue,distance);
                professional[@"distance"] = @(distance);
                [self.professionals addObject:professional];
                [self.profesionalsFiltered addObject:professional];
            }
            // do something with the array of object returned by call
            [self.feedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Filtering with Predicates

- (void)sendDataToFilter:(nonnull Filter *)filter {
    
    // predicates are conditionals to array.
    NSPredicate *predicateLocation = [NSPredicate predicateWithFormat:@"distance <= %d", filter.selectedDistance.intValue];
    NSPredicate *predicatePrice = [NSPredicate predicateWithFormat:@"Price <= %d", filter.selectedPrice.intValue];
    NSPredicate *predicateAge = [NSPredicate predicateWithFormat:@"Age <= %d", filter.selectedAge.intValue];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicatePrice, predicateAge, predicateLocation]];
    NSMutableArray* firstFiltered = [[NSMutableArray alloc] initWithArray:[self.professionals filteredArrayUsingPredicate:predicate]];
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

#pragma mark - UITableView

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

#pragma mark - LocationManagerDelegate
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

#pragma mark - UISearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.isFiltered = false;
        [self.searchBar endEditing:YES];
        
    } else {
        self.isFiltered = true;
        self.profesionalsFiltered = [[NSMutableArray alloc] init];
        for (Professional *professional in self.professionals) {
            NSRange range = [professional[@"Name"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                
                [self.profesionalsFiltered addObject: professional];
            }
        }
    }
    [self.feedTableView reloadData];
}

#pragma mark - Navigation

- (IBAction)feedFilterButton:(id)sender {
    
    [self performSegueWithIdentifier:@"professionalsFilter" sender:nil];
}

- (IBAction) feedNotificationButton:(id)sender{
    [self performSegueWithIdentifier:@"userNotificationSegue" sender:nil];
}

-(void)viewButtonTapped:(UIButton*)sender {
    
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:self.feedTableView];
    NSIndexPath *clickedButtonIndexPath = [self.feedTableView indexPathForRowAtPoint:touchPoint];

    NSLog(@"index path.section ==%ld",(long)clickedButtonIndexPath.section);
    NSLog(@"index path.row ==%ld",(long)clickedButtonIndexPath.row);

    [self performSegueWithIdentifier:@"professionalDetail" sender:clickedButtonIndexPath];
}

#pragma mark - Navegation

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
        filterVC.professionals = self.professionals;
    }
}

@end



