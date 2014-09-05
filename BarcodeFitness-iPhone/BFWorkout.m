//
//  BFWorkout.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkout.h"

@implementation BFWorkout
@synthesize name = _name;
@synthesize image = _image;
@synthesize imageIndex = _imageIndex;
@synthesize lastDate = _lastDate; // subtitle of cells in Launcher
@synthesize duration = _duration; // subtitle of cells in Launcher
@synthesize note = _note; // note string // subtitle of cells in Launcher
@synthesize exercises = _exercises;
@synthesize totalWeight = _totalWeight; // subtitle of cells in Launcher

@synthesize row = _row;

@synthesize date;//The time at which the user started his or her workout
@synthesize workoutId;
@synthesize previousExercises;//The list of exercises that the user performed


//NSArray* workoutImages = [NSArray arrayWithObjects: @"BarcodeFitnessIconRounded.png",
//                                         @"Monday_sf.png",
//                                         @"Tuesday_sf.png",
//                                         @"Wednesday_sf.png",
//                                         @"Thursday_sf.png",
//                                         @"Friday_sf.png",
//                                         @"Saturday_sf.png",
//                                         @"Sunday_sf.png",
//                                         @"Everyday_sf.png", nil];

+ (NSArray *)workoutImages
{
    static NSArray *_workoutImages;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _workoutImages = @[@"BarcodeFitnessIconRounded.png",
                    @"Monday_sf.png",
                    @"Tuesday_sf.png",
                    @"Wednesday_sf.png",
                    @"Thursday_sf.png",
                    @"Friday_sf.png",
                    @"Saturday_sf.png",
                    @"Sunday_sf.png",
                    @"Everyday_sf.png",
                    @"Buzz_rounded.png"
                           ];
    });
    return _workoutImages;
}

+(id)workoutWithID:(NSString *)workoutId andDate:(NSString *)date {
    BFWorkout *workout = [super new];
    workout.date = date;
    workout.workoutId = workoutId;
    return workout;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;

        // choose a random image
//        int i = arc4random() % [BFWorkout workoutImages].count;
        
        // choose the image of the day
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        int weekday = (int)[comps weekday];
        int i = weekday - 1;
        if (i == 0) i = 7;
        
        self.image = [UIImage imageNamed:[BFWorkout workoutImages][i]];
        self.imageIndex = [NSNumber numberWithInt:i];
        self.lastDate = [NSDate date];
        self.duration = [NSNumber numberWithInteger:0];
        self.note = @"";
        self.totalWeight = [NSNumber numberWithInteger:0];
        
        self.exercises = [[NSMutableArray alloc] init]; // nothing at creation
    }
    return self;
}

- (id)initWithName:(NSString *)name andImage: (int) imageIndex {
    self = [super init];
    if (self) {
        self.name = name;
        self.image = [UIImage imageNamed:[BFWorkout workoutImages][imageIndex]];
        self.imageIndex = [NSNumber numberWithInt:imageIndex];
        self.lastDate = [NSDate date];
        self.duration = [NSNumber numberWithInteger:0];
        self.note = @"";
        self.totalWeight = [NSNumber numberWithInteger:0];
        
        self.exercises = [[NSMutableArray alloc] init]; // nothing at creation
    }
    return self;
}

- (id)initWithName:(NSString *)name andImage: (NSNumber *) imageIndex andLastDate: (NSDate *) lastDate andDuration: (NSNumber *) duration andNote: (NSString*) note andTotalWeight: (NSNumber *) totalWeight{
    self = [super init];
    if (self) {
        self.name = name;
        self.image = [UIImage imageNamed:[BFWorkout workoutImages][[imageIndex intValue]]];
        self.imageIndex = imageIndex;
        self.lastDate = lastDate;
        self.duration = duration;
        self.note = note;
        self.totalWeight = totalWeight;
        
        self.exercises = [[NSMutableArray alloc] init]; // nothing at creation
    }
    return self;
}


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
//        /* remark;
//        @"%f"    = 3145.559706
//        @"%.f"   = 3146
//        @"%.1f"  = 3145.6
//        @"%.2f"  = 3145.56
//        @"%.02f" = 3145.56 // which is equal to @"%.2f"
//        @"%.3f"  = 3145.560
//        @"%.03f" = 3145.560 // which is equal to @"%.3f" */
//        self.description = [NSString stringWithFormat:@"%@, Duration: %@, Density: %@ lb/s", [dateFormatter stringFromDate:_lastDate], durationFormatted, densityFormatted]; // @"Today, Duration: 0 min, Density: 0 lb/s";


@end
