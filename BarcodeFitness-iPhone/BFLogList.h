//
//  BFLogList.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWorkoutList @"workouts"

@class BFWorkout;


@interface BFLogList : NSObject


+(NSMutableDictionary *)getWorkoutList;
+(void)setCurrentKey:(NSString *)key;
+(NSString *)getCurrentKey;
+(void)setWorkoutForCurrentKey:(BFWorkout*)workout;
+(void)setWorkout:(BFWorkout *)workout forKey:(NSString *)key;
+(void)removeWorkoutForKey:(NSString *)key;
+(void)saveWorkoutList;


@end
