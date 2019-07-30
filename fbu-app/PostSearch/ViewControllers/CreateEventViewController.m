//
//  CreateEventViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/29/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UISwitch *allDaySwitch;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapAddLocation:(id)sender {
    
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
