//
//  BFExerciseList.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/1/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseList.h"
#import "BFExercise.h"
#import "BFNetworkExercises.h"


@implementation BFExerciseList

static NSString *baseExerciseUrlString = @"http://m.gatech.edu/api/barcodefitness/exercises";
//static NSString *baseUrlString = @"http://dev.m.gatech.edu/d/bedmonds3/api/barcode-fitness-api/";

static NSArray *allExercisesRepresentation = nil; // jsonArray

+(NSArray *)getAllExercises{
    // Pull from memory
    if (allExercisesRepresentation == nil) {
        allExercisesRepresentation = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kAllExercisesRepresentation]];
    }
    
    // Translate
    NSMutableArray *allExercises = [NSMutableArray array];
    for (NSDictionary *jsonExercise in allExercisesRepresentation) {
        // do something with object
        [allExercises addObject: [BFExercise exerciseWithName:[jsonExercise objectForKey:@"name"] exerciseId:[jsonExercise objectForKey:@"id"] qrCode:[jsonExercise objectForKey:@"qr_code"] andCompany:[jsonExercise objectForKey:@"company"]]];
    }
    
    // Sort by name
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [allExercises sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedArray;
}


+(void)saveToStandardUserDefaults: (NSArray * ) jsonArray {
    // Save a copy to standardUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:jsonArray forKey:kAllExercisesRepresentation];
    
    // Notify the UI that an update have been done
    
}


+(void)loadExercisesFromNetwork {
    NSURL *url = [NSURL URLWithString:baseExerciseUrlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) {
             NSError *requestError;
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&requestError];
             // Save to persistent data
             [self saveToStandardUserDefaults: jsonArray];
         } else if ([data length] == 0 && error == nil)
             NSLog(@"Server return no data.");
         else if (error != nil)
             NSLog(@"Connection failed: %@", [error description]);
//         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
//                                                         message:@"You must be connected to the internet to use this app."
//                                                        delegate:nil
//                                               cancelButtonTitle:@"OK"
//                                               otherButtonTitles:nil];
//         [alert show];
     }];
}



@end
