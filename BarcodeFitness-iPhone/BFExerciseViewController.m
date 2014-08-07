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

@interface BFExerciseViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BFExerciseViewController
@synthesize exercise = _exercise;
@synthesize sets = _sets;
@synthesize set = _set;


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
//    [self refreshTemplates];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init the NSMutableArray _exercises
    // we get _exercises from the stored representation, translation is performed by ... BFWorkoutList the root data class.
    if (!_sets) {
        _sets = [[NSMutableArray alloc] initWithArray:_exercise.sets];
    }
    
    // Configure navigation bar
    self.title = _exercise.name;
    
    // Configure tableview
    [_tableView setSeparatorColor:[UIColor clearColor]];

    // Notification listeners
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data management

//- (void) refreshTemplates {
//    _workoutListViewController.workoutTemplates = [BFWorkoutList getWorkoutTemplates];
//    //    NSLog(@"Templates refreshed: %@",_exercises);
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Check the sets you performed";
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
    int reps = [currentSet.reps integerValue];
    int weight = [currentSet.weight integerValue];
    int pReps = [currentSet.previousReps integerValue];
    int pWeight = [currentSet.previousWeight integerValue];
    int setNumber = [currentSet.setNumber integerValue];
    
    // Set data
    cell.textLabel.text = [NSString stringWithFormat:@"Set %d:  %d x %d lb", setNumber, reps, weight];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"vs %d x %d lb", pReps, pWeight];
    cell.setNumber = currentSet.setNumber; // This is the link betwin sets and their corresponding cell (here, the link is done at the cell creation in tableview)
    
//    // add gesture recognizers to cell
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditingCell:)];
//    longPress.delegate = self;
//    [cell addGestureRecognizer:longPress];
//    
//    
//    // add pickerView and theTextField
//    UIPickerView *pickerView = [[UIPickerView alloc] init];
//    pickerView.dataSource = self;
//    pickerView.delegate = self;
//    // ... ...
////    self.pickerTextField.inputView = pickerView;
//
//    UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, 180, 43)];
//    theTextField.delegate = self;
//    theTextField.tintColor = [UIColor clearColor];
//    theTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
//    theTextField.inputView.userInteractionEnabled = NO;
//    theTextField.textColor = [UIColor clearColor];
//    
//    theTextField.inputView = pickerView;
//
//    
//    [cell addSubview:theTextField];
//    
//    
//    // add rectangle
//    UILabel *rectangle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 43)];
////    rectangle.backgroundColor = [UIColor clearColor];
//    rectangle.layer.borderColor = [UIColor redColor].CGColor;
//    rectangle.layer.borderWidth = 1.0;
//    [cell addSubview:rectangle];
    
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
                             if (finished) {
                                 [tableView reloadData]; // reload data updates the setNumbers for cells at rendering
                             }
                         }];
        
//        // Delete to workoutTemplatesRepresentation
//        [BFWorkoutList removeExerciseAtIndex:indexPath.row fromWorkoutAtIndex:_workout.row];
//        // refresh the templates
//        [self refreshTemplates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    // exchange in workoutTemplates
//    BFExercise * movedExercise = [_exercises objectAtIndex:fromIndexPath.row];
//    [_exercises removeObjectAtIndex:fromIndexPath.row];
//    [_exercises insertObject:movedExercise atIndex:toIndexPath.row];
//    // exchange in workoutTemplatesRepresentation
//    [BFWorkoutList removeExerciseAtIndex:fromIndexPath.row fromWorkoutAtIndex:_workout.row];
//    [BFWorkoutList insertExercise:movedExercise atIndex:toIndexPath.row inWorkoutAtIndex:_workout.row];
//    // refresh the templates
//    [self refreshTemplates];
//}


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


//// Cell editing
//-(void)cellDidBeginEditing:(LOLTableViewCell *)editingCell {
//    _editingOffset = _tableView.scrollView.contentOffset.y - editingCell.frame.origin.y;
//    for(LOLTableViewCell* cell in [_tableView visibleCells]) {
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
//                             if (cell != editingCell) {
//                                 cell.alpha = 0.3;
//                             }
//                         }];
//    }
//}
//-(void)cellDidEndEditing:(LOLTableViewCell *)editingCell {
//    for(LOLTableViewCell* cell in [_tableView visibleCells]) {
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
//                             if (cell != editingCell)
//                             {
//                                 cell.alpha = 1.0;
//                             }
//                         }];
//    }
//}

- (void)startEditingCell: (UIGestureRecognizer *)gestureRecognizer {
    // begin content editing mode
    NSLog(@"Selected");
    [_tableView reloadData]; // reload data forces the update of setNumbers for cells at rendering
    
    BFExerciseViewControllerCell* editCell;
    
    //    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    CGPoint longPressLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *longPressIndexPath = [self.tableView indexPathForRowAtPoint:longPressLocation];
    editCell = (BFExerciseViewControllerCell*)[self.tableView cellForRowAtIndexPath:longPressIndexPath];
    // ...
    NSLog(@"Selected %d", (int) longPressIndexPath.row);
    
    //    }
    
//    [editCell.text becomeFirstResponder];
    //    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:longPressIndexPath.row inSection:0] animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowUIKeyboard" object:nil];
    
}


//- (void)keyboardWillShow:(NSNotification *)sender
//{
//    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
//        [_tableView setContentInset:edgeInsets];
//        [_tableView setScrollIndicatorInsets:edgeInsets];
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)sender
//{
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
//        [_tableView setContentInset:edgeInsets];
//        [_tableView setScrollIndicatorInsets:edgeInsets];
//    }];
//}

//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return 10;
//}
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 4;
//}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    return @"OK";
//}




#pragma mark - Change status 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // change Set status
    if (((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone) {
        ((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone = NO;
    } else {
        ((BFSet *)[_sets objectAtIndex:indexPath.row]).isDone = YES;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
    [tableView reloadData];
//    BFExerciseViewControllerCell* editCell = (BFExerciseViewControllerCell*)[self.tableView cellForRowAtIndexPath:indexPath];

//    [editCell.text becomeFirstResponder];

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
    // Default record SetX: 10 x 80 lb
    int reps = 10;
    int weight = 80;
    int pReps = 10;
    int pWeight = 80;
    int setNumber = _sets.count+1;
    
    // add to sets
    BFSet * newSet = [[BFSet alloc] initWithReps: reps andWeight: weight andPreviousReps: pReps andPreviousWeight:pWeight andSetNumber: setNumber];
    [_sets addObject:newSet];
    // add to tableview (bottom of list)
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_sets.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    
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
    
    NSLog(@"%@", _sets);
}

- (IBAction)youtubeButtonPressed:(UIBarButtonItem *)sender {
    
    
}

- (IBAction)finishButtonPressed:(UIBarButtonItem *)sender {
    
    
    
}

@end
