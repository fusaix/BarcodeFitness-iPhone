//
//  BFExerciseViewControllerCell.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/6/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BFTableViewCellDelegate.h"
//#import <QuartzCore/QuartzCore.h>

@interface BFExerciseViewControllerCell : UITableViewCell <UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

//@property (nonatomic, strong) UITextField *text;
@property (nonatomic, strong) NSNumber *setNumber;
//@property (nonatomic, strong) UILabel *lbl;

// The object that acts as delegate for this cell.
//@property (nonatomic, assign) id<BFTableViewCellDelegate> delegate;

@end
