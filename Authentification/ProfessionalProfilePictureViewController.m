//
//  ProfessionalProfilePictureViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "ProfessionalProfilePictureViewController.h"
#import "Parse/PFImageView.h"
#import "Parse/Parse.h"
#import "Professional.h"

@interface ProfessionalProfilePictureViewController ()<UIImagePickerControllerDelegate>


@end

@implementation ProfessionalProfilePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didChooseImage:(id)sender {
    [self getPhotoLibrary];
    
}
- (void)getPhotoLibrary{
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    CGSize resizeSize = CGSizeMake(80, 80);
    if (editedImage) {
        self.chosenProfilePicture.image = [self resizeImage:editedImage withSize:resizeSize];
    } else {
        self.chosenProfilePicture.image = [self resizeImage:originalImage withSize:resizeSize];
    }
    
    //PFUser *user = [PFUser currentUser];
    PFObject *parseObject = [PFObject objectWithClassName:@"Professionals"];
    
    //parseObject[@"Image"] = imageFile;
    [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (IBAction)didSignUp:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
    [query whereKey:@"userID" equalTo:self.objectToUpdatePicture];
    [query getFirstObjectInBackgroundWithBlock:^ (PFObject * professional, NSError *error) {
        PFFileObject *imageFile = [ProfessionalProfilePictureViewController getPFFileFromImage: self.chosenProfilePicture.image];
        professional[@"Image"] = imageFile;
        [professional save];
    }];
    [self performSegueWithIdentifier:@"secondSegue" sender:nil];
}

@end
