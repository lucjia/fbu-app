//
//  MainViewController.m
//  fbu-app
//
//  Created by jordan487 on 7/25/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    UIBlurEffect *leftViewBackgroundBlurEffect;
    UIBlurEffect *rightViewBackgroundBlurEffect;
    
    UIBlurEffect *rootViewCoverBlurEffectForLeftView;
    UIBlurEffect *rootViewCoverBlurEffectForRightView;
    
    UIBlurEffect *leftViewCoverBlurEffect;
    UIBlurEffect *rightViewCoverBlurEffect;
    
    UIBlurEffectStyle regularStyle;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSideMenu];
}

- (void)setupSideMenu {
    regularStyle = UIBlurEffectStyleRegular;
    
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
    self.rootViewCoverBlurEffectForLeftView = [UIBlurEffect effectWithStyle:regularStyle];
    self.rootViewCoverAlphaForLeftView = 0.8;
    
    self.rightViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
    self.rootViewCoverBlurEffectForRightView = [UIBlurEffect effectWithStyle:regularStyle];
    self.rootViewCoverAlphaForRightView = 0.8;
}

@end
