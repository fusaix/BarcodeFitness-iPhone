//
//  BFWorkoutViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFWorkout;
@class BFExercise;

@interface BFWorkoutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) BFWorkout * workout;
@property (nonatomic, strong) NSMutableArray * exercises;

@end
