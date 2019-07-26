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

@interface ComposeReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *recipientTextField;
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;
@property (weak, nonatomic) IBOutlet UIButton *addReminderButton;
@property (strong, nonatomic) Persona *receiver;
@property (strong, nonatomic) NSString *dueDateString;

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
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, MMMM d, yyyy h:mm a"];
    self.dueDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]];
    self.dateSelectionTextField.text = self.dueDateString;
    [self.dateSelectionTextField resignFirstResponder];
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
                [Reminder createReminder:self.receiver text:self.reminderTextView.text dueDate:self.datePicker.date dueDateString:self.dueDateString withCompletion:nil];
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
