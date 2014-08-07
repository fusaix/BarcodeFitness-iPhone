//
//  BFUser.m
//  BarcodeFitness-iPhone
//
//  Created by Christian Botkin on 8/1/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFUser.h"

@implementation BFUser

@synthesize userId = _userId;
@synthesize username = _username;
@synthesize token = _token;

-(id)initWithUserId:(NSString *)userId username:(NSString *)username andToken:(NSString *)token {
    self = [super init];
    _userId = userId;
    _username = username;
    _token = token;
    return self;
}

@end
