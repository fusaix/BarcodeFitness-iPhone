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
#import "BFWorkoutViewController.h"


@interface BFChooseViewController ()
@property (nonatomic) int renameRow;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (nonatomic, strong) UISearchDisplayController* searchDisplayController;
@property (nonatomic, strong) NSMutableArray *filteredWorkoutTemplates;

@end

@implementation BFChooseViewController
@synthesize workoutTemplates = _workoutTemplates;
//@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSMutableArray *)filteredWorkoutTemplates
{
    if (!_filteredWorkoutTemplates) {
        _filteredWorkoutTemplates = [NSMutableArray arrayWithCapacity:0];
    }
    return _filteredWorkoutTemplates;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    // refresh search result table
    self.searchDisplayController.searchBar.text = self.searchDisplayController.searchBar.text;
}

- (void)viewWillDisappear:(BOOL)animated {
    // hide search bar
    if (!self.searchDisplayController.active) {
        [UIView animateWithDuration:0.5
                              delay:1.0
                            options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^(void) {
                             [self hideSearchBar];
                         }
                         completion:nil];
    }
//completion:^(BOOL finished) {
//    if (finished) {
//    }
//}];
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
    
    // hide search bar
    [self hideSearchBar];

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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredWorkoutTemplates.count;
    } else {
        return self.workoutTemplates.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"workoutCell";
    UITableViewCell *cell;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workoutCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BFWorkout * currentWorkout;
    if (tableView == self.searchDisplayController.searchResultsTableView) { // if research mode
        currentWorkout = [self.filteredWorkoutTemplates objectAtIndex:indexPath.row];
    } else { // else default mode
        currentWorkout = [self.workoutTemplates objectAtIndex:indexPath.row];
        // Update workout.row for research mode
        currentWorkout.row = indexPath.row;
    }
    cell.textLabel.text = currentWorkout.name;
    cell.detailTextLabel.text = currentWorkout.description;

//    NSLog(@"%@", currentWorkout.name);
//    NSLog(@"1- %@", _workoutTemplates);
//    NSLog(@"2- %@", _filteredWorkoutTemplates);
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}


#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchDisplayController.searchBar.text = @"";
    [searchBar resignFirstResponder];
//    [self hideSearchBar];
}

#pragma mark - Content Filtering and Search bar methods

-(void)filterContentForSearchText:(NSString*)searchText {
    
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [self.filteredWorkoutTemplates removeAllObjects];
    
    for (BFWorkout *workout in _workoutTemplates) {
//        if ([workout.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
//            [workout.description rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            [self.filteredWorkoutTemplates addObject:workout];
//        }
        if ([workout.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.filteredWorkoutTemplates addObject:workout];
        }
    }
}

- (void) hideSearchBar {
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;

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
        if (self.searchDisplayController.active) { // research mode
            // Get the currentWorkout to find the original row through workout.row
            BFWorkout *currentWorkout = [self.filteredWorkoutTemplates objectAtIndex:indexPath.row];
//            NSLog(@"a. %@ - %i", indexPath, indexPath.row);
//            NSLog(@"b. %@ - %i", currentWorkout, currentWorkout.row);
            // Delete the row from the data source workoutTemplates
            [self.workoutTemplates removeObjectAtIndex:currentWorkout.row];
            self.searchDisplayController.searchBar.text = self.searchDisplayController.searchBar.text;
            [self.tableView reloadData];
            // Delete to workoutTemplatesRepresentation
            [BFWorkoutList removeObjectAtIndex: currentWorkout.row];
        } else {
            CGRect newBounds = self.tableView.bounds;
            // Delete the row from the data source workoutTemplates
            [self.workoutTemplates removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Delete to workoutTemplatesRepresentation
            [BFWorkoutList removeObjectAtIndex: (int) indexPath.row];
            // reload data KILLS animations !!!!!!!!!!!!!!! so we'll use a trick to udate the rows
            for (BFWorkout *workout in self.workoutTemplates) {
                workout.row = indexPath.row;
            }
            self.tableView.bounds = newBounds;
        }
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
    if (self.searchDisplayController.active) { // research mode
        // Get the currentWorkout to find the original row through workout.row
        BFWorkout *currentWorkout = [self.filteredWorkoutTemplates objectAtIndex:indexPath.row];
        self.renameRow = currentWorkout.row;
    } else {
        self.renameRow = indexPath.row;
    }
    [self performSegueWithIdentifier:@"editWorkout" sender:tableView];
    
}

#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"startWorkout" sender:tableView];
    
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
        addWorkoutViewController.workout = [_workoutTemplates objectAtIndex:self.renameRow]; // self.tableView.indexPathForSelectedRow.row does not apply
        addWorkoutViewController.renameRow = self.renameRow; // for the automatic name suggestion
        addWorkoutViewController.segueIdentifier = @"editWorkout";
    } else if ([segue.identifier isEqualToString:@"startWorkout"]) {
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        BFWorkout *workout = nil;
        if (self.searchDisplayController.active) {
            workout = [_filteredWorkoutTemplates objectAtIndex:indexPath.row];
        } else {
            workout = [_workoutTemplates objectAtIndex:indexPath.row];
        }
        BFWorkoutViewController *destViewController = segue.destinationViewController;
        destViewController.workout = workout;
    }
    
}

#pragma mark - IBActions

- (IBAction)addWorkout:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addWorkout" sender:self];
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
