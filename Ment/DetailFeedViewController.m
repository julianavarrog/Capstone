//
//  DetailFeedViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/5/22.
//

#import "DetailFeedViewController.h"
#import "Profile.h"
#import "PFUser.h"
#import "Parse/Parse.h"
#import "Parse/PFImageView.h"

@interface DetailFeedViewController ()<UITextViewDelegate>

@end

@implementation DetailFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self getInfo];
    
}

- (void) getInfo{
    

    NSString *atName = @"@";
    NSString *screenName = [atName stringByAppendingString:self.profile[@"username"]];
    self.detailUsername.text = screenName;
    
    //self.detailUsername.text = self.post.author.username;
    
   // self.detailCaption.text = self.post.caption;
   // self.detailImage.file = self.post.image;
    
    //self.detailProfileImage.file = self.post.author[@"profilePic"];
    //self.detailProfileImage.layer.cornerRadius = self.detailProfileImage.frame.size.height/2;
        
}

@end
