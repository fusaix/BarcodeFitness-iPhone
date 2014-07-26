//
//  BFWorkoutList.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWorkoutTemplatesRepresentation @"workoutTemplatesRepresentation"


@class BFWorkout;

@interface BFWorkoutList : NSObject

+(NSMutableArray *)getWorkoutTemplates;
+(void)setWorkoutName: (NSString *) name atIndex: (int) index;
// + (void)setWorkoutImage: (UIImage *) image atIndex: (int) index;
+(void)insertObject:(BFWorkout *)workout atIndex:(int)index;
+(void)addObject:(BFWorkout *)workout;
+(void)removeObjectAtIndex:(int)index;
+(void)saveToStandardUserDefaults;
+(NSMutableDictionary*) workoutRepresentationFromWorkout:(BFWorkout *)workout;

@end
