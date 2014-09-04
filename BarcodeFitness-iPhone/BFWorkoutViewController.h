//
//  BFWorkoutViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#define kRestTime @"restTime"
#define kMode @"mode"

@class BFWorkout;
@class BFExercise;
@class BFChooseViewController;


@interface BFWorkoutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) BFWorkout * workout;
@property (nonatomic, strong) NSMutableArray * exercises;
@property (nonatomic, strong) BFChooseViewController * workoutListViewController;

@property (nonatomic, strong) NSDate * workoutBeginTime;
@property (nonatomic, strong) NSDate * timerBeginTime;

@property (nonatomic, strong) UILocalNotification *restTimeEndedNotification;

+ (BOOL) resting;
+ (void) setResting: (BOOL) answer;

+ (int) restTime;
+ (void) setRestTime: (int) answer;
+ (void) saveRestTime; 

+ (int) currentRestTime;
+ (void) setCurrentRestTime: (int) answer;

+ (int) mode;
+ (void) setMode: (int) answer;
+ (void) saveMode;

+ (NSString *)timeFormatted: (int)totalSeconds;
+ (NSString *)timeFormatted2: (int)totalSeconds;
+ (NSString *)timeFormatted3: (int)totalSeconds;

@property (nonatomic) BOOL finishFlag;

@end
