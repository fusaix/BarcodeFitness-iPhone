//
//  BFNetworkLoader.m
//  BarcodeFitness-iPhone
//
//  Created by Christian Botkin on 7/31/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFNetworkLoader.h"

@implementation BFNetworkLoader

+(NSArray *)getAllExercises {
    NSString *urlString = [NSString stringWithFormat:
                           @"http://m.gatech.edu/api/barcodefitness/exercises"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Create a dictionary from the JSON string
    NSError *requestError;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&requestError];
    
    NSMutableArray *allExercises = [NSMutableArray array];
    for (NSDictionary *jsonExercise in jsonArray) {
        // do something with object
        [allExercises addObject: [BFExercise exerciseWithName:[jsonExercise objectForKey:@"name"] exerciseId:[jsonExercise objectForKey:@"id"] qrCode:[jsonExercise objectForKey:@"qr_code"]]];
    }
}

@end
