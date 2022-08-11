//
//  Helper.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 8/4/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Helper : NSObject {
}
+ (Helper *)sharedObject;
@property PFObject *currentUser;
@property bool isUser;
@end
