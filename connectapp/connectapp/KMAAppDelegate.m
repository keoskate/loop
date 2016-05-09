//
//  KMAAppDelegate.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/3/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <Parse/Parse.h>
#import "KMAAppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import "Mixpanel.h"
#define MIXPANEL_TOKEN @"9ed3003ebccc7cd883383bcbb46b43d0"


@implementation KMAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKLoginButton class];
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"ZsXOhEDjGOZXmP4eA0kWvOCUEywvGbo65vvirBdD"
                  clientKey:@"NhONajvTcZfylI29SVs3Tk46vuCl2940YaAf95gF"];

    [PFImageView class];

    //privacy ACL
    PFACL *defaultACL = [PFACL ACL];
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }

    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeSound)];
    }
    
    
    [self setUpUI];

    //set up mixpanel
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN launchOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    //PFInstallation *currentInstallation = [PFInstallation currentInstallation];
       //currentInstallation.channels = @[ @"global" ];
    [[PFInstallation currentInstallation] setDeviceTokenFromData:deviceToken];
    [[PFInstallation currentInstallation] saveEventually];
    //[currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
#warning 1
//Set up tab bar
-(void)setUpUI {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.09 green:0.73 blue:0.98 alpha:1.0]];
    //[ UIColor colorWithRed:0.0f green:190.0f blue:255.0f alpha:1.0f]];
    //[UIColor colorWithRed:24.0f/255.0f green:186.0f/255.0f blue:249.0f/255.0f alpha:1.0]
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem5 = [tabBar.items objectAtIndex:4];
    
    //    [[tabBarController.view.subviews objectAtIndex:0] setFrame:CGRectMake(0, 0, 320, 440)];
    //    [tabBarController.tabBar setFrame:CGRectMake(0, 440, 320, 50)];
    //
    tabBarItem1.title = @"Search";
    tabBarItem2.title = @"Notifications";
    tabBarItem3.title = @"Profile";
    tabBarItem4.title = @"Contact";
    tabBarItem5.title = @"Settings";
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"searchActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"search"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"notificationsActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"notifications"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"profileActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"profile"]];
    [tabBarItem4 setFinishedSelectedImage:[UIImage imageNamed:@"contactsActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"contacts"]];
    [tabBarItem5 setFinishedSelectedImage:[UIImage imageNamed:@"settingsActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings"]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *temp = [url absoluteString];
    if ([temp containsString:@"fb"]) {
        NSLog(@"fb-deeplink");
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }else if([temp containsString:@"li"]){
        if ([LISDKCallbackHandler shouldHandleUrl:url]) {
            NSLog(@"li-deeplink");
            return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        }
    }
    return YES;

}


@end
