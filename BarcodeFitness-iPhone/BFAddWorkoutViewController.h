//
//  BFAddWorkoutViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFChooseViewController;
@class BFWorkout;

@interface BFAddWorkoutViewController : UITableViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) BFChooseViewController * workoutListViewController;
@property (nonatomic, strong) BFWorkout * workout;
@property (nonatomic, strong) NSString * segueIdentifier;
@property (nonatomic) int renameRow;


@end
