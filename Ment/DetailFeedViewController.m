//
//  DetailFeedViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "DetailFeedViewController.h"
#import "CalendarViewController.h"
#import "Profile.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"
#import "FSCalendar/FSCalendar.h"

@interface DetailFeedViewController ()<FSCalendarDelegate, FSCalendarDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *events;



@end

@implementation DetailFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getInfo];
}

- (void) getInfo{
    
    /*
    approach 1
     
    //PFObject *professionals = [PFObject objectWithClassName:@"Professionals"];
    // do something with the array of object returned by call
    //self.detailName.text = professionals[@"Name"];
    //self.detailUsername.text = professionals[@"Username"];
    
    
     approach 2
     
    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.profile.username];
    self.detailUsername.text = screenName;
    
    self.detailName.text = self.profile.Name;
    */
}

@end
