//
//  CustomDatePicker.m
//  fbu-app
//
//  Created by lucjia on 7/27/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomDatePicker.h"

@interface CustomDatePicker()

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation CustomDatePicker

- (void) initializeDatePickerWithDatePicker:(UIDatePicker *)picker textField:(UITextField *)textField {
    picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [textField setInputView:picker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.datePicker = picker;
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [textField setInputAccessoryView:toolBar];
    self.textField = textField;
}

- (void) showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    self.textField.text = dueDateString;
    [self.textField resignFirstResponder];
}

@end
