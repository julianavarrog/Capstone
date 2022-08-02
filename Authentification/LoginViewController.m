//
//  LoginViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/2/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "AuthenticationServices/AuthenticationServices.h"


NSString* const setCurrentIdentifier = @"setCurrentIdentifier";

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize appleIDLoginInfoTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
       [self observeAppleSignInState];
    }
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.clipsToBounds = YES;
    
    self.appleButton.layer.cornerRadius = 20;
    self.appleButton.clipsToBounds = YES;
}

- (void)observeAppleSignInState {
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)handleSignInWithAppleStateChanged:(id)noti {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", noti);
}
 
// Logs in PFUSer, then querys "Professionals" to check if current objectId is present in userId in the PFObject
//If it fails, it is not a Professional. It must be a user -> performs "userSegue"
- (void) loginUser{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Professionals"];
            [query whereKey:@"userID" equalTo:user.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"User logged in sucessfully");
                    //self.window.rootViewController = [UIStoryboard instantiateViewControllerWithIdentifier:@"TabBarController"];
                    [self performSegueWithIdentifier:@"userSegue" sender:nil];
                } else{
                    NSLog(@"Professional logged in sucessfully");
                    [self performSegueWithIdentifier:@"professionalSegue" sender:nil];
                }
            }];
        }
    }];
}

- (IBAction)appleSignIn:(id)sender {
    [self handleAuthrization];
}

- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)signupButton:(id)sender {
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];

}

- (IBAction)loginButton:(id)sender {
    [self loginUser];
}

#pragma mark - Actions

- (void)handleAuthrization{
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        
        // Creates a new Apple ID authorization request.
        ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
        // The contact information to be requested from the user during authentication.
        request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        
        // A controller that manages authorization requests created by a provider.
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        
        // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
        controller.delegate = self;
        
        // A delegate that provides a display context in which the system can present an authorization interface to the user.
        controller.presentationContextProvider = self;
        
        // starts the authorization flows named during controller initialization.
        [controller performRequests];
    }
}


#pragma mark - Delegate

 - (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    NSLog(@"authorization.credential：%@", authorization.credential);
    
    NSMutableString *mStr = [NSMutableString string];
     mStr = [appleIDLoginInfoTextView.text mutableCopy];
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        [[NSUserDefaults standardUserDefaults] setValue:user forKey:setCurrentIdentifier];
        [mStr appendString:user?:@""];
        NSString *familyName = appleIDCredential.fullName.familyName;
        [mStr appendString:familyName?:@""];
        NSString *givenName = appleIDCredential.fullName.givenName;
        [mStr appendString:givenName?:@""];
        NSString *email = appleIDCredential.email;
        [mStr appendString:email?:@""];
        NSLog(@"mStr：%@", mStr);
        [mStr appendString:@"\n"];
        appleIDLoginInfoTextView.text = mStr;
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *passwordCredential = authorization.credential;
        NSString *user = passwordCredential.user;
        NSString *password = passwordCredential.password;
        [mStr appendString:user?:@""];
        [mStr appendString:password?:@""];
        [mStr appendString:@"\n"];
        NSLog(@"mStr：%@", mStr);
        appleIDLoginInfoTextView.text = mStr;
    } else {
         mStr = [@"check" mutableCopy];
        appleIDLoginInfoTextView.text = mStr;
    }
}
 

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"error ：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"ASAuthorizationErrorCanceled";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"ASAuthorizationErrorFailed";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"ASAuthorizationErrorInvalidResponse";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"ASAuthorizationErrorNotHandled";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"ASAuthorizationErrorUnknown";
            break;
    }
    
    NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
    [mStr appendString:errorMsg];
    [mStr appendString:@"\n"];
    appleIDLoginInfoTextView.text = [mStr copy];
    
    if (errorMsg) {
        return;
    }
    
    if (error.localizedDescription) {
        NSMutableString *mStr = [appleIDLoginInfoTextView.text mutableCopy];
        [mStr appendString:error.localizedDescription];
        [mStr appendString:@"\n"];
        appleIDLoginInfoTextView.text = [mStr copy];
    }
    NSLog(@"controller requests：%@", controller.authorizationRequests);
    /*
     ((ASAuthorizationAppleIDRequest *)(controller.authorizationRequests[0])).requestedScopes
     <__NSArrayI 0x2821e2520>(
     full_name,
     email
     )
     */
}
 
//! Tells the delegate from which window it should present content to the user.
 - (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"window：%s", __FUNCTION__);
    return self.view.window;
}

- (void)dealloc {
    
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

 
@end

