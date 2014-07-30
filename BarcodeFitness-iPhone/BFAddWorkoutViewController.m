//
//  BFAddWorkoutViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/22/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFAddWorkoutViewController.h"
#import "BFChooseViewController.h"
#import "BFWorkoutList.h"
#import "BFWorkout.h"

@interface BFAddWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BFAddWorkoutViewController 
@synthesize workoutListViewController = _workoutListViewController;
@synthesize workout = _workout;
@synthesize segueIdentifier = _segueIdentifier;
@synthesize renameRow = _renameRow;

#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)saveButtonPressed:(UIBarButtonItem *)sender {

    
    // save
    if ([_segueIdentifier isEqualToString:@"addWorkout"]) {
        // save to workoutTemplates
        BFWorkout *newWorkout = [[BFWorkout alloc] initWithName:self.nameField.text];
        [self.workoutListViewController.workoutTemplates addObject:newWorkout];
        // save to workoutTemplatesRepresentation
        [BFWorkoutList addObject:newWorkout];

        
//        NSString * newKey = [[NSDate date] description];
        // set BFWorkout in BFWorkoutList
//        [BFWorkoutList setWorkout:newWorkout forKey:newKey];
        // set key
//        [BFWorkoutList setCurrentKey:newKey];
        // now workoutTemplates will only hold keys, so we will call is workoutListKeys
//        [self.workoutListViewController.workoutTemplates addObject:newKey];
        
    } else {
        // set changes to the workout in workoutTemplates
        _workout.name = self.nameField.text;
        //_workout.image = ...
        
        // set changes to the workout in workoutTemplatesRepresentation
        [BFWorkoutList setWorkoutName: self.nameField.text atIndex: _renameRow];
        //[BFWorkoutList setWorkoutImage: self.... atIndex: _renameRow];
        
        
    }
    
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Begin

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    int number = (int) _workoutListViewController.workoutTemplates.count; //number of existing workouts
    if ([_segueIdentifier isEqualToString:@"addWorkout"]) {
        self.navigationItem.title = @"Add workout";
        self.nameField.text = [NSString stringWithFormat: @"Workout #%i", number+1];
        self.nameField.textColor = [UIColor grayColor];
    } else {
        self.navigationItem.title = @"Edit workout";
        if ([self.workout.name isEqualToString:@""]) {
            self.nameField.text = [NSString stringWithFormat: @"Workout #%i", _renameRow+1];
            self.nameField.textColor = [UIColor grayColor];
        } else {
            self.nameField.text = self.workout.name;
        }
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

- (void) hideKeyboard {
    [_nameField resignFirstResponder]; // resignFistResponder on touch outside

}

- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    [iTextField selectAll:self];
    self.nameField.textColor = [UIColor blackColor];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES]; // resignFistResponder on touch outside, doesn't work in tableview
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
