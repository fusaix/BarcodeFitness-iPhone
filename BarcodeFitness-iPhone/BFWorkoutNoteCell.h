//
//  BFWorkoutNoteCell.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/29/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFWorkout;

@interface BFWorkoutNoteCell : UITableViewCell <UITextViewDelegate>
@property (nonatomic) int wIndex;
@property (nonatomic, strong) BFWorkout * workout;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
