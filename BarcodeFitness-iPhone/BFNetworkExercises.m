//
//  BFNetworkLoader.m
//  BarcodeFitness-iPhone
//
//  Created by Christian Botkin on 7/31/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFNetworkExercises.h"

@implementation BFNetworkExercises

static NSArray *exercises;
static NSArray *workoutHistory;
static NSString *baseExerciseUrlString = @"http://m.gatech.edu/api/barcodefitness/exercises";
static NSString *baseUrlString = @"http://dev.m.gatech.edu/d/bedmonds3/api/barcode-fitness-api/";

+(NSArray *)getExercises {
    return exercises;
}

+(void)loadExercisesFromNetwork {
    NSURL *url = [NSURL URLWithString:baseExerciseUrlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             NSError *requestError;
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&requestError];
             exercises = [self loadBaseExercisesFromJSONArray:jsonArray];
         } else if ([data length] == 0 && error == nil)
             NSLog(@"Server return no data.");
         else if (error != nil)
             NSLog(@"Connection failed: %@", [error description]);
     }];
}

+(void)loadExercisesFromStorage {
    NSURL *url = [NSURL URLWithString:baseExerciseUrlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             NSError *requestError;
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&requestError];
             exercises = [self loadBaseExercisesFromJSONArray:jsonArray];
         } else if ([data length] == 0 && error == nil)
             NSLog(@"Server return no data.");
         else if (error != nil)
             NSLog(@"Connection failed: %@", [error description]);
     }];
}

+(NSArray *)loadBaseExercisesFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray *allExercises = [NSMutableArray array];
    for (NSDictionary *jsonExercise in jsonArray) {
        // do something with object
        [allExercises addObject: [self loadBaseExerciseFromJSON:jsonExercise]];
    }
    return allExercises;
}

+(BFExercise *)loadBaseExerciseFromJSON:(NSDictionary *)jsonExercise {
    return [BFExercise exerciseWithName:[jsonExercise objectForKey:@"name"] exerciseId:[jsonExercise objectForKey:@"id"] qrCode:[jsonExercise objectForKey:@"qr_code"] andCompany:[jsonExercise objectForKey:@"company"]];
}

+(NSArray *)getWorkoutHistory {
    return workoutHistory;
}

+(void)loadWorkoutHistoryFromNetworkForUser:(BFUser *)user {
    NSString *urlString = [NSString stringWithFormat:@"%@users/%@/workouts/?recordType=full&token=%@", baseUrlString, user.userId, user.token];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             NSError *requestError;
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&requestError];
             
             workoutHistory = [self loadWorkoutHistoryFromJSONArray:jsonArray];
         } else if ([data length] == 0 && error == nil)
             NSLog(@"Server returned no data for workout history.");
         else if (error != nil)
             NSLog(@"Connection failed: %@", [error description]);
     }];
}

+(NSArray *)loadWorkoutHistoryFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray *allWorkouts = [NSMutableArray array];
    for (NSDictionary *jsonWorkout in jsonArray) {
        // do something with object
        [allWorkouts addObject: [self loadWorkoutFromJSON:jsonWorkout]];
    }
    return allWorkouts;
}

+(BFWorkout *)loadWorkoutFromJSON:(NSDictionary *)jsonWorkout {
    BFWorkout *workout = [BFWorkout workoutWithID:[jsonWorkout objectForKey:@"workout_id"] andDate:[jsonWorkout objectForKey:@"start_time"]];
    for (NSDictionary *jsonExercise in [jsonWorkout objectForKey:@"data"]) {
        BFExercise *exercise = [[BFExercise alloc] initWithName:[jsonExercise objectForKey:@"exercise_name"] andCompagny:@"company"];
        exercise.exerciseId = [jsonExercise objectForKey:@"exercise_id"];
        //TODO: add loading of exercise data.
    }
    return workout;
}

+(void)loadWorkoutHistoryFromStorageForUser:(BFUser *)user {}

@end
