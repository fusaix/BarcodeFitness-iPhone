//
//  BFExercise.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/24/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFExercise : NSObject
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *description; // subtitle of cells
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic) int duration;
//@property (nonatomic) float density;

@property (nonatomic, strong) NSMutableArray * sets;

@property (nonatomic, strong) NSString *exerciseId;
@property (nonatomic, strong) NSString *qrCode;

- (id) initWithName: (NSString*) name;

-(void)print;
+(id)exerciseWithName:(NSString *)name exerciseId:(NSString *)exerciseId qrCode:(NSString *)qrCode;

@end
