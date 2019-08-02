//
//  ProgressViewController.m
//  fbu-app
//
//  Created by lucjia on 7/31/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ProgressViewController.h"
#import "ReminderViewController.h"
#import "Parse/Parse.h"

@interface ProgressViewController () {
    NSInteger completedCount;
    NSInteger overdueCount;
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *yourProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourOverdueLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyButton;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    completedCount = 0;
    overdueCount = 0;
    
    [self setYourProgress];
}

- (IBAction)didPressBack:(id)sender {
    UITabBarController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostSearchTabBar"];
    
    [viewController setSelectedIndex:1];
    [self presentViewController:viewController animated:YES completion:nil];
}

// INDIVIDUAL PROGRESS
// if they have completed 5 reminders, they get a seedling
// if they have completed 10 reminders, they get an herb
// if they have completed 15 reminders, they get a tulip
// if they have completed 20 reminders, they get a rose
// if they have ANY overdue reminders, they get a bug
// if they have NO overdue reminders, they get a bee

- (void) setYourProgress {
    // query for reminders that you've received that are completed
    PFQuery *queryCompleted = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryCompleted includeKey:@"reminderReceiver"];
    [queryCompleted includeKey:@"completed"];
    
    [queryCompleted whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [queryCompleted whereKey:@"completed" equalTo:@YES];
    [queryCompleted findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            completedCount = [reminders count];
            
            NSString *progressText;
            if (completedCount == 0) {
                progressText = @"No completed reminders!";
            } else if (completedCount < 5) {
                progressText = @"🍃";
            } else if (completedCount >= 5) {
                progressText = @"🌱";
                if (completedCount >= 10) {
                    progressText = [progressText stringByAppendingString:@"🌿"];
                    if (completedCount >= 15) {
                        progressText = [progressText stringByAppendingString:@"🌷"];
                        if (completedCount >= 20) {
                            progressText = [progressText stringByAppendingString:@"🌹"];
                        }
                    }
                }
            }
            self.yourProgressLabel.text = progressText;
        } else {
            NSLog(@"%@", error.localizedDescription);
            self.yourProgressLabel.text = @"No data!";
        }
    }];
    
    // query for reminders that you've received that are overdue
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    
    [query includeKey:@"reminderReceiver"];
    [query includeKey:@"completed"];
    
    [query whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [query whereKey:@"completed" equalTo:@NO];
    // checks if overdue
    [query whereKey:@"reminderDueDate" lessThan:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            overdueCount = [reminders count];
            
            NSString *overdueText = @"";
            if (overdueCount > 0) {
                for (int i = 0; i < overdueCount; i++) {
                    overdueText = [overdueText stringByAppendingString:@"🐛"];
                }
                self.yourOverdueLabel.text = overdueText;
            } else {
                self.yourOverdueLabel.text = @"🐝";
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            self.yourOverdueLabel.text = @"No data!";
        }
    }];
}

// HOUSE PROGRESS
// if they have collectively completed house * 5 reminders, they get a rosette
// if they have collectively completed house * 10 reminders, they get a blossom
// if they have collectively completed house * 15 reminders, they get a hibiscus
// if they have collectively completed house * 20 reminders, they get a sunflower
// if they have house * 5 overdue reminders, they get a wilted flower

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
