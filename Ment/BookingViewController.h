//
//  BookingViewController.h
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookingViewController : UIViewController
{
    UIDatePicker * datePicker;
}
@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;

@end

NS_ASSUME_NONNULL_END
