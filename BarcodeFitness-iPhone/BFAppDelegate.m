//
//  BFAppDelegate.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFAppDelegate.h"
#import "BFExerciseList.h"
#import "BFWorkoutViewController.h"

@implementation BFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Import data models
//    [BFWorkoutList getWorkoutTemplates];
    
    return YES;
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Sync data with network (to be scheduled)
    
    // And store in persistent data if posssible
    [BFExerciseList loadExercisesFromNetwork];
    // remove badge
    application.applicationIconBadgeNumber = 0;
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - Badge notification 

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ rest time is finished!", [BFWorkoutViewController timeFormatted2:[BFWorkoutViewController currentRestTime]]]
                                                    message:@"Ready for next set?"
                                                   delegate:self
                                          cancelButtonTitle:@"Yes, Sir!"
                                          otherButtonTitles:nil];
    [alert show];
    
    // make sound
    AudioServicesPlaySystemSound(1012); // see http://iphonedevwiki.net/index.php/AudioServices
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // make sound
//        AudioServicesPlaySystemSound(1112); // see http://iphonedevwiki.net/index.php/AudioServices
        // remove badge
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        // Stop timer
        [BFWorkoutViewController setResting:NO];
    }
}


@end
