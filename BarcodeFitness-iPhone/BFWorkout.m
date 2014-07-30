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
@synthesize description = _description; // subtitle of cells in Launcher
@synthesize lastDate = _lastDate;
@synthesize duration = _duration;
@synthesize density = _density;
@synthesize note = _note;


@synthesize row = _row; 



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
//        /* remark;
//        @"%f"    = 3145.559706
//        @"%.f"   = 3146
//        @"%.1f"  = 3145.6
//        @"%.2f"  = 3145.56
//        @"%.02f" = 3145.56 // which is equal to @"%.2f"
//        @"%.3f"  = 3145.560
//        @"%.03f" = 3145.560 // which is equal to @"%.3f" */
//        self.description = [NSString stringWithFormat:@"%@, Duration: %@, Density: %@ lb/s", [dateFormatter stringFromDate:_lastDate], durationFormatted, densityFormatted]; // @"Today, Duration: 0 min, Density: 0 lb/s";
        
        self.description = name;
    }
    return self;
}




@end
