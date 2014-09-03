//
//  BFExercise.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExercise.h"

@implementation BFExercise
@synthesize name = _name;
@synthesize lastDate = _lastDate;
@synthesize duration = _duration;
@synthesize company = _company;

@synthesize sets = _sets;

@synthesize row = _row;


+(id)exerciseWithName:(NSString *)name exerciseId:(NSString *)exerciseId qrCode:(NSString *)qrCode andCompany:(NSString *)company {
    BFExercise *exercise = [[self alloc] init];
    exercise.name = name;
    exercise.qrCode = qrCode;
    exercise.exerciseId = exerciseId;
    exercise.company = company;  
    
    exercise.sets = [[NSMutableArray alloc] init]; // nothing at creation
    return exercise;
}

- (id)initWithName:(NSString *)name qrCode: (NSString *)qrCode andCompagny: (NSString *)compagny {
    self = [super init];
    if (self) {
        self.name = name;
        self.qrCode = qrCode; 
        self.company = compagny;
        self.sets = [[NSMutableArray alloc] init]; // nothing at creation
    }
    return self;
}


-(void)print {
    NSLog(@"\nExercise name:    %s\nExercise qr_code: %s\nExercise id:      %s\n", [self.name UTF8String], [self.qrCode UTF8String], [self.exerciseId UTF8String]);
}

@end
