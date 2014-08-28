//
//  BFExerciseListViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/19/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFWorkoutViewController;

@interface BFExerciseListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * exercises;
@property (nonatomic, strong) BFWorkoutViewController * exerciseListViewController;
@property (nonatomic) int wIndex;

@end
