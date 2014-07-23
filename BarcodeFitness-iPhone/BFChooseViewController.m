//
//  BFChooseViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFChooseViewController.h"
#import "BFWorkout.h"
#import "BFAddWorkoutViewController.h"

@interface BFChooseViewController ()

@end

@implementation BFChooseViewController
@synthesize workouts = _workouts;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.workouts = [[NSMutableArray alloc] init];
    BFWorkout * firstWorkout = [[BFWorkout alloc] initWithName:@"First workout"];
    [self.workouts addObject:firstWorkout];
//    NSLog(@"%@", firstWorkout.name);
//    NSLog(@"%@", self.workouts);
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Choose a workout";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.workouts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BFWorkout * currentWorkout = [self.workouts objectAtIndex:indexPath.row];
    cell.textLabel.text = currentWorkout.name;
//    NSLog(@"%@", currentWorkout.name);
    
    return cell;
}







#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"startWorkout" sender:tableView];
    
}

- (IBAction)addWorkout:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addWorkout" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addWorkout"]){
        UINavigationController * navCon = (UINavigationController *)[segue destinationViewController];
//        @try {
            BFAddWorkoutViewController * addWorkoutViewController = (BFAddWorkoutViewController *)navCon.childViewControllers.firstObject; // IMPORTANT cast and childViewController method. 
            addWorkoutViewController.workoutListViewController = self;
//        }
//        @catch (NSException *exception) {
//            NSLog(@"Exception %@",[exception callStackSymbols]);
//        }
    }
    
}



@end
