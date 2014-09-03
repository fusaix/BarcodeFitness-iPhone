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
@class BFExercise;
@class BFSet;

@interface BFWorkoutList : NSObject

// O
+(void)saveToStandardUserDefaults;

// 1
+(NSMutableArray *)getWorkoutTemplates; 
+(void)setWorkoutName: (NSString *) name atIndex: (int) index;
// + (void)setWorkoutImage: (UIImage *) image atIndex: (int) index;
+(void)setWorkoutNote: (NSString *) note atIndex: (int) index;
+(void)addObject:(BFWorkout *)workout;
+(void)insertObject:(BFWorkout *)workout atIndex:(int)index;
+(void)removeObjectAtIndex:(int)index;

// 2 
+(void)addExercise: (BFExercise *) exercise toWorkoutAtIndex: (int) wIndex;
+(void)insertExercise: (BFExercise *) exercise atIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;
+(void)removeExerciseAtIndex: (int) eIndex fromWorkoutAtIndex: (int) wIndex;

+(float)computeWeightForWorkoutAtIndex:(int) wIndex;
+(void)setDuration:(int) duration forWorkoutAtIndex:(int) wIndex;
+(void)setLastDate:(NSDate *) lastDate forWorkoutAtIndex:(int) wIndex;

// 3
+(void)addSet: (BFSet *) set atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;
+(void)removeSetAtIndex: (int) sIndex fromExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;
+(void)setReps: (NSNumber*) reps atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;
+(void)setWeight: (NSNumber*) weight atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;
+(void)setIsDone: (BOOL) isDone atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex;


@end
