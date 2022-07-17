//
//  FeedViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/1/22.
//


#import "FeedViewController.h"
#import "FeedCell.h"
#import "Professional.h"
#import "Parse/Parse.h"
#import <Parse/PFObject+Subclass.h>
#import "DetailFeedViewController.h"
#import "FilterViewController.h"


@interface FeedViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (strong, nonatomic) NSArray *profileArray;
@property (strong, nonatomic) NSMutableArray *profesionals;
@property (strong, nonatomic) NSMutableArray *profesionalsFiltered;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.feedTableView.dataSource = self;
    self.feedTableView.delegate = self;
    [self getProfessionals];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getProfessionals) forControlEvents:UIControlEventValueChanged];
    [self.feedTableView insertSubview:self.refreshControl atIndex:0];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)feedNotificationButton:(id)sender {
    
}

- (void)sendDataToA:(nonnull Filter *)filter {
    // predicates are conditionals to array.
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"Price <= %d", filter.selectedPrice.intValue];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"Age <= %d", filter.selectedAge.intValue];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
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
            NSArray * languages = professional[@"Languages"];
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




