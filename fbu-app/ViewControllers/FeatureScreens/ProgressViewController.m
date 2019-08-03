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
#import "Persona.h"

@interface ProgressViewController () {
    NSInteger completedCount;
    NSInteger overdueCount;
    
    NSInteger houseCompletedCount;
    NSInteger houseOverdueCount;
    
    NSArray *housemates;
}

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *yourProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *yourOverdueLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseOverdueLabel;
@property (weak, nonatomic) IBOutlet UIButton *keyButton;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    completedCount = 0;
    overdueCount = 0;
    houseCompletedCount = 0;
    houseOverdueCount = 0;
    housemates = [[NSArray alloc] init];
    
    [self setYourProgress];
    [self findHousematesAndSetProgress];
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
            [self setYourCompletedLabels];
        }
    }];
    
    // query for reminders that you've received that are overdue
    PFQuery *queryOverdue = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryOverdue includeKey:@"reminderReceiver"];
    [queryOverdue includeKey:@"completed"];
    
    [queryOverdue whereKey:@"reminderReceiver" equalTo:[PFUser currentUser][@"persona"]];
    [queryOverdue whereKey:@"completed" equalTo:@NO];
    // checks if overdue
    [queryOverdue whereKey:@"reminderDueDate" lessThan:[NSDate date]];
    [queryOverdue findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            overdueCount = [reminders count];
            [self setYourOverdueLabels];
        }
    }];
}

- (void) setYourCompletedLabels {
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
        self.yourProgressLabel.text = progressText;
    } else {
        self.yourProgressLabel.text = @"No data!";
    }
}
     
 - (void) setYourOverdueLabels {
     NSString *overdueText = @"";
     if (overdueCount > 0) {
         for (int i = 0; i < overdueCount; i++) {
             overdueText = [overdueText stringByAppendingString:@"🐛"];
         }
         self.yourOverdueLabel.text = overdueText;
     } else {
         self.yourOverdueLabel.text = @"🐝";
     }
 }

// HOUSE PROGRESS
// if they have collectively completed house * 5 reminders, they get a blossom
// if they have collectively completed house * 10 reminders, they get a rosette
// if they have collectively completed house * 15 reminders, they get a hibiscus
// if they have collectively completed house * 20 reminders, they get a sunflower
// if they have house * 5 overdue reminders, they get a wilted flower

- (void) setHouseProgress {
    PFQuery *queryHouseCompleted = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryHouseCompleted includeKey:@"reminderReceiver"];
    [queryHouseCompleted includeKey:@"completed"];
    
    [queryHouseCompleted whereKey:@"reminderReceiver" containedIn:housemates];
    [queryHouseCompleted whereKey:@"completed" equalTo:@YES];
    [queryHouseCompleted findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            houseCompletedCount = [reminders count];
            [self setHouseCompletedLabels];
        }
    }];
    
    // query for reminders that you've received that are overdue
    PFQuery *queryHouseOverdue = [PFQuery queryWithClassName:@"Reminder"];
    
    [queryHouseOverdue includeKey:@"reminderReceiver"];
    [queryHouseOverdue includeKey:@"completed"];
    
    [queryHouseOverdue whereKey:@"reminderReceiver" containedIn:housemates];
    [queryHouseOverdue whereKey:@"completed" equalTo:@NO];
    // checks if overdue
    [queryHouseOverdue whereKey:@"reminderDueDate" lessThan:[NSDate date]];
    [queryHouseOverdue findObjectsInBackgroundWithBlock:^(NSArray *reminders, NSError *error) {
        if (reminders != nil) {
            houseOverdueCount = [reminders count];
            [self setHouseOverdueLabels];
        }
    }];
}

- (void) setHouseCompletedLabels {
    NSString *progressText;
    if (completedCount == 0) {
        progressText = @"No completed reminders!";
    } else if (completedCount < 5) {
        progressText = @"🍃";
    } else if (completedCount >= 5) {
        progressText = @"🌼";
        if (completedCount >= 10) {
            progressText = [progressText stringByAppendingString:@"🏵"];
            if (completedCount >= 15) {
                progressText = [progressText stringByAppendingString:@"🌺"];
                if (completedCount >= 20) {
                    progressText = [progressText stringByAppendingString:@"🌻"];
                }
            }
        }
        self.yourProgressLabel.text = progressText;
    } else {
        self.yourProgressLabel.text = @"No data!";
    }
}

- (void) setHouseOverdueLabels {
    NSString *overdueText = @"";
    if (overdueCount > 5) {
        for (int i = 0; i < overdueCount / 5; i++) {
            overdueText = [overdueText stringByAppendingString:@"🥀"];
        }
        self.yourOverdueLabel.text = overdueText;
    } else {
        self.yourOverdueLabel.text = @"🐝";
    }
}

- (void) findHousematesAndSetProgress {
    Persona *persona = [[PFUser currentUser] objectForKey:@"persona"];
    [persona fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        House *house = [persona objectForKey:@"house"];
        [house fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            housemates = [house objectForKey:@"housemates"];
            [self setHouseProgress];
        }];
    }];
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
