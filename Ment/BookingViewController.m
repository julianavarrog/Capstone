//
//  BookingViewController.m
//  Ment
//
//  Created by Julia Navarro Goldaraz on 7/15/22.
//

#import "BookingViewController.h"

@interface BookingViewController ()

@end

@implementation BookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.dateSelectionTextField setInputView:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor: [UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space, doneBtn, nil]];
    
    // Do any additional setup after loading the view.
}

- (void) ShowSelectedDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat: @"dd/mm/yyyy"];
    self.dateSelectionTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dateSelectionTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
