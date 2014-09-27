//
//  BFExerciseListViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/19/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseListViewController.h"
#import "BFExercise.h"
#import "BFExerciseList.h"
#import "BFWorkoutViewController.h"
#import "BFWorkoutList.h"


@interface BFExerciseListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *wishList; // list of NSString used as BOOL
@property (nonatomic, strong) NSMutableArray *filteredExercises;
@property (nonatomic) int count;

@end

@implementation BFExerciseListViewController
@synthesize exercises = _exercises;
@synthesize exerciseListViewController = _exerciseListViewController;
@synthesize wIndex = _wIndex;

-(NSMutableArray *)filteredExercises
{
    if (!_filteredExercises) {
        _filteredExercises = [NSMutableArray arrayWithCapacity:0];
    }
    return _filteredExercises;
}

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
    if (!_exercises) {
        _exercises = [[NSMutableArray alloc] initWithArray:[BFExerciseList getAllExercises]];

    }
    if (!_wishList) {
        _wishList = [[NSMutableArray alloc] init];
        NSString * flag = @"NO";
        for(int i = 0; i < _exercises.count; i++) {
            [_wishList addObject:flag];
        }
    }
    // Configure search bar text color
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    
    // Background color
//    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (_count == 0) {
            return @"No selection yet";
        } else {
            return [NSString stringWithFormat:@"%d selected in list", _count];
        }
    } else {
        return @"Default exercises";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredExercises.count;
    } else {
        return self.exercises.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell"];
//        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
    }
    
    // Configure the cell...
    BFExercise * currentExercise;
    if (tableView == self.searchDisplayController.searchResultsTableView) { // if research mode
        currentExercise = [self.filteredExercises objectAtIndex:indexPath.row];
    } else { // else default mode
        currentExercise = [self.exercises objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = currentExercise.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Machine constructor: %@",currentExercise.company];
    cell.detailTextLabel.textColor = [UIColor grayColor];
//    UIView *orangeView = [[UIView alloc] init];
//    orangeView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:148.0/255.0f blue:30.0f/255.0f alpha:1.0f]; //orange BeeHive -> UIColor
//    [cell setSelectedBackgroundView:orangeView];
    
    // checked or unchecked
    int eIndex;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        eIndex = currentExercise.row;
    } else {
        eIndex = (int)indexPath.row;
    }
    if ([[_wishList objectAtIndex:eIndex] isEqualToString:@"YES"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Select
        cell.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:148.0/255.0f blue:30.0f/255.0f alpha:1.0f]; //orange BeeHive -> UIColor
        cell.textLabel.textColor = [UIColor blackColor];
    } else if ([[_wishList objectAtIndex:eIndex] isEqualToString:@"NO"]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        // Deselect
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [self.navigationController.navigationBar tintColor];
    }
    
    // cell image
    
    // subtitle
    
    
    return cell;
}

#pragma mark - Row selected

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // change flag status
    if (self.searchDisplayController.active) {
        // Invoke currentExercise for its "original" row
        BFExercise *currentExercise = [self.filteredExercises objectAtIndex:indexPath.row];
        if ([[_wishList objectAtIndex:currentExercise.row] isEqualToString:@"NO"]) {
            [_wishList replaceObjectAtIndex:currentExercise.row withObject:@"YES"];
            // make sound
            AudioServicesPlaySystemSound(1110); // see http://iphonedevwiki.net/index.php/AudioServices
        } else if ([[_wishList objectAtIndex:currentExercise.row] isEqualToString:@"YES"]) {
            [_wishList replaceObjectAtIndex:currentExercise.row withObject:@"NO"];
        }
        // refresh search result table (tableview reload data for search result table view)
        self.searchDisplayController.searchBar.text = self.searchDisplayController.searchBar.text;
    } else {
        if ([[_wishList objectAtIndex:indexPath.row] isEqualToString:@"NO"]) {
            [_wishList replaceObjectAtIndex:indexPath.row withObject:@"YES"];
            // make sound
            AudioServicesPlaySystemSound(1110); // see http://iphonedevwiki.net/index.php/AudioServices
        } else if ([[_wishList objectAtIndex:indexPath.row] isEqualToString:@"YES"]) {
            [_wishList replaceObjectAtIndex:indexPath.row withObject:@"NO"];
        }
    }
    // count
    _count = 0;
    for (int i = 0; i < _exercises.count; i++ ) {
        if ([[_wishList objectAtIndex:i] isEqualToString:@"YES"]) {
            _count++;
        }
    }
    if (_count == 0) {
        self.navigationController.navigationBar.topItem.title = @"Select in list";
    } else {
        self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%d selected in list", _count];
    }
    // reload for check and uncheck
    [_tableView reloadData];
    
}

#pragma mark - UISearchDisplayController Delegate Methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    // Custom searchBar cancel button
    UIButton *cancelButton;
    UIView *topView = searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        [cancelButton setTitle:@"End searching" forState:UIControlStateNormal];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // make sound
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchDisplayController.searchBar.text = @"";
    [searchBar resignFirstResponder];
    //    [self hideSearchBar];
}


#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText {
    // Update exercise.row
    for (int i = 0; i < _exercises.count; i++) {
        ((BFExercise*)[_exercises objectAtIndex:i]).row = i;
    }
    // Remove all objects from the filtered search array
    [self.filteredExercises removeAllObjects];
    
    for (BFExercise *exercise in _exercises) {
        if ([exercise.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [self.filteredExercises addObject:exercise];
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    for (int i = 0; i < _exercises.count; i++ ) {
        if ([[_wishList objectAtIndex:i] isEqualToString:@"YES"]) {
            // Save
            [self.exerciseListViewController.exercises addObject:[_exercises objectAtIndex:i]];
            // Save to persistent data
            [BFWorkoutList addExercise: [_exercises objectAtIndex:i] toWorkoutAtIndex: _wIndex];
        }
    }
    // Dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
