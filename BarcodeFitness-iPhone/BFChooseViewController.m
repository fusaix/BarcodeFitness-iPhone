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
#import "BFChooseViewControllerCell.h"


@interface BFChooseViewController ()
@property (nonatomic) int selectedRow;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray *filteredWorkoutTemplates;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *magicButton;
@property (nonatomic) BOOL noteMode;

@end

@implementation BFChooseViewController
@synthesize workoutTemplates = _workoutTemplates;

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
    // reload table 
    [self.tableView reloadData];
    // refresh search result table
    self.searchDisplayController.searchBar.text = self.searchDisplayController.searchBar.text;
    // update workout.row
    for (int i = 0; i < self.workoutTemplates.count; i++) {
        ((BFWorkout*)[_workoutTemplates objectAtIndex:i]).row = i;
    }
    // Magic Button
    _magicButton.enabled = YES;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    // hide search bar
//    if (!self.searchDisplayController.isActive) {
//        [UIView animateWithDuration:0.5
//                              delay:1.0
//                            options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction)
//                         animations:^(void) {
//                             [self hideSearchBar];
//                         }
//                         completion:nil];
//    }
////completion:^(BOOL finished) {
////    if (finished) {
////    }
////}];
//    
//}

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
    
    // configure back button 
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // configure background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"metalBackground"]];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    //    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    self.toolBar.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Fonte"]];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView* viewBackground = [[UIView alloc] initWithFrame:frame];
    [viewBackground setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"GameImage"]]];
    [self.tableView addSubview:viewBackground]; // fix for the top of search bar
    
    // other colors
    [_tableView setSeparatorColor:[UIColor blackColor]];
    [self.searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor blackColor]];
    
    // Configure button colors
    _toolBar.tintColor = [UIColor orangeColor]; 
    
    // Configure search bar text color
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    // self.edgesForExtendedLayout = UIRectEdgeNone; is not useful for the search bar glitch : the solution is to check "Under Oparque bars" in the storyboard for this view controller!!!
    
    // Note Mode or Detail Mode
    _noteMode = NO; // Detail Mode
    
    // show navigation bar
    [self.navigationController setNavigationBarHidden: NO animated:YES];
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
//    return nil;
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
//    UITableViewCell *cell; replaced by custom cell
    BFChooseViewControllerCell *cell;

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    // Configure the cell...
    BFWorkout * currentWorkout;
    if (tableView == self.searchDisplayController.searchResultsTableView) { // if research mode
        currentWorkout = [self.filteredWorkoutTemplates objectAtIndex:indexPath.row];
    } else { // else default mode
        currentWorkout = [self.workoutTemplates objectAtIndex:indexPath.row];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    cell.textLabel.text = currentWorkout.name;
    
    // description
    float totalWeight = [currentWorkout.totalWeight floatValue];
    

//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
//    NSDate *lastDate = [df dateFromString: @"2014-08-29 1:11:11 am"];
    NSString * lastDateText = [self lastDateTextDependingOnLastDate:currentWorkout.lastDate];
    
    
    if (_noteMode) {     // if in note mode
        if ([currentWorkout.note isEqualToString:@""]) {
            cell.detailTextLabel.text = @"No notes"; 
        } else {
            cell.detailTextLabel.text = currentWorkout.note;
        }
    } else {
        if ((int)totalWeight  == totalWeight) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, Last: %@, Total: %.f lb", lastDateText, [BFWorkoutViewController timeFormatted3:[currentWorkout.duration intValue]], totalWeight];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, Last: %@, Total: %.1f lb", lastDateText, [BFWorkoutViewController timeFormatted3:[currentWorkout.duration intValue]], totalWeight];
        }
    }
    
    cell.imageView.image = currentWorkout.image;
    cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Black"]];
//    cell.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1]; // 0.1
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory"]];
    UIView *orangeView = [[UIView alloc] init];
    orangeView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:148.0/255.0f blue:30.0f/255.0f alpha:1.0f]; //orange BeeHive -> UIColor
    [cell setSelectedBackgroundView:orangeView];


//    NSLog(@"%@", currentWorkout.name);
//    NSLog(@"1- %@", _workoutTemplates);
//    NSLog(@"2- %@", _filteredWorkoutTemplates);
    
    return cell;
}

// compute days between two NSDate
// issues in http://stackoverflow.com/questions/4739483/number-of-days-between-two-nsdates So, this is my solution
- (NSString*)lastDateTextDependingOnLastDate:(NSDate*)lastDate {
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"EST"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:timeZone];
//    NSString *newDate = [dateFormatter stringFromDate:now];
//    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
//    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *todayInAtlanta = [newDateFormatter dateFromString:newDate];
//    NSLog(@"%@", todayInAtlanta);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* c1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
               fromDate:lastDate];
    NSDateComponents* c2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
               fromDate:[NSDate date]];
    NSDateComponents* c3 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                       fromDate:[self yesterdayDate]];
    
    if ([c1 day] == [c2 day] && [c1 month] == [c2 month] && [c1 year] == [c2 year]) {
        return @"Today";
    } else if ([c1 day] == [c3 day] && [c1 month] == [c3 month] && [c1 year] == [c3 year]){
        return @"Yesterday";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        return [dateFormatter stringFromDate:lastDate];
    }

}

- (NSDate*) yesterdayDate {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-1];
    NSDate *yesterdayDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
//    NSLog(@"%@", yesterdayDate);

    return yesterdayDate;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

// Custom header background
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.backgroundView.backgroundColor = [UIColor darkGrayColor];
}

#pragma mark - Search Bar

- (void) hideSearchBar {
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchDisplayController.searchBar.bounds.size.height;
    self.tableView.bounds = newBounds;
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
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchDisplayController.searchBar.text = @"";
    [searchBar resignFirstResponder];
//    [self hideSearchBar];
}


#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText {
    // update workout.row
    for (int i = 0; i < self.workoutTemplates.count; i++) {
        ((BFWorkout*)[_workoutTemplates objectAtIndex:i]).row = i;
    }
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
            // replace cell deletion but without animation :(
            self.searchDisplayController.searchBar.text = self.searchDisplayController.searchBar.text;
            [self.tableView reloadData];
            // Delete to workoutTemplatesRepresentation
            [BFWorkoutList removeObjectAtIndex: currentWorkout.row];
            // anti edit mode glitch
            tableView.editing = !tableView.editing;
        } else {
            // Delete the row from the data source workoutTemplates
            [self.workoutTemplates removeObjectAtIndex:indexPath.row];
//            CGRect newBounds = self.tableView.bounds;
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            self.tableView.bounds = newBounds;
            [UIView animateWithDuration:1.2
                                  delay:0.0
                                options:(UIViewAnimationOptionTransitionCurlDown)
                             animations:^(void) {
                                             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                             }
                             completion:nil];
            // Delete to workoutTemplatesRepresentation
            [BFWorkoutList removeObjectAtIndex: (int) indexPath.row];
            // reload data KILLS animations !!!!!!!!!!!!!!! so we'll use a trick to update the rows
            //            for (BFWorkout *workout in self.workoutTemplates) {
            //                workout.row = (int) indexPath.row;
            //            }
            for (int i = 0; i < self.workoutTemplates.count; i++) {
                ((BFWorkout*)[_workoutTemplates objectAtIndex:i]).row = i;
            }
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
        self.selectedRow = currentWorkout.row;
    } else {
        self.selectedRow = (int) indexPath.row;
    }
    [self performSegueWithIdentifier:@"editWorkout" sender:tableView];
    
}

#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Store selected index
    _selectedRow = (int) indexPath.row;
    // Perform segue to detail
    [self startWorkout];
}

- (void) startWorkout {
    [self performSegueWithIdentifier:@"startWorkout" sender:_tableView];
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
        addWorkoutViewController.workout = [_workoutTemplates objectAtIndex:self.selectedRow]; // self.tableView.indexPathForSelectedRow.row does not apply
        addWorkoutViewController.renameRow = self.selectedRow; // for the automatic name suggestion
        addWorkoutViewController.segueIdentifier = @"editWorkout";
    } else if ([segue.identifier isEqualToString:@"startWorkout"]) {
        // updated true all workout.row by a capture of workoutTemplates
        for (int i = 0; i < self.workoutTemplates.count; i++) {
            ((BFWorkout*)[_workoutTemplates objectAtIndex:i]).row = i;
        }
//        for(BFWorkout* w in _workoutTemplates) {
//            NSLog(@"> %@ Row: %d",w, w.row);
//        }
        
        // process the information to pass
        BFWorkout *workout;
        if (self.searchDisplayController.active) {
            workout = [_filteredWorkoutTemplates objectAtIndex:_selectedRow]; // self.tableView.indexPathForSelectedRow.row does not apply
        } else {
            workout = [_workoutTemplates objectAtIndex:_selectedRow]; // NSIndexPath *indexPath = [sender indexPathForSelectedRow]; could be used for him
        }
        BFWorkoutViewController *destViewController = segue.destinationViewController;
        destViewController.workoutListViewController = self; // to refresh templates
        destViewController.workout = workout;
    }
}

#pragma mark - IBActions

- (IBAction)addWorkout:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addWorkout" sender:self];
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    if (!self.tableView.isEditing) {
        [self.tableView setEditing:YES animated:YES];
    } else {
        [self.tableView setEditing:NO animated:YES];
        
    }
//    self.tableView.editing = !self.tableView.editing; // not a tableViewController so use the "self.tableView.editing" in stead of "self.editing"

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

- (IBAction)magicButtonPressed:(UIBarButtonItem *)sender { // dice
    int i = arc4random() % _workoutTemplates.count;
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    _magicButton.enabled = NO;
    _selectedRow = i;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startWorkout) userInfo:nil repeats:NO];
}

- (IBAction)infoButtonPressed:(UIBarButtonItem *)sender {
    _noteMode = !_noteMode;
    [_tableView reloadData];
}


@end
