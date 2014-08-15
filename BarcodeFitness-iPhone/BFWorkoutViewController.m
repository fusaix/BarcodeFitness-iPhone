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
#import "UIViewController+BackButtonHandler.h"


@interface BFWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation BFWorkoutViewController
@synthesize workout = _workout;
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
//    NSLog(@"B: %@",_workout);
//    NSLog(@"C: %d",_workout.row);
//    for(BFWorkout* w in _workoutListViewController.workoutTemplates) {
//        NSLog(@"> %@ Row: %d",w, w.row);
//    }

}

- (void) reloadWorkoutSpecifics {
    _workout = [[BFWorkoutList getWorkoutTemplates] objectAtIndex:_workout.row];
    _exercises = [[NSMutableArray alloc] initWithArray:_workout.exercises];

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // Configure background
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    self.toolBar.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    
    // Configure finish button
    [    self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Helvetica-Bold" size:18.0], NSFontAttributeName,
                                        [self.navigationController.navigationBar tintColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    // Configure button colors
//    _toolBar.tintColor = [UIColor orangeColor];
    
//    // back button
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
//    self.navigationItem.leftBarButtonItem = cancelButton;

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
    cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];

    
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
        [BFWorkoutList removeExerciseAtIndex:(int)indexPath.row fromWorkoutAtIndex:(int)_workout.row];
        // refresh the templates
        [self refreshTemplates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // exchange in _exercises
    BFExercise * movedExercise = [_exercises objectAtIndex:fromIndexPath.row];
    [_exercises removeObjectAtIndex:fromIndexPath.row];
    [_exercises insertObject:movedExercise atIndex:toIndexPath.row];
    // exchange in workoutTemplatesRepresentation
    [BFWorkoutList removeExerciseAtIndex:(int)fromIndexPath.row fromWorkoutAtIndex:_workout.row];
    [BFWorkoutList insertExercise:movedExercise atIndex:(int)toIndexPath.row inWorkoutAtIndex:(int)_workout.row];
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
        [self refreshTemplates];
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        BFExerciseViewController *destViewController = segue.destinationViewController;
        destViewController.currentExerciseNumber = (int)indexPath.row + 1;
        destViewController.totalNumberOfExercises = (int)_exercises.count;
        destViewController.wIndex = _workout.row;
        destViewController.workoutListViewController = _workoutListViewController; // for template refresh 
    }
    
}

-(BOOL) navigationShouldPopOnBackButton {
    // Confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All sets will be undone."
                                                    message:@"Do you really want to cancel this workout?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    alert.tag = 1;
    [alert show];
    return NO;
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

- (IBAction)finishButtonPressed:(UIBarButtonItem *)sender {
    // Confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You have finish you workout!"
                                                    message:@"Press OK if you have finished."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    alert.tag = 2;
    [alert show];
}

#pragma mark - Action result

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // refresh templates and reload specifics
        [self refreshTemplates];
        [self reloadWorkoutSpecifics];
        // reset all sets status of each exercise
        for (int eIndex = 0; eIndex < _exercises.count; eIndex++) {
            for (int sIndex = 0; sIndex < ((BFExercise*)[_exercises objectAtIndex:eIndex]).sets.count ; sIndex++) {
                [BFWorkoutList setIsDone:NO atIndex:sIndex toExerciseAtIndex:eIndex inWorkoutAtIndex:(int)_workout.row];
            }
        }
        if (alertView.tag == 1) {
            // back to  launcher
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // back to home screen
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void) cancelButtonPressed {
    // Confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit workout"
                                                    message:@"Are you sure cancel workout?"
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    alert.tag = 1;
    [alert show];
}

@end
