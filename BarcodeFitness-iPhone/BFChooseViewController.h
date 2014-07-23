//
//  BFChooseViewController.h
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFChooseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray * workouts;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
