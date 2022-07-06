//
//  userTypeViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "userTypeViewController.h"
#import "UserFinalRegistrationViewController.h"
#import "ProfessionalFinalRegistrationViewController.h"


@interface userTypeViewController ()
//@property (strong, nonatomic) NSString *type;

@end

@implementation userTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapProfessional:(id)sender {
    [self performSegueWithIdentifier:@"professionalSegue" sender:nil];
    
}

- (IBAction)didTapUser:(id)sender {
    [self performSegueWithIdentifier:@"userSegue" sender:nil];
}

@end
