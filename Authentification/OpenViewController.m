//
//  OpenViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "OpenViewController.h"
#import "LoginViewController.h"

@interface OpenViewController ()

@end

@implementation OpenViewController
@synthesize animationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getStartedButton.layer.cornerRadius = 20;
    self.getStartedButton.clipsToBounds = YES;
    
    animationView.animationImages = [[NSArray alloc]initWithObjects:
                                     [UIImage imageNamed:@"helpAnimation1"],
                                     [UIImage imageNamed:@"helpAnimation2"],
                                     [UIImage imageNamed:@"helpAnimation3"],
                                     [UIImage imageNamed:@"helpAnimation4"],
                                     [UIImage imageNamed:@"helpAnimation5"],
                                     [UIImage imageNamed:@"helpAnimation6"],
                                     [UIImage imageNamed:@"helpAnimation7"],
                                     [UIImage imageNamed:@"helpAnimation8"],
                                     [UIImage imageNamed:@"helpAnimation9"],
                                     [UIImage imageNamed:@"helpAnimation10"],
                                     [UIImage imageNamed:@"helpAnimation11"],
                                     [UIImage imageNamed:@"helpAnimation12"],
                                     [UIImage imageNamed:@"helpAnimation13"],
                                     [UIImage imageNamed:@"helpAnimation14"],
                                     [UIImage imageNamed:@"helpAnimation15"],
                                     [UIImage imageNamed:@"helpAnimation16"],
                                     [UIImage imageNamed:@"helpAnimation17"],
                                     [UIImage imageNamed:@"helpAnimation18"],
                                     [UIImage imageNamed:@"helpAnimation19"],
                                     [UIImage imageNamed:@"helpAnimation20"],
                                     [UIImage imageNamed:@"helpAnimation21"],
                                     [UIImage imageNamed:@"helpAnimation22"],
                                     [UIImage imageNamed:@"helpAnimation23"],
                                     [UIImage imageNamed:@"helpAnimation24"],
                                     [UIImage imageNamed:@"helpAnimation25"],
                                     [UIImage imageNamed:@"helpAnimation26"],
                                     [UIImage imageNamed:@"helpAnimation27"],
                                     [UIImage imageNamed:@"helpAnimation28"],
                                     [UIImage imageNamed:@"helpAnimation29"],
                                     [UIImage imageNamed:@"helpAnimation30"],
                                     [UIImage imageNamed:@"helpAnimation31"],
                                     [UIImage imageNamed:@"helpAnimation32"],
                                     [UIImage imageNamed:@"helpAnimation33"],
                                     [UIImage imageNamed:@"helpAnimation34"],
                                     [UIImage imageNamed:@"helpAnimation35"],
                                     [UIImage imageNamed:@"helpAnimation36"],
                                     [UIImage imageNamed:@"helpAnimation37"],
                                     [UIImage imageNamed:@"helpAnimation38"],
                                     [UIImage imageNamed:@"helpAnimation39"],
                                     [UIImage imageNamed:@"helpAnimation40"],
                                     [UIImage imageNamed:@"helpAnimation41"],
                                     [UIImage imageNamed:@"helpAnimation42"],
                                     [UIImage imageNamed:@"helpAnimation43"],
                                     [UIImage imageNamed:@"helpAnimation44"],
                                     [UIImage imageNamed:@"helpAnimation45"],
                                     [UIImage imageNamed:@"helpAnimation46"],
                                     [UIImage imageNamed:@"helpAnimation47"],
                                     [UIImage imageNamed:@"helpAnimation48"],
                                     [UIImage imageNamed:@"helpAnimation49"],
                                     [UIImage imageNamed:@"helpAnimation50"],
                                     [UIImage imageNamed:@"helpAnimation51"], nil];
    animationView.animationDuration = 2.0f;
    animationView.animationRepeatCount = 0;
    [animationView startAnimating];
    [self.view addSubview: animationView];
}

- (IBAction)didTapStart:(id)sender {
    [self performSegueWithIdentifier:@"openSegue" sender:nil];

}

@end

