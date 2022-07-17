//
//  NewFilterInfoViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/13/22.
//

#import "NewFilterInfoViewController.h"
#import "ProfessionalFinalRegistrationViewController.h"
#import "Parse/Parse.h"
#import "Professional.h"


@interface NewFilterInfoViewController ()
@property (strong, nonatomic) NSMutableArray *professional;


@end

@implementation NewFilterInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countFamily = 0;
    _countBehavioural = 0;
    _countChild = 0;
    _countStress = 0;
    _countGeneral = 0;
    _countLife = 0;
    _specialityArray = [[NSMutableArray alloc] init];
    _languageArray = [[NSMutableArray alloc] init];
    
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

- (IBAction)priceSliderAction:(id)sender {
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
}

- (IBAction)ageSliderAction:(id)sender {
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
}

- (IBAction)finalSignUp:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query whereKey:@"userID" equalTo:PFUser.currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable events, NSError * _Nullable error) {
        for(Professional * professional in self.professional) {
                professional[@"Price"] = self.priceAmount.text;
                professional[@"Age"] = self.ageAmount.text;
                //professional[@"Speciality"] = self.specialityArray;
               // professional[@"Language"] = self.languageArray;
            }
    }];
    [self performSegueWithIdentifier:@"uploadPictureSegue" sender:nil];
}
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable professionals, NSError * _Nullable error) {
        if (!error){
            for(Profile * professional in professionals) {
                    professional[@"Price"] = self.priceAmount.text;
                    professional[@"Age"] = self.ageAmount.text;
                if(self.specialityArray){
                    professional[@"Speciality"] = self.specialityArray;
                }
                if (self.languageArray){
                    professional[@"Language"] = self.languageArray;
                }
                [professional saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error){
                        if (succeeded){
                            [self performSegueWithIdentifier:@"uploadPictureSegue" sender:nil];
                        }
                    }
                    else{
                        NSLog(@"failed to save to Professionals");
                    }
                }];
            }
        }else{
            NSLog(@"failed to retrive Professionals");
        }
    }];

}
     */
    
    /*
    PFObject * object = [PFObject objectWithClassName:@"Professionals"];
    [object where]
    [object objectForKey:@"userID" equalTo:PFUser.currentUser.objectId];
    [object setValue:self.priceAmount.text forKey:@"Price"];
     */
    


//Speciality
- (IBAction)tappedFamily:(id)sender {
    if (_countFamily == 0){
        [_specialityArray addObject:@"Family & Friends"];
        _familyButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countFamily = @1;
    }else{
        [_specialityArray removeObject:@"Family & Friends"];
        _countFamily = 0;
        _familyButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];

    }
    NSLog(@"%@",_specialityArray);
}
- (IBAction)tappedBehavioural:(id)sender {

    if (_countBehavioural == 0){
        [_specialityArray addObject:@"Behavioural"];
        _behaviouralButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countBehavioural = @1;
    }else{
        [_specialityArray removeObject:@"Behavioural"];
        _countBehavioural = @0;
        _behaviouralButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    }
    NSLog(@"%@",_specialityArray);

}
- (IBAction)tappedChild:(id)sender {
    if (_countChild == 0){
        [_specialityArray addObject:@"Child Therapist"];
        _childButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countChild = @1;
    }else{
        [_specialityArray removeObject:@"Child Therapist"];
        _childButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countChild = @0;
    }
    NSLog(@"%@",_specialityArray);

}

- (IBAction)tappedStress:(id)sender {
    if (_countStress == 0){
        [_specialityArray addObject:@"Stress Managment"];
        _stressButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countStress = @1;
    }else{
        [_specialityArray removeObject:@"Stress Managment"];
        _stressButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countStress = @0;
    }
    NSLog(@"%@",_specialityArray);

}

- (IBAction)tappedGeneral:(id)sender {
    if (_countGeneral == 0){
        [_specialityArray addObject:@"General"];
        _generalButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countGeneral = @1;
    }else{
        [_specialityArray removeObject:@"General"];
        _generalButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countGeneral = @0;
    }
    NSLog(@"%@",_specialityArray);

}
- (IBAction)tappedLife:(id)sender {
    if (_countLife == 0){
        [_specialityArray addObject:@"Life Coaching"];
        _lifeButton.backgroundColor = [UIColor colorWithRed:0.82 green:0.77 blue:0.94 alpha:1.0];
        _countLife = @1;
    }else{
        [_specialityArray removeObject:@"Life Coaching"];
        _lifeButton.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
        _countLife = @0;
    }
    NSLog(@"%@",_specialityArray);
}

//Languages
- (IBAction)tappedSpanish:(id)sender {
}
- (IBAction)tappedEnglish:(id)sender {
}
- (IBAction)tappedFrench:(id)sender {
}
- (IBAction)tappedPortuguese:(id)sender {
}
- (IBAction)tappedMandarin:(id)sender {
}
- (IBAction)tappedOther:(id)sender {
}



@end
