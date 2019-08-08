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
#import "UserCollectionCell.h"
#import "House.h"
#import "CustomColor.h"
#import "Accessibility.h"

@interface ComposeReminderViewController () <UICollectionViewDelegate, UICollectionViewDataSource> {
    Persona *recipient;
}

@property (weak, nonatomic) IBOutlet UITextField *dateSelectionTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *dueDate;
@property (weak, nonatomic) IBOutlet UITextView *reminderTextView;
@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;
@property (weak, nonatomic) IBOutlet UIButton *addReminderButton;
@property (strong, nonatomic) Persona *receiver;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *dueDateString;
@property (strong, nonatomic) NSMutableArray *housemates;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (strong, nonatomic) UserCollectionCell *previousCell;
@property (assign, nonatomic) NSInteger cellHeight;
@property (weak, nonatomic) IBOutlet UISwitch *lockEditingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lockEditingLabel;

@end

@implementation ComposeReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self fetchHousemates];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    CGFloat photosPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing*(photosPerLine - 1)) / photosPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.cellHeight = (NSInteger) (itemHeight);
    
    // To be able to click in the collection view and click to dismiss the keyboard
    self.tap.cancelsTouchesInView = NO;
    self.previousCell = [[UserCollectionCell alloc] init];
    
    self.lockEditingSwitch.onTintColor = [CustomColor accentColor:1.0];
    
    CustomDatePicker *dp = [[CustomDatePicker alloc] init];
    self.datePicker = [dp initializeDatePickerWithDatePicker:self.datePicker textField:self.dateSelectionTextField];
    [self initializeTextView];
    
    // set tint color of all text fields and views
    [[UITextField appearance] setTintColor:[CustomColor accentColor:1.0]];
    [[UITextView appearance] setTintColor:[CustomColor accentColor:1.0]];
    
    self.addReminderButton.layer.cornerRadius = 5;
    self.addReminderButton.layer.masksToBounds = YES;
    
    [self initializeLargeTextCompatibility];
    
    // get notification if font size is changed from settings accessibility
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}

// change font size based on accessibility setting
- (void)preferredContentSizeChanged:(NSNotification *)notification {
}

- (void) initializeLargeTextCompatibility {
    [Accessibility largeTextCompatibilityWithView:self.reminderTextView style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.recipientLabel style:UIFontTextStyleHeadline];
    [Accessibility largeTextCompatibilityWithField:self.dateSelectionTextField style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.addReminderButton.titleLabel style:UIFontTextStyleBody];
    [Accessibility largeTextCompatibilityWithLabel:self.lockEditingLabel style:UIFontTextStyleBody];
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
    self.reminderTextView.layer.borderWidth = 0.5f;
    self.reminderTextView.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
    self.reminderTextView.layer.cornerRadius = 5;
    self.reminderTextView.delegate = self;
    
    if ([self.reminderTextView.text isEqualToString:@""]) {
        self.reminderTextView.text = @"Write a reminder...";
        self.reminderTextView.textColor = [CustomColor midToneTwo:1.0];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.reminderTextView.text isEqualToString:@"Write a reminder..."]) {
        self.reminderTextView.text = @"";
        self.reminderTextView.textColor = [CustomColor midToneOne:1.0];
    }
    [self.reminderTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.reminderTextView.text isEqualToString:@""]) {
        self.reminderTextView.text = @"Write a reminder...";
        self.reminderTextView.textColor = [CustomColor midToneTwo:1.0];
    }
    [self.reminderTextView resignFirstResponder];
}


- (IBAction)didPressAdd:(id)sender {
    // Check if fields are empty OR invalid
    if ([self.recipientLabel.text isEqualToString:@""] || [self.reminderTextView.text isEqualToString:@""]) {
        // Create alert to display error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Add Reminder"
                                                                       message:@"Please enter a username or reminder."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        // Create a dismiss action
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // Handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
        // Add the cancel action to the alertController
        [alert addAction:dismissAction];
        alert.view.tintColor = [CustomColor accentColor:1.0];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // query for persona of the user with the given username IN THE HOUSE
        // store text, due date, and recipient, and sender into the Reminder
        PFQuery *query = [PFQuery queryWithClassName:@"Persona"];
        [query includeKey:@"persona"];
        
        // query for Persona that is the recipient
        [query whereKey:@"username" equalTo:recipient.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *recipient, NSError *error) {
            if (recipient != nil) {
                self.receiver = [recipient objectAtIndex:0];
                
                NSDate *dueDate = self.datePicker.date;
                // only store due date if set
                if (!self.dueDateString) {
                    dueDate = nil;
                }
                
                Reminder *newRem = [Reminder createReminder:self.receiver text:self.reminderTextView.text dueDate:dueDate dueDateString:self.dueDateString lockEditing:self.lockEditingSwitch.isOn withCompletion:nil];
                
                [self.delegate refreshWithNewReminder:newRem];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCell" forIndexPath:indexPath];
    
    Persona *persona = self.housemates[indexPath.row];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *imageFile = persona.profileImage;
        [imageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                cell.profileView.image = [UIImage imageWithData:data];
                cell.profileView.alpha = 0.5;
            }
        }];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.housemates.count;
}

- (void) fetchHousemates {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [persona objectForKey:@"house"];
        [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.housemates = [house objectForKey:@"housemates"];
            [self.collectionView reloadData];
        }];
    }];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    recipient = self.housemates[indexPath.item];
    
    // change alpha to 1.0 and have alpha of last selection return to 0.5
    self.previousCell.profileView.alpha = 0.5;
    
    UserCollectionCell *tappedCell = [self.collectionView cellForItemAtIndexPath:(indexPath)];
    self.previousCell = tappedCell;
    tappedCell.profileView.alpha = 1.0;
    self.recipientLabel.text = [[recipient.firstName stringByAppendingString:@" "] stringByAppendingString:recipient.lastName];
}

@end
