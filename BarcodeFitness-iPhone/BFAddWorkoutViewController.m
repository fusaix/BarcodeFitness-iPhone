//
//  BFAddWorkoutViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFAddWorkoutViewController.h"
#import "BFChooseViewController.h"
#import "BFWorkout.h"

@interface BFAddWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation BFAddWorkoutViewController
@synthesize workoutListViewController = _workoutListViewController;


#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {
    // save
    BFWorkout *newWorkout = [[BFWorkout alloc] initWithName:self.nameField.text];
    [self.workoutListViewController.workouts addObject:newWorkout];
    [self.workoutListViewController.tableView reloadData]; 
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark - Begin

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
