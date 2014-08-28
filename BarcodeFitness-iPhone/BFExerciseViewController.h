//
//  BFExerciseViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFChooseViewController;
@class BFWorkoutViewController;

@interface BFExerciseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * sets;
@property (nonatomic) int totalNumberOfExercises;
@property (nonatomic) int currentExerciseNumber;
@property (nonatomic) int wIndex;
@property (nonatomic, strong) BFChooseViewController * workoutListViewController;
@property (nonatomic, strong) BFWorkoutViewController * exerciseListViewController;

@end
