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
#import "BFSet.h"
#import "BFExerciseListViewController.h"
#import "BFWorkoutNoteCell.h"


@interface BFWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) int duration;
@property (nonatomic) BOOL takingNote;
@property (nonatomic) BOOL shouldAddInfoCell;

@property (nonatomic) int timeSpentInWorkout;

@end


@implementation BFWorkoutViewController
@synthesize workout = _workout;
@synthesize exercises = _exercises;
@synthesize workoutListViewController = _workoutListViewController; // to refresh the templates

@synthesize workoutBeginTime = _workoutBeginTime;
@synthesize timerBeginTime = _timerBeginTime;
@synthesize restTimeEndedNotification = _restTimeEndedNotification;

static int currentRestTime;
static int restTime;
static bool resting;
static int mode; // 0 = Auto, 1 = Manu, 2 = Off


@synthesize finishFlag = _finishFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {    
    // refresh the templates
    [self refreshTemplates];
//    NSLog(@"viewWillAppear: %@",_exercises);
//    NSLog(@"B: %@",_workout);
//    NSLog(@"C: %d",_workout.row);
//    for(BFWorkout* w in _workoutListViewController.workoutTemplates) {
//        NSLog(@"> %@ Row: %d",w, w.row);
//    }
    [self.tableView reloadData];
    
    if (_finishFlag) {
        [self performSelector: @selector(finishButtonPressed:) withObject:self afterDelay: 0.0];
    }
    
    _takingNote = NO;
}


- (void) reloadWorkoutSpecifics {
    int wIndex = (int)_workout.row; // preserve _workout.row 
    _workout = nil;
    _exercises = nil;
    _workout = [[BFWorkoutList getWorkoutTemplates] objectAtIndex:wIndex];
    _exercises = [[NSMutableArray alloc] initWithArray:_workout.exercises];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init the NSMutableArray _exercises
    // we get _exercises from the stored representation, translation is performed by ... BFWorkoutList the root data class. 
    _exercises = nil;
    _exercises = [[NSMutableArray alloc] initWithArray:_workout.exercises];
    
    // Configure navigation bar
    self.title = _workout.name;
    _workoutBeginTime = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startWorkout) userInfo:nil repeats:YES];
    // configure back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // Configure background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"metalBackground"]];
//    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    self.toolBar.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Fonte"]];
    
    // Other colors
    [_tableView setSeparatorColor:[UIColor blackColor]];
    
    // Configure finish button
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                    NSForegroundColorAttributeName: [UIColor orangeColor],
                                    NSShadowAttributeName: shadow,
                                    NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18.0]}
                                                          forState: UIControlStateNormal];
    // [self.navigationController.navigationBar tintColor] [UIColor colorWithRed:50.0/255.0 green:220.0/255.0 blue:25.0/255.0 alpha:1.0]
    
//     [NSDictionary dictionaryWithObjectsAndKeys:
//                        [UIFont fontWithName:@"Helvetica-Bold" size:18.0],  NSFontAttributeName,
//                        [UIColor whiteColor],                               NSForegroundColorAttributeName,
//                        nil]
//                            forState:UIControlStateNormal];
    
    // Configure button colors
    _toolBar.tintColor = [UIColor orangeColor];
    
    
    // Create timer notification
    if(!_restTimeEndedNotification) {
        _restTimeEndedNotification = [[UILocalNotification alloc] init];
    }
    restTime = [[[NSUserDefaults standardUserDefaults] objectForKey:kRestTime] intValue];
    if (restTime == 0) {
        restTime = 5; // default minimum (Or can we put 42? Because 42 is... :D)
    }
    mode = [[[NSUserDefaults standardUserDefaults] objectForKey:kMode] intValue];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kMode] == nil) {
        mode = 1; // default: Manual
    }
    currentRestTime = restTime;
    _restTimeEndedNotification.alertBody = [NSString stringWithFormat:@"%@ rest time is finished!", [BFWorkoutViewController timeFormatted2:restTime]];
    _restTimeEndedNotification.soundName = UILocalNotificationDefaultSoundName; // see http://iphonedevwiki.net/index.php/AudioServices
    _restTimeEndedNotification.applicationIconBadgeNumber = 1;
    
    [BFWorkoutViewController setResting:NO];
    _finishFlag = NO;
    
    // Notification listeners for scroll to visible
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Info cell
    _shouldAddInfoCell = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Timer

// timer action
- (void) startWorkout {
    _timeSpentInWorkout = [[NSDate date] timeIntervalSinceDate:_workoutBeginTime];
    self.title = [BFWorkoutViewController timeFormatted:_timeSpentInWorkout];
}

+ (NSString *)timeFormatted: (int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSString *)timeFormatted2: (int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)timeFormatted3: (int)totalSeconds {
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (totalSeconds < 3600) {
        return [NSString stringWithFormat:@"%d min", minutes];
    } else if (totalSeconds == 3600){
        return @"1 h";
    } else {
        return [NSString stringWithFormat:@"%d h %d min", hours, minutes];
    }
}

+ (BOOL) resting {
    return resting;
}

+ (void) setResting: (BOOL) answer {
    resting = answer;
}

+ (int) restTime {
    return restTime;
}

+ (void) setRestTime: (int) answer {
    restTime = answer;
}

+ (void) saveRestTime {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:restTime] forKey:kRestTime];
}

+ (int) currentRestTime {
    return currentRestTime;
}

+ (void) setCurrentRestTime: (int) answer {
    currentRestTime = answer; 
}

+ (int) mode {
    return mode;
}

+ (void) setMode: (int) answer {
    mode = answer;
}

+ (void) saveMode {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:mode] forKey:kMode];
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
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _workout.name;
    } else {
//        return @"Your notes";
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if (self.exercises.count == 0) {
            if (_shouldAddInfoCell){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            return 1;
        } else {
            return self.exercises.count;
        }
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Black"]];
        //    cell.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.1];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        if (_exercises.count == 0) { // Info cell
            cell.textLabel.text = @"No exercises yet.";
            cell.detailTextLabel.text = @"Use \"Add exercise\" to create new exercises.";
            cell.textLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.imageView.image = nil;
        } else {
            // Configure the cell...
            BFExercise * currentExercise;
            currentExercise = [self.exercises objectAtIndex:indexPath.row];
            
            cell.textLabel.text = currentExercise.name;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIView *orangeView = [[UIView alloc] init];
            orangeView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:148.0/255.0f blue:30.0f/255.0f alpha:1.0f]; //orange BeeHive -> UIColor
            [cell setSelectedBackgroundView:orangeView];
            
            // cell image
            float numberOfSetsDone = 0;
            float totalWeight = 0;
            float numberOfSets = currentExercise.sets.count;
            for (BFSet* set in currentExercise.sets) {
                if (set.isDone) {
                    numberOfSetsDone++;
                }
                totalWeight = totalWeight + [set.weight floatValue];
            }
            float pourcent = 0;
            if (currentExercise.sets.count != 0) {
                pourcent = numberOfSetsDone/numberOfSets;
                cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pie%.f.png", 60*pourcent]];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"pieV.png"];
            }
            // subtitle
            NSString* setWord;
            if (numberOfSets > 1) {
                setWord = @"sets";
            } else {
                setWord = @"set";
            }
            if ((int)totalWeight == totalWeight) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %.f%% of %.f %@, Total: %.f lb", currentExercise.company, 100*pourcent,numberOfSets, setWord, totalWeight];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %.f%% of %.f %@, Total: %.1f lb", currentExercise.company, 100*pourcent,numberOfSets, setWord, totalWeight];
            }
            
            //    NSLog(@"%@", currentExercise.name);
            //    NSLog(@"1- %@", _exercises);
        }
        return cell;
        
    } else {
        // Note cell
        BFWorkoutNoteCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
        cell.wIndex = (int)_workout.row;
        cell.workout = _workout;
        if ([_workout.note isEqualToString:@""]) {
            cell.textView.text = @"Your notes...";
        } else {
            cell.textView.text = _workout.note;
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Custom header background
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.backgroundView.backgroundColor = [UIColor darkGrayColor];
}


#pragma mark - Edit modes


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0 && _exercises.count != 0) {
        return YES;
    } else {
        return NO;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Info cell
        _shouldAddInfoCell = YES;
        // Delete the row from the data source workoutTemplates
        [_exercises removeObjectAtIndex:indexPath.row];
        [UIView animateWithDuration:1.2
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionCurlDown)
                         animations:^(void) {
                             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                         }
                         completion:nil];
        // Delete to workoutTemplatesRepresentation
        [BFWorkoutList removeExerciseAtIndex:(int)indexPath.row fromWorkoutAtIndex:(int)_workout.row];
        // Update weight data
        [BFWorkoutList computeWeightForWorkoutAtIndex:(int)_workout.row];
        // refresh the templates
        [self refreshTemplates];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if(toIndexPath.section == 0) {
        // exchange in _exercises
        BFExercise * movedExercise = [_exercises objectAtIndex:fromIndexPath.row];
        [_exercises removeObjectAtIndex:fromIndexPath.row];
        [_exercises insertObject:movedExercise atIndex:toIndexPath.row];
        // exchange in workoutTemplatesRepresentation
        [BFWorkoutList removeExerciseAtIndex:(int)fromIndexPath.row fromWorkoutAtIndex:_workout.row];
        [BFWorkoutList insertExercise:movedExercise atIndex:(int)toIndexPath.row inWorkoutAtIndex:(int)_workout.row];
        // refresh the templates
        [self refreshTemplates];
    } else {
        [_tableView reloadData];
    }
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Edit content & auto scoll

- (void)keyboardWillShow:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height - 44, 0);
    [_tableView setContentInset:edgeInsets];
    [_tableView setScrollIndicatorInsets:edgeInsets];
    // force to scroll
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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


#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to detail
    if (indexPath.section == 0 && _exercises.count != 0) {
        [self performSegueWithIdentifier:@"startExercise" sender:tableView];
    } else {
        // Deselect
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addExercise"]){
        UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
        
        // For Scan
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0]; // Scan in 1st position
        BFScanViewController * scanViewController = [[navigationController viewControllers] objectAtIndex:0];
        scanViewController.exerciseListViewController = self;
        scanViewController.wIndex = _workout.row; // workout.row gives the true original index of the current workout (created for research mode use)
        
        // For List
        navigationController = [[tabBarController viewControllers] objectAtIndex:1]; // List in 2nd position
        BFExerciseListViewController * exerciseListViewController = [[navigationController viewControllers] objectAtIndex:0];
        exerciseListViewController.exerciseListViewController = self;
        exerciseListViewController.wIndex = _workout.row;
        
        // For Body
        
        
        // For Magic
        
        
        
    } else if ([segue.identifier isEqualToString:@"startExercise"]) {
        [self refreshTemplates];
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        BFExerciseViewController *destViewController = segue.destinationViewController;
        destViewController.currentExerciseNumber = (int)indexPath.row + 1;
        destViewController.totalNumberOfExercises = (int)_exercises.count;
        destViewController.wIndex = _workout.row;
        destViewController.workoutListViewController = _workoutListViewController; // for template refresh
        destViewController.exerciseListViewController = self; // for pies
    }
    
}

-(BOOL) navigationShouldPopOnBackButton {
    // Confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?"
                                                    message:@"Your performance will NOT be saved in history."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Quit",nil];
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
    // Select all in note
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITextView * textView = ((BFWorkoutNoteCell*)[_tableView cellForRowAtIndexPath:indexPath]).textView;
    [textView selectAll:self];
    if ([textView.text isEqualToString: @"Your notes..."]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
    
}

- (IBAction)finishButtonPressed:(UIBarButtonItem *)sender {
    _finishFlag = NO;
    // Update weight data
    float totalWeight = [BFWorkoutList computeWeightForWorkoutAtIndex:(int)_workout.row]; // this is a compulsory pass point for getting out
    // texts
    float totalDoneWeight = 0;
    for (int eIndex = 0; eIndex < _exercises.count; eIndex++) {
        for (BFSet * set in ((BFExercise*)[_exercises objectAtIndex:eIndex]).sets) {
            if (set.isDone) {
                totalDoneWeight += [set.weight floatValue];
            }
        }
    }
    NSString * title;
    NSString * message;
    _duration = [[NSDate date] timeIntervalSinceDate:_workoutBeginTime];
    if(totalWeight == 0) {
        // Empty workout
        [self empltyWorkoutCase];
    } else {
        // None emplty workout cases
        if (totalDoneWeight == totalWeight) {
            if ((int)totalWeight == totalWeight) {
                title = [NSString stringWithFormat:@"You have finished your workout! Total lifted: %.f lb. Duration: %@", totalWeight, [BFWorkoutViewController timeFormatted3:_duration]];
            } else {
                title = [NSString stringWithFormat:@"You have finished your workout! Total lifted: %.1f lb. Duration: %@", totalWeight, [BFWorkoutViewController timeFormatted3:_duration]];
            }
            message = @"Your performance will be saved in history.";
        } else {
            if ((int)totalWeight == totalWeight && (int)totalDoneWeight == totalDoneWeight) {
                title = [NSString stringWithFormat:@"You have only lifted %.f lb over %.f lb. (%.1f%%) Duration: %@", totalDoneWeight, totalWeight, totalDoneWeight/totalWeight*100, [BFWorkoutViewController timeFormatted3:_duration]];
            } else if ((int)totalWeight == totalWeight) {
                title = [NSString stringWithFormat:@"You have only lifted %.1f lb over %.f lb. (%.1f%%) Duration: %@", totalDoneWeight, totalWeight, totalDoneWeight/totalWeight*100, [BFWorkoutViewController timeFormatted3:_duration]];
            }  else if ((int)totalDoneWeight == totalDoneWeight) {
                title = [NSString stringWithFormat:@"You have only lifted %.f lb over %.1f lb. (%.1f%%) Duration: %@", totalDoneWeight, totalWeight, totalDoneWeight/totalWeight*100, [BFWorkoutViewController timeFormatted3:_duration]];
            } else {
                title = [NSString stringWithFormat:@"You have only lifted %.1f lb over %.1f lb. (%.1f%%) Duration: %@", totalDoneWeight, totalWeight, totalDoneWeight/totalWeight*100, [BFWorkoutViewController timeFormatted3:_duration]];
            }
            message = @"Your performance will be saved in history.";
        }
        // Confirmation
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Finish",nil];
        alert.tag = 2;
        [alert show];
    }
        
}

- (void) empltyWorkoutCase {
    // Confirmation
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your workout is empty. Total weight is 0 lb!"
                                                    message:@"Please add weight using \"Add exercise\" to create new exercises in your workout, and \"Add set\" to create sets in each exercise. In an exercise, you can touch a set record text to adjust reps and weights."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    // No second button, no action
    [alert show];
}

#pragma mark - Action result

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // preserve _workout.row before refreshing 
        int wIndex = (int)_workout.row;
        // Update weight data
//        [BFWorkoutList computeWeightForWorkoutAtIndex:wIndex]; // this is a compulsory pass point for getting out (this line is not compulsory, just sanity check)
        // refresh templates reload specifics
        [self refreshTemplates];
        [self reloadWorkoutSpecifics];
        // reset all sets status of each exercise
//        NSLog(@"%@",_exercises);
        for (int eIndex = 0; eIndex < _exercises.count; eIndex++) {
            for (int sIndex = 0; sIndex < ((BFExercise*)[_exercises objectAtIndex:eIndex]).sets.count ; sIndex++) {
                [BFWorkoutList setIsDone:NO atIndex:sIndex toExerciseAtIndex:eIndex inWorkoutAtIndex:wIndex];
            }
        }
        // Cancel notification
        [[UIApplication sharedApplication] cancelLocalNotification:_restTimeEndedNotification];
        // refresh templates (to reset pies)
        [self refreshTemplates];
        if (alertView.tag == 1) {
            // back to  launcher
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // Update last date and duration
            [BFWorkoutList setDuration:_duration forWorkoutAtIndex:wIndex];
            [BFWorkoutList setLastDate:[NSDate date] forWorkoutAtIndex:wIndex];
            // Store in history
            // ...
            
            
            
            // back to home screen
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


@end
