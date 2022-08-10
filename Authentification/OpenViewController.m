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
                                     [UIImage imageNamed:@"helpAnimation.gif"], nil];
    animationView.animationDuration = 4.0f;
    animationView.animationRepeatCount = 0;
    [animationView startAnimating];
    //[self.view addSubview: animationView];
}

- (IBAction)didTapStart:(id)sender {
    [self performSegueWithIdentifier:@"openSegue" sender:nil];

}

@end

