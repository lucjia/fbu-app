//
//  ReminderDetailViewController.m
//  fbu-app
//
//  Created by lucjia on 7/26/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ReminderDetailViewController.h"
#import "CustomDatePicker.h"

@interface ReminderDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation ReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.senderLabel.text = self.reminder.reminderSender[@"firstName"];
    self.reminderTextView.text = self.reminder.reminderText;
    self.dateField.text = self.reminder.dueDateString;
    
    //  Think of a way to reuse the date picker code, which will then come in handy for the calendar view
    // Make sure that the datepicker starts out on the date that is initially set
    
}

- (void) initializeTextView {
    self.reminderTextView.layer.borderWidth = 1.5f;
    self.reminderTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.reminderTextView.layer.cornerRadius = 6;
    self.reminderTextView.delegate = self;
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
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
