//
//  BFWorkoutList.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutList.h"
#import "BFWorkout.h"
#import "BFExercise.h"
#import "BFSet.h"


@implementation BFWorkoutList

static NSMutableArray * workoutTemplatesRepresentation = nil;
//static NSString * currentKey = nil;


#pragma mark - Level 0: Representation building and saving

+(void)saveToStandardUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:workoutTemplatesRepresentation forKey:kWorkoutTemplatesRepresentation];
}

+ (NSMutableDictionary*) workoutRepresentationFromWorkout:(BFWorkout *)workout {
    NSMutableDictionary * workoutRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: workout.name, @"name", workout.imageIndex, @"imageIndex", [self exercisesRepresentationFromExercises:workout.exercises], @"exercises", nil];
    // ... image;
    // ... exercises;
    
    return workoutRepresentation;
}

+ (NSMutableDictionary*) exerciseRepresentationFromExercise:(BFExercise *)exercise {
    NSMutableDictionary * exerciseRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: exercise.name, @"name", nil];
    // ... description;
    // ... sets;
    
    return exerciseRepresentation;
}

+ (NSMutableArray*) exercisesRepresentationFromExercises:(NSMutableArray *)exercises {
    NSMutableArray * exercisesRepresentation = [[NSMutableArray alloc ] init];
    for (BFExercise * exercise in exercises) {
        [exercisesRepresentation addObject:[self exerciseRepresentationFromExercise:exercise]];
    }
    
    return exercisesRepresentation;
}



#pragma mark - Level 1: WorkoutManagement

+(NSMutableArray *)getWorkoutTemplates{
    if (workoutTemplatesRepresentation == nil) {
        workoutTemplatesRepresentation = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kWorkoutTemplatesRepresentation]];
    }
    
    // Now we build the whole tree !!!!! the data will not be updated buy the network during the workout ???
    NSMutableArray * workoutTemplates = [[NSMutableArray alloc] init];
    BFWorkout * workout;
    BFExercise * exercise;
    int i = 0;
    for (NSDictionary * workoutRepresentation in workoutTemplatesRepresentation) {
        // init workout
        workout = [[BFWorkout alloc]initWithName: [workoutRepresentation objectForKey:@"name"]];
        // ... image; with initWithNameAndImage
        // populate level 2
        for (NSDictionary * exerciseRepresentation in [[workoutTemplatesRepresentation objectAtIndex:i] objectForKey:@"exercises"]) {
            exercise = [[BFExercise alloc]initWithName: [exerciseRepresentation objectForKey:@"name"]];
            
            // populate level 3
            // ...
            
            
            [workout.exercises addObject:exercise];
        }
        [workoutTemplates addObject:workout];
        i++;
    }
    
    return workoutTemplates;
}

+(void)setWorkoutName: (NSString *) name atIndex: (int) index {
    [[workoutTemplatesRepresentation objectAtIndex: index] setObject:name forKey:@"name"];
    [self saveToStandardUserDefaults];
}

+(void)addObject:(BFWorkout *)workout {
    [workoutTemplatesRepresentation addObject:[self workoutRepresentationFromWorkout:workout]];
    [self saveToStandardUserDefaults];
}

+(void)insertObject:(BFWorkout *)workout atIndex:(int)index {
    [workoutTemplatesRepresentation insertObject: [self workoutRepresentationFromWorkout:workout] atIndex:index];
    [self saveToStandardUserDefaults];
}

+(void)removeObjectAtIndex:(int)index{
    [workoutTemplatesRepresentation removeObjectAtIndex:index];
    [self saveToStandardUserDefaults];
}


#pragma mark - Level 2: ExercisesManagement

+(void)addExercise: (BFExercise *) exercise toWorkoutAtIndex: (int) wIndex {
    if ([[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] == nil) {
//        NSLog(@"Vide");
        NSMutableArray * newExercises = [[NSMutableArray alloc] init];
        [[workoutTemplatesRepresentation objectAtIndex: wIndex] setObject:newExercises forKey:@"exercises"];
    }
    // Add an exerciseRepresentation to the exercises field at the current workout in workoutTemplatesRepresentation
    [[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] addObject:[self exerciseRepresentationFromExercise:exercise]];
//    NSLog(@"row in data: %d", wIndex);
//    NSLog(@"après %@",[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"]);
    [self saveToStandardUserDefaults];
}

+(void)insertExercise: (BFExercise *) exercise atIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    [[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] insertObject:[self exerciseRepresentationFromExercise:exercise] atIndex:eIndex];
    [self saveToStandardUserDefaults];
}

+(void)removeExerciseAtIndex: (int) eIndex fromWorkoutAtIndex: (int) wIndex {
    [[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] removeObjectAtIndex:eIndex];
    [self saveToStandardUserDefaults];
}




#pragma mark - Level 3: SetsManagement

+(void)addSet: (BFSet *) set atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    
    [self saveToStandardUserDefaults];
}

+(void)insertSet: (BFSet *) set atIndex: (int) sIndex inExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    
    [self saveToStandardUserDefaults];
}

+(void)removeSet: (BFSet *) set atIndex: (int) sIndex fromExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    
    [self saveToStandardUserDefaults];
}

+(void)setReps: (int) reps atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    
    [self saveToStandardUserDefaults];
}

+(void)setWeight: (float) weight atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex{
    
    [self saveToStandardUserDefaults];
}




@end
