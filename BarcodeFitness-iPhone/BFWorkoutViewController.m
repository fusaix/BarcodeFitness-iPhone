//
//  BFWorkoutViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutViewController.h"
#import "BFScanViewController.h"
#import "BFWorkoutList.h"
#import "BFWorkout.h"
#import "BFExercise.h"
#import "BFExerciseViewController.h"
#import "BFChooseViewController.h"


@interface BFWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BFWorkoutViewController
@synthesize workout = _workout;
@synthesize wIndex = _wIndex; 
@synthesize exercises = _exercises;
@synthesize workoutListViewController = _workoutListViewController; // to refresh the templates 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    // refresh the templates
    [self refreshTemplates];
//    NSLog(@"viewWillAppear: %@",_exercises);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init the NSMutableArray _exercises
    // we get _exercises from the stored representation, translation is performed by ... BFWorkoutList the root data class. 
    if (!_exercises) {
        _exercises = [[NSMutableArray alloc] initWithArray:_workout.exercises];
    }
    
    // Configure navigation bar
    self.title = _workout.name;
    // configure back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Rest" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data management

- (void) refreshTemplates {
    _workoutListViewController.workoutTemplates = [BFWorkoutList getWorkoutTemplates];
//    NSLog(@"Templates refreshed: %@",_exercises);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Choose an exercise to start";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.exercises.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BFExercise * currentExercise;
    currentExercise = [self.exercises objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentExercise.name;
    cell.detailTextLabel.text = currentExercise.description;
    
//    NSLog(@"%@", currentExercise.name);
//    NSLog(@"1- %@", _exercises);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - Edit modes

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source workoutTemplates
        [_exercises removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // Delete to workoutTemplatesRepresentation
        [BFWorkoutList removeExerciseAtIndex:indexPath.row fromWorkoutAtIndex:_workout.row];
        // refresh the templates
        [self refreshTemplates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // exchange in workoutTemplates
    BFExercise * movedExercise = [_exercises objectAtIndex:fromIndexPath.row];
    [_exercises removeObjectAtIndex:fromIndexPath.row];
    [_exercises insertObject:movedExercise atIndex:toIndexPath.row];
    // exchange in workoutTemplatesRepresentation
    [BFWorkoutList removeExerciseAtIndex:fromIndexPath.row fromWorkoutAtIndex:_workout.row];
    [BFWorkoutList insertExercise:movedExercise atIndex:toIndexPath.row inWorkoutAtIndex:_workout.row];
    // refresh the templates
    [self refreshTemplates];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to detail
    [self performSegueWithIdentifier:@"startExercise" sender:tableView];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addExercise"]){
        UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0]; // Scan in 1st position
        BFScanViewController * scanViewController = [[navigationController viewControllers] objectAtIndex:0];
        scanViewController.exerciseListViewController = self;
        scanViewController.wIndex = _workout.row; // workout.row gives the true original index of the current workout (created for research mode use)
//        scanViewController.segueIdentifier = @"addExercise";
        
    } else if ([segue.identifier isEqualToString:@"startExercise"]) {
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        BFExercise *exercise = nil;
        exercise = [_exercises objectAtIndex:indexPath.row];
        BFExerciseViewController *destViewController = segue.destinationViewController;
        destViewController.exercise = exercise;
    }
    
}



#pragma mark - IBActions

- (IBAction)addWorkout:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addExercise" sender:self];
    
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    if (!self.tableView.isEditing) {
        [self.tableView setEditing:YES animated:YES];
    } else {
        [self.tableView setEditing:NO animated:YES];
    }

    if (self.tableView.editing) {
        sender.tintColor = [UIColor redColor];
    } else {
        sender.tintColor = [self.navigationController.navigationBar tintColor];
    }
}

- (IBAction)noteButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)finishAllButtonPressed:(UIBarButtonItem *)sender {
}

@end
