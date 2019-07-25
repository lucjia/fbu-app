//
//  AppDelegate.m
//  fbu-app
//
//  Created by lucjia on 7/15/19.
//  Copyright © 2019 lucjia. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "RulesViewController.h"
#import "RegisterViewController.h"
#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "TimelineViewController.h"
#import "SettingsViewController.h"
#import "House.h"
@import GoogleMaps;
@import GooglePlaces;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Parse to point to own server
    ParseClientConfiguration *config = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://fbura.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    
    
    NSString *username = @"elon";
    NSString *password = @"elon";
    [PFUser logInWithUsername:username password:password];

  

    // Cache logged in user for a persisting user session
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchingTabBarController"];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"HousematesViewController"];
//        self.window.backgroundColor = [UIColor whiteColor];
//        SettingsVierwController *settingsVC = [[SettingsViewController alloc] init];
//        self.window.rootViewController = settingsVC;
    }
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
