//
//  BFExerciseList.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/1/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseList.h"
#import "BFExercise.h"

@implementation BFExerciseList

static NSArray *allExercisesRepresentation = nil; // jsonArray

+(NSArray *)getAllExercises{
    // Pull from memory
    if (allExercisesRepresentation == nil) {
        allExercisesRepresentation = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kAllExercisesRepresentation]];
    }
    
    // Translate
    NSMutableArray *allExercises = [NSMutableArray array];
    for (NSDictionary *jsonExercise in allExercisesRepresentation) {
        // do something with object
        [allExercises addObject: [BFExercise exerciseWithName:[jsonExercise objectForKey:@"name"] exerciseId:[jsonExercise objectForKey:@"id"] qrCode:[jsonExercise objectForKey:@"qr_code"]]];
    }
    return allExercises;
}


+(void)saveToStandardUserDefaults: (NSArray * ) jsonArray {
    // Save a copy to standardUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:jsonArray forKey:kAllExercisesRepresentation];
    
    // Notify the UI that an update have been done
    
}



@end
