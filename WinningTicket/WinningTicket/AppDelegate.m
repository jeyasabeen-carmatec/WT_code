//
//  AppDelegate.m
//  WinningTicket
//
//  Created by Test User on 22/02/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "AppDelegate.h"
//#import <Braintree/Braintree.h>
#import "BraintreeCore.h"
#import <UserNotifications/UserNotifications.h>
@import GoogleMaps;
@import GooglePlaces;

//@interface AppDelegate : UIResponder   <UIApplicationDelegate,UNUserNotificationCenterDelegate>

//@end

@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    UIStoryboard *storyboard;
//    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
//        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    } else {
//        storyboard = [UIStoryboard storyboardWithName:@"Main~ipad" bundle:nil];
//    }
//    
//    UIViewController *vc = [storyboard instantiateInitialViewController];
    
    // Set root view controller and make windows visible
//    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor lightGrayColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_WT"]];
    [self.window makeKeyAndVisible];
    
    
    if(SYSTEM_VERSION_EQUAL_TO(@"10.0")){
        UNUserNotificationCenter *notifiCenter = [UNUserNotificationCenter currentNotificationCenter];
        notifiCenter.delegate = self;
        [notifiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else
    {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    
    
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    [BTAppSwitch setReturnURLScheme:@"com.carmatec.WinningTicket.payments"];
    [GMSServices provideAPIKey:@"AIzaSyBZeXhmDv-aXK7fZGZFpECx1NOC7cZFR_Q"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyBZeXhmDv-aXK7fZGZFpECx1NOC7cZFR_Q"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.carmatec.WinningTicket.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
    return NO;
}

// If you support iOS 7 or 8, add the following method.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.carmatec.WinningTicket.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
    return NO;
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

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings: (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString   *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
    
    NSLog(@"User info appdeliigate = %@",userInfo);
}
#else
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
}
#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
    
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUInteger lenthtotes = [token length];
    NSUInteger req = 64;
    if (lenthtotes == req) {
        NSLog(@"uploaded token: %@", token);
        
        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"DEV_TOK"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSNotification *notif = [NSNotification notificationWithName:@"NEW_TOKEN_AVAILABLE" object:token];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
    
    
    
}


@end
