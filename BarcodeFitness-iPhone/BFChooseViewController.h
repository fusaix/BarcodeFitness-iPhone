//
//  BFChooseViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define kWorkoutTemplates @"workoutTemplates"

@interface BFChooseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * workoutTemplates; // corresponds to _objects in a master detail template. Here it is public to let BFAddWorkoutViewController do the job. 

@end
