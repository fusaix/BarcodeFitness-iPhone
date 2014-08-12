//
//  BFExerciseViewControllerCell.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/6/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFSet;

@interface BFExerciseViewControllerCell : UITableViewCell <UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) int sIndex;
@property (nonatomic) int eIndex;
@property (nonatomic) int wIndex;
@property (nonatomic, strong) BFSet * set;

@end
