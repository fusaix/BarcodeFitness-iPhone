//
//  BFWorkout.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFWorkout : NSObject
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) image
@property (nonatomic, strong) NSString *description; // subtitle of cells in Launcher
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic) int duration;
@property (nonatomic) float density;
@property (nonatomic, strong) NSString *note; 


@property (nonatomic) int row; 


- (id) initWithName: (NSString*) name; 

@end
