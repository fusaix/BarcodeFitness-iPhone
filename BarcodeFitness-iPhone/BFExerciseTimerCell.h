//
//  BFExerciseTimerCell.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/20/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFWorkoutViewController;


@interface BFExerciseTimerCell : UITableViewCell <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic,strong) NSTimer *restTimer;
@property (nonatomic, strong) UILabel * theOtherTextLabel;
@property (nonatomic, strong) BFWorkoutViewController * exerciseListViewController;
@property (nonatomic) int timeCount;


@end
