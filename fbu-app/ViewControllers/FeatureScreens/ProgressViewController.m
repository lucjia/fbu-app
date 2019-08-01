//
//  ProgressViewController.m
//  fbu-app
//
//  Created by lucjia on 7/31/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "ProgressViewController.h"
#import "ReminderViewController.h"

@interface ProgressViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didPressBack:(id)sender {
    ReminderViewController *reminderVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReminderVC"];
    [self presentViewController:reminderVC animated:YES completion:nil];
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
