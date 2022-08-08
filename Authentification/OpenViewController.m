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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.getStartedButton.layer.cornerRadius = 20;
    self.getStartedButton.clipsToBounds = YES;
}

- (IBAction)didTapStart:(id)sender {
    [self performSegueWithIdentifier:@"openSegue" sender:nil];

}

@end

