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
    NSMutableDictionary * workoutRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: workout.name, @"name", workout.imageIndex, @"imageIndex", workout.lastDate, @"lastDate", workout.duration, @"duration", workout.note, @"note", workout.totalWeight, @"totalWeight", [self exercisesRepresentationFromExercises:workout.exercises], @"exercises", nil];
    // ... image;
    // ... lastDate;
    // ... note;
    // ... totalWeight;
    // ... exercises;
    
    return workoutRepresentation;
}

+ (NSMutableDictionary*) exerciseRepresentationFromExercise:(BFExercise *)exercise {
    NSMutableDictionary * exerciseRepresentation = [[NSMutableDictionary alloc] initWithObjectsAndKeys: exercise.name, @"name", exercise.qrCode, @"qrCode", exercise.company, @"company", [self setsRepresentationFromSets:exercise.sets], @"sets", nil];
    // description done at rendering
    
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
    for (NSDictionary * workoutRepresentation in workoutTemplatesRepresentation) {
        // init workout
        workout = [[BFWorkout alloc] initWithName:[workoutRepresentation objectForKey:@"name"] andImage:[workoutRepresentation objectForKey:@"imageIndex"] andLastDate:[workoutRepresentation objectForKey:@"lastDate"] andDuration:[workoutRepresentation objectForKey:@"duration"] andNote:[workoutRepresentation objectForKey:@"note"] andTotalWeight:[workoutRepresentation objectForKey:@"totalWeight"]];
//        NSLog(@"img %@ - date %@ - dur %@ - note %@ - weig %@ ",[workoutRepresentation objectForKey:@"imageIndex"], [workoutRepresentation objectForKey:@"lastDate"], [workoutRepresentation objectForKey:@"duration"], [workoutRepresentation objectForKey:@"note"], [workoutRepresentation objectForKey:@"totalWeight"] );
        
        // populate level 2
        for (NSDictionary * exerciseRepresentation in [workoutRepresentation objectForKey:@"exercises"]) {
            exercise = [[BFExercise alloc] initWithName:[exerciseRepresentation objectForKey:@"name"]  qrCode: [exerciseRepresentation objectForKey:@"qrCode"] andCompagny:[exerciseRepresentation objectForKey:@"company"]];
            
            // populate level 3
            int setNumber = 0;
            for (NSDictionary * setRepresentation in [exerciseRepresentation objectForKey:@"sets"]) {
                setNumber++;
                if ([[setRepresentation objectForKey:@"isDone"] isEqualToString:@"YES"]) {
                    isDone = YES;
                } else {
                    isDone = NO;
                }
                set = [[BFSet alloc]initWithReps: [[setRepresentation objectForKey:@"reps"]intValue] andWeight:[[setRepresentation objectForKey:@"weight"]floatValue] andPreviousReps:0 andPreviousWeight:0 andSetNumber:setNumber andIsDone: isDone]; // previous records are populated at rendering
                [exercise.sets addObject:set];
            }
            [workout.exercises addObject:exercise];
        }
        [workoutTemplates addObject:workout];
    }
    
    
    return workoutTemplates;
}

+(void)setWorkoutName: (NSString *) name atIndex: (int) index {
    [[workoutTemplatesRepresentation objectAtIndex: index] setObject:name forKey:@"name"];
    [self saveToStandardUserDefaults];
}

+ (void)setWorkoutImage: (NSNumber*) imageIndex atIndex: (int) index {
    [[workoutTemplatesRepresentation objectAtIndex: index] setObject:imageIndex forKey:@"imageIndex"];
    [self saveToStandardUserDefaults];
}

+(void)setWorkoutNote: (NSString *) note atIndex: (int) index {
    [[workoutTemplatesRepresentation objectAtIndex: index] setObject:note forKey:@"note"];
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

+(float)computeWeightForWorkoutAtIndex:(int) wIndex {
    float totalWeight = 0;
    for (NSDictionary * exerciseRepresentation in [[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"]) {
        for (NSDictionary * setRepresentation in [exerciseRepresentation objectForKey:@"sets"]) {
            totalWeight += [[setRepresentation objectForKey:@"weight"] floatValue];
        }
    }
    [[workoutTemplatesRepresentation objectAtIndex: wIndex] setValue:[NSNumber numberWithFloat:totalWeight] forKey:@"totalWeight"];
//    NSLog(@"%f", totalWeight);
    [self saveToStandardUserDefaults];
    return totalWeight; 
}

+(void)setDuration:(int) duration forWorkoutAtIndex:(int) wIndex {
    [[workoutTemplatesRepresentation objectAtIndex: wIndex] setValue:[NSNumber numberWithInt:duration] forKey:@"duration"];
    [self saveToStandardUserDefaults];
}

+(void)setLastDate:(NSDate *) lastDate forWorkoutAtIndex:(int) wIndex {
    [[workoutTemplatesRepresentation objectAtIndex: wIndex] setValue:lastDate forKey:@"lastDate"];
    [self saveToStandardUserDefaults];
}


#pragma mark - Level 3: SetsManagement

+(void)addSet: (BFSet *) set atIndex: (int) sIndex toExerciseAtIndex: (int) eIndex inWorkoutAtIndex: (int) wIndex {
    if ([[[[workoutTemplatesRepresentation objectAtIndex: wIndex] objectForKey:@"exercises"] objectAtIndex:eIndex] objectForKey:@"sets"] == nil) {
//        NSLog(@"Vide");
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
