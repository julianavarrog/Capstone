//
//  UserTypeViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/4/22.
//

#import "UserTypeViewController.h"
#import "UserFinalRegistrationViewController.h"
#import "ProfessionalFinalRegistrationViewController.h"


@interface UserTypeViewController ()
//@property (strong, nonatomic) NSString *type;

@end

@implementation UserTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapProfessional:(id)sender {
    [self performSegueWithIdentifier:@"professionalSegue" sender:nil];
    
}

- (IBAction)didTapUser:(id)sender {
    [self performSegueWithIdentifier:@"userSegue" sender:nil];
}

@end
