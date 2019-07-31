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
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) NSString *dueDateString;

@end

@implementation ReminderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.senderLabel.text = self.reminder.reminderSender[@"firstName"];
    self.reminderTextView.text = self.reminder.reminderText;
    self.dateField.text = self.reminder.dueDateString;
    
    CustomDatePicker *dp = [[CustomDatePicker alloc] init];
    self.datePicker = [dp initializeDatePickerWithDatePicker:self.datePicker textField:self.dateField];
    [self initializeTextView];
    
    // hide edit button if editing is locked
    if (self.reminder.lockEditing) {
        self.editButton.hidden = YES;
        self.deleteButton.hidden = YES;
    }
}

- (void) initializeTextView {
    self.reminderTextView.layer.borderWidth = 1.5f;
    self.reminderTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.reminderTextView.layer.cornerRadius = 6;
    self.reminderTextView.delegate = self;
}

- (void) showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    self.dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    self.dateField.text = self.dueDateString;
    [self.dateField resignFirstResponder];
}

- (void) removeDate {
    [self.dateField resignFirstResponder];
    [self.datePicker setDate:[NSDate date] animated:NO];
    self.dateField.text = @"";
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didPressEdit:(id)sender {
    // Check if fields are empty OR invalid
    if ([self.reminderTextView.text isEqualToString:@""]) {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Edit Reminder"
                                                                       message:@"This reminder is locked for editing."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // Create a dismiss action
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // Handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
        // Add the cancel action to the alertController
        [alert addAction:dismissAction];
        alert.view.tintColor = [UIColor redColor];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // save new reminder
        PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
        [query getObjectInBackgroundWithId:self.reminder[@"objectId"]
                                     block:^(PFObject *reminder, NSError *error) {
                                         reminder = self.reminder;
                                         reminder[@"reminderText"] = self.reminderTextView.text;
                                         if (![reminder[@"dueDateString"] isEqualToString:self.dateField.text]) {
                                             reminder[@"reminderDueDate"] = self.datePicker.date;
                                             reminder[@"dueDateString"] = self.dateField.text;
                                         }
                                         [reminder saveInBackground];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }];
    }
}

- (IBAction)didPressDelete:(id)sender {
    // Are you sure? alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Reminder?"
                                                                   message:@"This action cannot be undone."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              // delete reminder and go back to reminder list
                                                              [self.reminder deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }];
                                                          }];
    UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              // Handle cancel response here. Doing nothing will dismiss the view.
                                                          }];
    // Add the cancel action to the alertController
    [alert addAction:agreeAction];
    [alert addAction:disagreeAction];
    alert.view.tintColor = [UIColor redColor];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
