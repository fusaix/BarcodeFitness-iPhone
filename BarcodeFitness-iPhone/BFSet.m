//
//  BFSet.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFSet.h"

@implementation BFSet

@synthesize reps = _reps;
@synthesize weight = _weight;
@synthesize previousReps = _previousReps;
@synthesize previousWeight = _previousWeight;
@synthesize setNumber = _setNumber;
@synthesize isDone = _isDone; 


- (id)initWithReps:(int)reps andWeight: (int)weight andPreviousReps: (int)previousReps andPreviousWeight: (int)previousWeight andSetNumber: (int)setNumber andIsDone: (bool) isDone {
    self = [super init];
    if (self) {
        self.reps = [[NSNumber alloc] initWithInt: reps];
        self.weight = [[NSNumber alloc] initWithInt: weight];
        
        self.previousReps = [[NSNumber alloc] initWithInt: previousReps];
        self.previousWeight = [[NSNumber alloc] initWithInt: previousWeight];
        
        self.setNumber = [[NSNumber alloc] initWithInt: setNumber];
        
        _isDone = isDone;
        
    }
    return self;
}

@end
