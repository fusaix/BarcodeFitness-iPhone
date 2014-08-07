//
//  BFNetworkLoader.h
//  BarcodeFitness-iPhone
//
//  Created by Christian Botkin on 7/31/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFExercise.h"
#import "BFWorkout.h"
#import "BFUser.h"

@interface BFNetworkExercises : NSObject

+(NSArray *)getExercises;
+(void)loadExercisesFromNetwork;
+(void)loadExercisesFromStorage;

+(NSArray *)getWorkoutHistory;
+(void)loadWorkoutHistoryFromNetworkForUser:(BFUser *)user;
+(void)loadWorkoutHistoryFromStorageForUser:(BFUser *)user;

@end
