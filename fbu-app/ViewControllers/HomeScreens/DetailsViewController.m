//
//  DetailsViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/18/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "DetailsViewController.h"
#import <Parse/Parse.h>
#import "RoommateCell.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestButton;
@property (weak, nonatomic) IBOutlet UILabel *preferencesLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateProperties];
    
}

// sets properties to values corresponding to user
- (void)updateProperties{
    NSData *imageData = [[self.user objectForKey:@"profileImage"] getData];
    self.profileImage.image = [[UIImage alloc] initWithData:imageData];
    
    NSString *firstName = [self.user objectForKey:@"firstName"];
    NSString *lastName = [self.user objectForKey:@"lastName"];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    self.fullNameLabel.text = fullName;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", [self.user objectForKey:@"username"]];
    self.locationLabel.text = [self.user objectForKey:@"city"];
    self.bioLabel.text = [self.user objectForKey:@"bio"];
    NSArray *preferencesArray = [self.user objectForKey:@"preferences"];;
    NSString *preferencesString = [preferencesArray componentsJoinedByString:@", \n"];
    
    self.preferencesLabel.text = preferencesString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTapSendRequest:(id)sender {
    Persona *senderPersona = [[PFUser currentUser] objectForKey:@"persona"];
    NSMutableArray *requestsSent = [senderPersona objectForKey:@"requestsSent"];
    Persona *receiverPersona = self.user;
    [receiverPersona fetchIfNeeded];
    
    if ([requestsSent containsObject:receiverPersona] == NO) {
        [RoommateCell sendRequestToPersona:receiverPersona sender:senderPersona requestsSentToUsers:requestsSent allertReceiver:self];
    } else {
        [self createAlertController:@"Error sending request" message:@"You've already sent this user a request!"];
    }
    
}

- (void)createAlertController:(NSString *)title message:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

@end
