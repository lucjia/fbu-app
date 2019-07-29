//
//  ComposeReminderViewController.m
//  fbu-app
//
//  Created by lucjia on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ComposeReminderViewController.h"
#import "Reminder.h"
#import "Persona.h"
#import "CustomDatePicker.h"

@interface ComposeReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *dueDate;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;
@property (weak, nonatomic) IBOutlet UIButton *addReminderButton;
@property (strong, nonatomic) Persona *receiver;
@property (strong, nonatomic) NSString *dueDateString;

@end

@implementation ComposeReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomDatePicker *dp = [[CustomDatePicker alloc] init];
    self.datePicker = [dp initializeDatePickerWithDatePicker:self.datePicker textField:self.dateSelectionTextField];
    [self initializeTextView];
}

- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}

- (void) showSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    self.dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    self.dateSelectionTextField.text = self.dueDateString;
    [self.dateSelectionTextField resignFirstResponder];
}

- (void) removeDate {
    [self.dateSelectionTextField resignFirstResponder];
    [self.datePicker setDate:[NSDate date] animated:NO];
    self.dateSelectionTextField.text = @"";
}

- (void) initializeTextView {
    self.reminderTextView.layer.borderWidth = 1.5f;
    self.reminderTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.reminderTextView.layer.cornerRadius = 6;
    self.reminderTextView.delegate = self;
}

- (IBAction)didPressAdd:(id)sender {
    // Check if fields are empty OR invalid
    if ([self.recipientTextField.text isEqualToString:@""] || [self.reminderTextView.text isEqualToString:@""]) {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Add Reminder"
                                                                       message:@"Please enter a username or reminder."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // Create a try again action
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
        // query for persona of the user with the given username IN THE HOUSE
        // store text, due date, and recipient, and sender into the Reminder
        PFQuery *query = [PFQuery queryWithClassName:@"Persona"];
        [query includeKey:@"persona"];
        
        // query for Persona that is the recipient
        [query whereKey:@"username" equalTo:self.recipientTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *recipient, NSError *error) {
            if (recipient != nil) {
                self.receiver = [recipient objectAtIndex:0];
                
                NSDate *dueDate = self.datePicker.date;
                // only store due date if set
                if (!self.dueDateString) {
                    dueDate = nil;
                }
                
                [Reminder createReminder:self.receiver text:self.reminderTextView.text dueDate:dueDate dueDateString:self.dueDateString withCompletion:nil];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
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
