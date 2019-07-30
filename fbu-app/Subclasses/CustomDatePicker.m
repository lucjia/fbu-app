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
@property (strong, nonatomic) NSDate *pickedDate;

@end

@implementation CustomDatePicker

- (UIDatePicker *) initializeDatePickerWithDatePicker:(UIDatePicker *)picker textField:(UITextField *)textField {
    
    picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDateAndTime;
    [textField setInputView:picker];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.datePicker = picker;
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] init];
    doneBtn.title = @"Done";
    doneBtn.action = @selector(showSelectedDate);
    UIBarButtonItem *clearBtn = [[UIBarButtonItem alloc] init];
    clearBtn.title = @"Clear";
    clearBtn.action = @selector(removeDate);
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:clearBtn, space, doneBtn, nil]];
    toolBar.userInteractionEnabled = YES;
    [textField setInputAccessoryView:toolBar];
    
    return self.datePicker;
}

@end