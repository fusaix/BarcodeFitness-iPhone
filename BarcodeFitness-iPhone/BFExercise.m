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
@synthesize description = _description; // subtitle of cells in Launcher
@synthesize lastDate = _lastDate;
@synthesize duration = _duration;
@synthesize density = _density;

@synthesize sets = _sets; 

+(id)exerciseWithName:(NSString *)name exerciseId:(NSString *)exerciseId qrCode:(NSString *)qrCode {
    BFExercise *exercise = [[self alloc] init];
    exercise.name = name;
    exercise.qrCode = qrCode;
    exercise.exerciseId = exerciseId;
    return exercise;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        
        //        // default text for description
        //        _lastDate = [NSDate date];
        //        _duration = 0;
        //        _density = 0;
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"hh:mm a"];
        ////        [dateFormatter setDateFormat:@"MM/dd/yy"];
        //        NSString* durationFormatted = [NSString stringWithFormat:@"%i min", _duration];
        ////        NSString* durationFormatted;
        ////        if (_duration < 60) {
        ////            durationFormatted = [NSString stringWithFormat:@"%i min", _duration];
        ////        } else {
        ////            int hour = _duration/60;
        ////            int minute = _duration%60;
        ////            durationFormatted = [NSString stringWithFormat:@"%i h %i min", hour, minute];
        ////        }
        //        NSString* densityFormatted = [NSString stringWithFormat:@"%.02f", _density];
        //        self.description = [NSString stringWithFormat:@"%@, Duration: %@, Density: %@ lb/s", [dateFormatter stringFromDate:_lastDate], durationFormatted, densityFormatted]; // @"Today, Duration: 0 min, Density: 0 lb/s";
        
        self.description = name; // to be changed
        self.sets = [[NSMutableArray alloc] init]; // nothing at creation
    }
    return self;
}


-(void)print {
    NSLog(@"\nExercise name:    %s\nExercise qr_code: %s\nExercise id:      %s\n", [self.name UTF8String], [self.qrCode UTF8String], [self.exerciseId UTF8String]);
}

@end
