//
//  ComposeReminderViewController.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ComposeReminderViewController.h"

@interface ComposeReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;

@end

@implementation ComposeReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDatePicker];
    [self initializeTextView];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) initializeTextView {
    self.reminderTextView.layer.borderWidth = 1.5f;
    self.reminderTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.reminderTextView.layer.cornerRadius = 6;
    self.reminderTextView.delegate = self;
}
    
- (void) initializeDatePicker {
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [self.dateSelectionTextField setInputView:self.datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateSelectionTextField setInputAccessoryView:toolBar];
}

- (void) showSelectedDate {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    self.dateSelectionTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
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
