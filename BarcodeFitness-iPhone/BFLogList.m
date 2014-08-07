//
//  BFLogList.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFLogList.h"

@implementation BFLogList


static NSMutableDictionary * workoutList = nil;
static NSString * currentKey = nil;


+(NSMutableDictionary *)getWorkoutList{
    if (workoutList == nil) {
        workoutList = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kWorkoutList]];
    }
    return workoutList;
}

+(void)setCurrentKey:(NSString *)key{
    currentKey = key;
}

+(NSString *)getCurrentKey{
    return currentKey;
}

+(void)setWorkoutForCurrentKey:(BFWorkout*)workout{
    [self setWorkout:workout forKey:currentKey];
}

+(void)setWorkout:(BFWorkout *)workout forKey:(NSString *)key{
    [workoutList setObject:workout forKey:key];
}

+(void)removeWorkoutForKey:(NSString *)key{
    [workoutList removeObjectForKey:key];
}

+(void)saveWorkoutList{
    [[NSUserDefaults standardUserDefaults] setObject:workoutList forKey:kWorkoutList];
}




@end
