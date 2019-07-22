//
//  DetailsViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/18/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "DetailsViewController.h"
#import <Parse/Parse.h>

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
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
    self.bioLabel.text = [self.user objectForKey:@"bio"];
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
}

@end
