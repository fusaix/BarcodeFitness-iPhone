//
//  BFWorkout.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kExercisesRepresentation @"exercisesRepresentation"

@interface BFWorkout : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSNumber *imageIndex;
@property (nonatomic, strong) NSDate *lastDate; // The last date at which the user finished this workout
@property (nonatomic, strong) NSNumber *duration; // The duration this workout at the last performance (default = 0)
@property (nonatomic, strong) NSString *note; // Note about this exercise.
@property (nonatomic, strong) NSNumber * totalWeight;

@property (nonatomic, strong) NSMutableArray *exercises; // List of exercices that composes the current workout

@property (nonatomic) int row;

@property NSString *date;//The time at which the user started his or her workout
@property NSString *workoutId;
@property NSArray *previousExercises;//The list of exercises that the user performed

- (id) initWithName: (NSString*) name;
- (id)initWithName:(NSString *)name andImage: (NSNumber *) imageIndex andLastDate: (NSDate *) lastDate andDuration: (NSNumber *) duration andNote: (NSString*) note andTotalWeight: (NSNumber *) totalWeight; 
+(id)workoutWithID:(NSString *)workoutId andDate:(NSString *)date;


@end
