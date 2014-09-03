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
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic) int duration;

@property (nonatomic, strong) NSMutableArray * sets;

@property (nonatomic, strong) NSString *exerciseId;
@property (nonatomic, strong) NSString *qrCode;
@property (nonatomic, strong) NSString *company;

@property (nonatomic) int row;


- (id)initWithName:(NSString *)name  qrCode: (NSString *)qrCode andCompagny: (NSString *)compagny;

-(void)print;
+(id)exerciseWithName:(NSString *)name exerciseId:(NSString *)exerciseId qrCode:(NSString *)qrCode andCompany:(NSString *)company;


@end
