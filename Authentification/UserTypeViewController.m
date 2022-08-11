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
@end

@implementation UserTypeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.userButton.layer.cornerRadius = 20;
    self.userButton.clipsToBounds = YES;
    self.professionalButton.layer.cornerRadius = 20;
    self.professionalButton.clipsToBounds = YES;
}

- (IBAction)didTapProfessional:(id)sender {
    
    [self performSegueWithIdentifier:@"professionalSegue" sender:nil];
    
}

- (IBAction)didTapUser:(id)sender {
    
    [self performSegueWithIdentifier:@"userSegue" sender:nil];
}

@end
