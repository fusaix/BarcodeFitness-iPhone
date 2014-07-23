//
//  BFWorkout.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFWorkout : NSObject
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) image

- (id) initWithName: (NSString*) name; 

@end
