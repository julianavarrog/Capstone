//
//  OpenViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "OpenViewController.h"

@interface OpenViewController ()

@end

@implementation OpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapStart:(id)sender {
    [self performSegueWithIdentifier:@"openSegue" sender:nil];

}
@end
