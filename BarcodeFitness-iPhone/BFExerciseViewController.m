//
//  BFExerciseViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseViewController.h"
#import "BFExercise.h"
#import "BFSet.h"
#import "BFExerciseViewControllerCell.h"
#import "BFWorkoutList.h"
#import "BFWorkout.h"
#import "BFChooseViewController.h"


@interface BFExerciseViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property NSArray * exercises;
@property (nonatomic, strong) UIBarButtonItem *upButton;
@property (nonatomic, strong) UIBarButtonItem *downButton;


@end

@implementation BFExerciseViewController
@synthesize totalNumberOfExercises = _totalNumberOfExercises;
@synthesize currentExerciseNumber = _currentExerciseNumber;
@synthesize sets = _sets;
@synthesize wIndex = _wIndex;
@synthesize workoutListViewController = _workoutListViewController; // to refresh the templates


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
    // refresh the templates
    [self refreshTemplates];
    
//    NSLog(@"Templates refreshed by viewWillDisappear : %@",_sets);

}

- (void) loadExerciseSpecifics {
    // Init the NSMutableArray _exercises
    _exercises = [[NSMutableArray alloc] initWithArray:((BFWorkout *)[_workoutListViewController.workoutTemplates objectAtIndex: _wIndex ]).exercises];
    // then we get _sets from the stored representation, translation is performed by ... BFWorkoutList the root data class.
    _sets = [[NSMutableArray alloc] initWithArray: ((BFExercise*)[_exercises objectAtIndex:_currentExerciseNumber-1]).sets]; // _exercise
    // Overwrite zeros in previous records with existing data
    // ... for set in _sets ...
    
    // Configure navigation bar
    self.title = [NSString stringWithFormat:@"%d of %d", _currentExerciseNumber, _totalNumberOfExercises];
    
    // buttons state
    if (_currentExerciseNumber == 1) {
        _upButton.enabled = NO;
    } else {
        _upButton.enabled = YES;
    }
    if (_currentExerciseNumber == _totalNumberOfExercises) {
        _downButton.enabled = NO;
    } else {
        _downButton.enabled = YES;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Right side navigation shortcuts buttons
    _upButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_up"] style:UIBarButtonItemStylePlain target:self action:@selector(upButtonPressed)];
    _downButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_down"] style:UIBarButtonItemStylePlain target:self action:@selector(downButtonPressed)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: _downButton, _upButton, nil]];
    
    // Init data
    [self loadExerciseSpecifics];
    
    // Configure tableview
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    // configure background
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    self.toolBar.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];


    // Notification listeners for scroll to visible
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Configure button colors
//    _toolBar.tintColor = [UIColor orangeColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data management

- (void) refreshTemplates {
    _workoutListViewController.workoutTemplates = [BFWorkoutList getWorkoutTemplates];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((BFExercise*)[_exercises objectAtIndex:_currentExerciseNumber-1]).name; // _exercise
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.sets.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BFSet * currentSet = [self.sets objectAtIndex:indexPath.row];
    
    NSString * cellIdentifier = currentSet.isDone ? @"doneSetCell" : @"setCell";
    
    BFExerciseViewControllerCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];

    
    // Get data
    NSString* reps = [currentSet.reps stringValue];
    NSString* weight = [currentSet.weight stringValue];
    NSString* pReps = [currentSet.previousReps stringValue];
    NSString* pWeight = [currentSet.previousWeight stringValue];
    int setNumber = [currentSet.setNumber intValue];
    
    // Set data
    cell.textLabel.text = [NSString stringWithFormat:@"Set %d:  %@ x %@ lb", setNumber, reps, weight];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"vs %@ x %@ lb", pReps, pWeight];
    cell.set = currentSet; // This is the link betwin sets and their corresponding cell (here, the link is done at the cell creation in tableview)
    cell.sIndex = (int) indexPath.row;
    cell.eIndex = _currentExerciseNumber-1;
    cell.wIndex = _wIndex;
    cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    
    
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
        [_sets removeObjectAtIndex:indexPath.row];
        // Update setNumbers in _sets
        for (int i = 0; i < _sets.count; i++) {
            ((BFSet*)[_sets objectAtIndex:i]).setNumber = [NSNumber numberWithInt:i+1];
        }
        // reload data kills amimations... that it the trick to get around
        [UIView animateWithDuration:1.2
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionCurlDown | UIViewAnimationOptionAllowUserInteraction)
                         animations:^(void) {
                             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                         }
                         completion:^(BOOL finished) {
                             if (finished && (indexPath.row != _sets.count)) { // no need to reload data if we delete the last row
                                 [tableView reloadData]; // reload data updates the setNumbers for cells at rendering
                             }
                         }];
        
        // Delete to workoutTemplatesRepresentation
        [BFWorkoutList removeSetAtIndex:indexPath.row fromExerciseAtIndex:_currentExerciseNumber-1 inWorkoutAtIndex:_wIndex];
        // refresh the templates
        [self refreshTemplates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return ![self.tableView isEditing];
//}


#pragma mark - Edit content

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height - 44, 0);
        [_tableView setContentInset:edgeInsets];
        [_tableView setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
        [_tableView setContentInset:edgeInsets];
        [_tableView setScrollIndicatorInsets:edgeInsets];
    }];
}



#pragma mark - Change status 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // change Set status
    // + change status is persistent data
    if (((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone) {
        ((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone = NO;
        [BFWorkoutList setIsDone:NO atIndex:(int)indexPath.row toExerciseAtIndex:_currentExerciseNumber-1 inWorkoutAtIndex:_wIndex];
    } else {
        ((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone = YES;
        [BFWorkoutList setIsDone:YES atIndex:indexPath.row toExerciseAtIndex:_currentExerciseNumber-1 inWorkoutAtIndex:_wIndex];
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        AudioServicesPlaySystemSound(1054); // see http://iphonedevwiki.net/index.php/AudioServices

        
    }
    
    [tableView reloadData];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@""]){

        
    } else if ([segue.identifier isEqualToString:@""]) {

    }
    
}



#pragma mark - IBActions

- (IBAction)addSet:(UIBarButtonItem *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_sets.count inSection:0];

    // Default record SetX: 10 x 30 lb
    int reps;
    float weight;
    if (indexPath.row > 0) {
        reps = [((BFSet *)[_sets objectAtIndex:indexPath.row-1]).reps intValue];
        weight = [((BFSet *)[_sets objectAtIndex:indexPath.row-1]).weight floatValue];
    } else {
        reps = 10;
        weight = 30;
    }
    int pReps = 0;
    float pWeight = 0;
    int setNumber = _sets.count+1;
    
    // Add to sets
    BFSet * newSet = [[BFSet alloc] initWithReps: reps andWeight: weight andPreviousReps: pReps andPreviousWeight:pWeight andSetNumber: setNumber andIsDone: NO];
    [_sets addObject:newSet];
    // Add to tableview (bottom of list)
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    // Add to workoutTemplatesRepresentation
    [BFWorkoutList addSet:newSet atIndex:indexPath.row toExerciseAtIndex:_currentExerciseNumber-1 inWorkoutAtIndex:_wIndex];
    
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
    
//    NSLog(@"%@", _sets);
}

- (IBAction)youtubeButtonPressed:(UIBarButtonItem *)sender {
    
    
}


#pragma mark - Other actions

- (void) upButtonPressed {
    [self refreshTemplates];
    _currentExerciseNumber--;
    [self loadExerciseSpecifics];
    [self.tableView reloadData];
    // make sound
    AudioServicesPlaySystemSound(1101); // see http://iphonedevwiki.net/index.php/AudioServices
}

- (void) downButtonPressed {
    [self refreshTemplates];
    _currentExerciseNumber++;
    [self loadExerciseSpecifics];
    [self.tableView reloadData];
    // make sound
    AudioServicesPlaySystemSound(1101); // see http://iphonedevwiki.net/index.php/AudioServices
}



@end
