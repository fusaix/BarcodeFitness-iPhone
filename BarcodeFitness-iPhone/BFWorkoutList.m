//
//  BFWorkoutList.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutList.h"
#import "BFWorkout.h"


@implementation BFWorkoutList

static NSMutableArray * workoutTemplatesRepresentation = nil;
static NSString * currentKey = nil;


+(NSMutableArray *)getWorkoutTemplates{
    if (workoutTemplatesRepresentation == nil) {
        workoutTemplatesRepresentation = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kWorkoutTemplatesRepresentation]];
    }
    
    NSMutableArray * workoutTemplates = [[NSMutableArray alloc] init];
    BFWorkout * workout;
    for (NSDictionary * workoutRepresentation in workoutTemplatesRepresentation) {
        workout = [[BFWorkout alloc]initWithName: [workoutRepresentation objectForKey:@"name"]];
        // ... image;
        [workoutTemplates addObject:workout];
    }
    
    return workoutTemplates;
}

+(void)setWorkoutName: (NSString *) name atIndex: (int) index {
    [[workoutTemplatesRepresentation objectAtIndex: index] setObject:name forKey:@"name"];
    [self saveToStandardUserDefaults];
}

+(void)insertObject:(BFWorkout *)workout atIndex:(int)index {
    [workoutTemplatesRepresentation insertObject: [self workoutRepresentationFromWorkout:workout] atIndex:index];
    [self saveToStandardUserDefaults];
}

+(void)addObject:(BFWorkout *)workout {
    [workoutTemplatesRepresentation addObject:[self workoutRepresentationFromWorkout:workout]];
    [self saveToStandardUserDefaults];
}

+(void)removeObjectAtIndex:(int)index{
    [workoutTemplatesRepresentation removeObjectAtIndex:index];
    [self saveToStandardUserDefaults];
}


+(void)saveToStandardUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:workoutTemplatesRepresentation forKey:kWorkoutTemplatesRepresentation];
}

+ (NSMutableDictionary*) workoutRepresentationFromWorkout:(BFWorkout *)workout {
    NSMutableDictionary * workoutRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: workout.name, @"name", nil];
    // ... image;
    // ... exercises;
    
    return workoutRepresentation;
}


@end
