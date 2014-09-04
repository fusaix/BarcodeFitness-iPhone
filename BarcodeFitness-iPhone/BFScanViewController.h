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

@interface BFScanViewController : UIViewController  <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) BFWorkoutViewController * exerciseListViewController;
@property (nonatomic) int wIndex;


@end
