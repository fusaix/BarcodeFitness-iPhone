//
//  BFExerciseList.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/1/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAllExercisesRepresentation @"allExercisesRepresentation"

@class BFExercise;


@interface BFExerciseList : NSObject

+(NSArray *)getAllExercises;
+(void)saveToStandardUserDefaults: (NSArray * ) jsonArray;


@end
