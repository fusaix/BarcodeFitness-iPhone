//
//  BFExerciseViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFExercise;
@class BFSet;

@interface BFExerciseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
//, UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property BFExercise * exercise;
@property (nonatomic, strong) NSMutableArray * sets;
@property (nonatomic, strong) BFSet * set;


@end
