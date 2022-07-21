//
//  TestAppleSignin.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/12/22.
//

#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>

extern NSString* const setCurrentIdentifier;


@interface TestAppleSignin : UIViewController<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (nonatomic, strong) UITextView *appleIDLoginInfoTextView;

@end


