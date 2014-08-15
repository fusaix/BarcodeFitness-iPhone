//
//  BFSet.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFSet : NSObject

@property (nonatomic, strong) NSNumber *reps;
@property (nonatomic, strong) NSNumber *weight;

@property (nonatomic, strong) NSNumber *previousReps;
@property (nonatomic, strong) NSNumber *previousWeight;

@property (nonatomic, strong) NSNumber *setNumber;

@property (nonatomic, assign) bool isDone;


- (id)initWithReps:(int)reps andWeight: (float)weight andPreviousReps: (int)previousReps andPreviousWeight: (float)previousWeight andSetNumber: (int)setNumber andIsDone: (bool) isDone ;

@end
