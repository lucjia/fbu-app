//
//  CustomDatePicker.m
//  fbu-app
//
//  Created by lucjia on 7/27/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CustomDatePicker.h"

@implementation CustomDatePicker

- (void) initializeDatePickerWithDatePicker:(UIDatePicker *)picker textField:(UITextField *)textField {
    picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [textField setInputView:picker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectedDateWithDatePicker:picker textField:textField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [textField setInputAccessoryView:toolBar];
}

- (void) showSelectedDateWithDatePicker:(UIDatePicker *)picker textField:(UITextField *)textField {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    NSString *dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:picker.date]];
    textField.text = dueDateString;
    [textField resignFirstResponder];
}

@end
