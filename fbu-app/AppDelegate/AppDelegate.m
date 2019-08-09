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
#import "Reminder.h"
#import "ReminderViewController.h"
#import "UserNotifications/UserNotifications.h"
#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>
#import "MainViewController.h"

@interface AppDelegate () <UIApplicationDelegate, UNUserNotificationCenterDelegate> {
    NSArray *receivedReminders;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize Parse to point to own server
    ParseClientConfiguration *config = [ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"myAppId";
        configuration.server = @"https://fbura.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];  

    // Cache logged in user for a persisting user session
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"PostSearchSideMenuController"];
        
        [PFInstallation.currentInstallation setValue:PFUser.currentUser[@"username"] forKey:@"user"];
        [PFInstallation.currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (error) {
                NSLog(@"ERROR with NOTIFICATIONS in AppDelegate");
            } else {
                [self setUpNotificationCenter];
            }
        }];
    }
    
    return YES;
}

- (void) setUpNotificationCenter {
    // Notification center
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if( !error ) {
            // required to get the app to do anything at all about push notifications
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
            NSLog( @"Push registration success." );
            
            // to show actions on the push notifications
            UNNotificationCategory* generalCategory = [UNNotificationCategory
                                                       categoryWithIdentifier:@"GENERAL"
                                                       actions:@[]
                                                       intentIdentifiers:@[]
                                                       options:UNNotificationCategoryOptionCustomDismissAction];
            
            // Create the custom actions for expired timer notifications.
            UNNotificationAction* snoozeAction = [UNNotificationAction
                                                  actionWithIdentifier:@"SNOOZE_ACTION"
                                                  title:@"Snooze"
                                                  options:UNNotificationActionOptionNone];
            
            UNNotificationAction* stopAction = [UNNotificationAction
                                                actionWithIdentifier:@"STOP_ACTION"
                                                title:@"Stop"
                                                options:UNNotificationActionOptionForeground];
            
            // Create the category with the custom actions.
            UNNotificationCategory* expiredCategory = [UNNotificationCategory
                                                       categoryWithIdentifier:@"TIMER_EXPIRED"
                                                       actions:@[snoozeAction, stopAction]
                                                       intentIdentifiers:@[]
                                                       options:UNNotificationCategoryOptionNone];
            
            // Register the notification categories.
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            [center setNotificationCategories:[NSSet setWithObjects:generalCategory, expiredCategory,
                                               nil]];
            
        } else {
            NSLog( @"Push registration FAILED" );
            NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
            NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
        }
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog( @"Handle push from foreground" );
    // custom code to handle push while app is in the foreground
    [PFPush handlePush:notification.request.content.userInfo];
    NSLog(@"%@", notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
    NSLog(@"%@", response.notification.request.content.userInfo);
    
    // Increment badge number
    [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *const installation = PFInstallation.currentInstallation;
    // Add a user column to Parse's Installation object which holds a pointer to the user
    installation[@"user"] = [PFUser currentUser][@"username"];
    [installation setDeviceTokenFromData:deviceToken];
    [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR with NOTIFICATIONS in AppDelegate");
        } else {
            [installation setValue:@[PFUser.currentUser[@"username"]] forKey:@"channels"];
            [installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                }
            }];
        }
    }];
    
    ReminderViewController *reminderVC = [[ReminderViewController alloc] init];
    [reminderVC queryForReminders];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    // Check to make sure it's the correct activity type
    if ([userActivity.activityType isEqualToString:@"com.lucjia-edrisian.fbu-app.openReminder"]) {
        // Extract the remote ID from the user info
        NSString* id = [userActivity.userInfo objectForKey:@"ID"];
        
        // Restore the remote screen...
        if (PFUser.currentUser) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostSearch" bundle:nil];
            LGSideMenuController *leftMenu = [storyboard instantiateViewControllerWithIdentifier:@"PostSearchLeftViewController"];
            MainViewController *mainViewController = (MainViewController *)leftMenu.sideMenuController;

            
            UITabBarController *rootView = (UITabBarController *)mainViewController.rootViewController;
            
            UITabBarController *tabBarController = (UITabBarController *)mainViewController.rootViewController;
            UINavigationController *currentController = tabBarController.selectedViewController;
            
            [rootView setSelectedIndex:1];
            [currentController presentViewController:mainViewController animated:YES completion:nil];
            
//            self.window.rootViewController = sideMenuController;
//            [currentController presentViewController:sideMenuController animated:YES completion:nil];
        }
        
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(nonnull NSString *)userActivityType {
    application.userActivity = [[NSUserActivity alloc] initWithActivityType:userActivityType];
    application.delegate = self;
    
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
    // Removes badge
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
