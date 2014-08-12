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

+ (NSMutableDictionary*) setRepresentationFromSet:(BFSet *)set {
    NSMutableDictionary * exerciseRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: set.reps, @"reps", set.weight, @"weight", (set.isDone ? @"YES" : @"NO"), @"isDone", nil];
    // setNumber is populated dynamically at loading and previous records are populated at rendering
    
    return exerciseRepresentation;
}

+ (NSMutableArray*) setsRepresentationFromSets:(NSMutableArray *)sets {
    NSMutableArray * setsRepresentation = [[NSMutableArray alloc ] init];
    for (BFSet * set in sets) {
        [setsRepresentation addObject:[self setRepresentationFromSet:set]];
    }
    
    return setsRepresentation;
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
    BFSet * set;
    BOOL isDone;
    int i = 0;
    for (NSDictionary * workoutRepresentation in workoutTemplatesRepresentation) {
        // init workout
        workout = [[BFWorkout alloc]initWithName: [workoutRepresentation objectForKey:@"name"]];
        // ... image; with initWithNameAndImage
        
        // populate level 2
        for (NSDictionary * exerciseRepresentation in [workoutRepresentation objectForKey:@"exercises"]) {
            exercise = [[BFExercise alloc]initWithName: [exerciseRepresentation objectForKey:@"name"]];
            
            // populate level 3
            int setNumber = 0;
            for (NSDictionary * setRepresentation in [exerciseRepresentation objectForKey:@"sets"]) {
                setNumber++;
                if ([[setRepresentation objectForKey:@"isDone"] isEqualToString:@"YES"]) {
                    isDone = YES;
                } else {
                    isDone = NO;
                }
                set = [[BFSet alloc]initWithReps: [[setRepresentation objectForKey:@"reps"]intValue] andWeight:[[setRepresentation objectForKey:@"weight"]intValue] andPreviousReps:0 andPreviousWeight:0 andSetNumber:setNumber andIsDone: isDone]; // previous records are populated at rendering
                [exercise.sets addObject:set];
            }
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
    if ([[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] == nil) {
        NSLog(@"Vide");
        NSMutableArray * newSets = [[NSMutableArray alloc] init];
        [[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] setObject:newSets forKey:@"sets"];
    }
    // Add an setRepresentation to the sets field in the current exercise to the current workout in workoutTemplatesRepresentation
    [[[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] addObject:[self setRepresentationFromSet:set]];
    
//    NSLog(@"après %@",[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"]objectAtIndex:eIndex]);

    [self saveToStandardUserDefaults];
}

//+(void)insertSet: (BFSet *) set atIndex: (int) sIndex inExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
//    
//    [self saveToStandardUserDefaults];
//}

+(void)removeSetAtIndex: (int) sIndex fromExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    [[[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] removeObjectAtIndex:sIndex];
    [self saveToStandardUserDefaults];
}

+(void)setReps: (NSNumber*) reps atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    [[[[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] objectAtIndex:sIndex] setValue: reps forKey:@"reps"];
    [self saveToStandardUserDefaults];
}

+(void)setWeight: (NSNumber*) weight atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex{
    [[[[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] objectAtIndex:sIndex] setValue: weight forKey:@"weight"];
    [self saveToStandardUserDefaults];
}

+(void)setIsDone: (BOOL) isDone atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex{
    [[[[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] objectAtIndex:sIndex] setValue: (isDone ? @"YES" : @"NO") forKey:@"isDone"];
    [self saveToStandardUserDefaults];
}



@end
