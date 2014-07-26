//
//  BFChooseViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFChooseViewController.h"
#import "BFWorkoutList.h"
#import "BFWorkout.h"
#import "BFAddWorkoutViewController.h"

@interface BFChooseViewController ()
@property (nonatomic, strong) NSIndexPath * renameIndexPath;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BFChooseViewController
@synthesize workoutTemplates = _workoutTemplates;
@synthesize tableView = _tableView;

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

}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init the BFWorkoutList _workoutTemplates
    // we get _workoutTemplates from the stored representation, translation is performed by BFWorkoutList class
    if (!_workoutTemplates) {
        _workoutTemplates = [[NSMutableArray alloc] initWithArray:[BFWorkoutList getWorkoutTemplates]];
    }
    

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
    return @"Choose a workout to start";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.workoutTemplates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BFWorkout * currentWorkout = [self.workoutTemplates objectAtIndex:indexPath.row];
    cell.textLabel.text = currentWorkout.name;
//    NSLog(@"%@", currentWorkout.name);
    
    return cell;
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
        [self.workoutTemplates removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // Delete to workoutTemplatesRepresentation
        [BFWorkoutList removeObjectAtIndex: (int) indexPath.row];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // exchange in workoutTemplates
    BFWorkout * movedWorkout = [_workoutTemplates objectAtIndex:fromIndexPath.row];
    [_workoutTemplates removeObjectAtIndex:fromIndexPath.row];
    [_workoutTemplates insertObject:movedWorkout atIndex:toIndexPath.row];
    // exchange in workoutTemplatesRepresentation
    [BFWorkoutList removeObjectAtIndex: (int) fromIndexPath.row];
    [BFWorkoutList insertObject:movedWorkout atIndex: (int) toIndexPath.row];
    
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Secondary swipe button

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Rename";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.renameIndexPath = indexPath;
    [self performSegueWithIdentifier:@"editWorkout" sender:tableView];
}

#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"startWorkout" sender:tableView];
    
}

#pragma mark - IBActions

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
        addWorkoutViewController.segueIdentifier = @"addWorkout";
        //        }
        //        @catch (NSException *exception) {
        //            NSLog(@"Exception %@",[exception callStackSymbols]);
        //        }
    } else if ([segue.identifier isEqualToString:@"editWorkout"]) { // BFAddWorkoutViewController is also used for editing an workout (rename or change image) 
        UINavigationController * navCon = (UINavigationController *)[segue destinationViewController];
        BFAddWorkoutViewController * addWorkoutViewController = (BFAddWorkoutViewController *)navCon.childViewControllers.firstObject; // IMPORTANT cast and childViewController method.
        addWorkoutViewController.workout = [_workoutTemplates objectAtIndex:self.renameIndexPath.row]; // self.tableView.indexPathForSelectedRow.row does not apply
        addWorkoutViewController.renameRow = (int) self.renameIndexPath.row; // for the automatic name suggestion
        addWorkoutViewController.segueIdentifier = @"editWorkout";
    }
    
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    self.tableView.editing = !self.tableView.editing; // not a tableViewController so use the "self.tableView.editing" in stead of "self.editing"

    if (self.tableView.editing) {
        sender.tintColor = [UIColor redColor];
    } else {
        sender.tintColor = [self.navigationController.navigationBar tintColor];
    }
//    NSLog(@"%s", self.tableView.editing ? "YES" : "NO");
//    // color decomposer
//    CGFloat red;
//    CGFloat green;
//    CGFloat blue;
//    CGFloat alpha;
//    UIColor *textColor = [sender tintColor];
//    [textColor getRed:&red green:&green blue:&blue alpha:&alpha];
//    NSLog(@"Red: %f Green:%f Blue:%f Alpha:%f", red, green, blue, alpha);

}


@end
