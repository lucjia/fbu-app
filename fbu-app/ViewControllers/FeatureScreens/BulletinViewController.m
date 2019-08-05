//
//  BulletinViewController.m
//  fbu-app
//
//  Created by lucjia on 8/1/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "BulletinViewController.h"

@interface BulletinViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation BulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImage.image = [UIImage imageNamed:@"corkboard"];
    self.backgroundImage.clipsToBounds = YES;
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
