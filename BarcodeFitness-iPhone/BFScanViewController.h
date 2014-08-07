//
//  BFScanViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/29/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class BFWorkoutViewController;
@class BFExercise;


@interface BFScanViewController : UIViewController  <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) BFWorkoutViewController * exerciseListViewController;
@property (nonatomic, strong) BFExercise * exercise;
@property (nonatomic) int wIndex;
//@property (nonatomic, strong) NSString * segueIdentifier;


@end
