//
//  BFUser.h
//  BarcodeFitness-iPhone
//
//  Created by Christian Botkin on 8/1/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFUser : NSObject

@property(nonatomic,readonly) NSString *userId;
@property(nonatomic,readonly) NSString *username;
@property(nonatomic,readonly) NSString *token;

-(id)initWithUserId:(NSString *)userId username:(NSString *)username andToken:(NSString *)token;

@end
