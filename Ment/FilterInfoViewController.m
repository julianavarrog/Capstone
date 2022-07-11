//
//  FilterInfoViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/11/22.
//

#import "FilterInfoViewController.h"
#import "Speciality.h"
#import "Languages.h"

@interface FilterInfoViewController ()
@property (nonatomic, strong) NSMutableArray *specialityArray;
@property (nonatomic, strong) NSMutableArray *languagesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *specialityController;
@property (weak, nonatomic) IBOutlet UICollectionView *languagesController;


@end

@implementation FilterInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.specialityController.dataSource = self;
    self.specialityController.delegate = self;
    
    self.languagesController.dataSource = self;
    self.languagesController.delegate = self;
    
    _specialityArray = [NSMutableArray arrayWithObjects: @"Family & Friends", @"Behavioural", @"Child Therapist", @"Stress Managment", @"General", @"Life Coaching", nil];
    
    _languagesArray = [NSMutableArray arrayWithObjects: @"English", @"Spanish", @"French", @"Hindi", @"Mandarine", @"Portuguese", nil];
    
}

-(NSInteger)numberOfSectionsInCollectionView:
     (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    return self.specialityArray.count;
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Speciality *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialityCollectorCell" forIndexPath:indexPath];

    cell.specialityLabel.text = self.specialityArray[indexPath.item];
    return cell;
}


- (IBAction)didTapLanguage:(id)sender {
}

- (IBAction)didTapSpeciality:(id)sender {
}

- (IBAction)sliderAgeAction:(id)sender {
    self.ageAmount.text = [NSString stringWithFormat:@"%0.0f", self.ageSlider.value];
}

- (IBAction)sliderPriceAction:(id)sender {
    self.priceAmount.text = [NSString stringWithFormat:@"%0.0f", self.priceSlider.value];
}

- (IBAction)finalSignUp:(id)sender {
    [self performSegueWithIdentifier:@"uploadPictureSegue" sender:nil];
}
@end
