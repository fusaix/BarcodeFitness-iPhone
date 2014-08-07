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
#import "BFCollectionViewCell.h"

@interface BFAddWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) NSMutableArray *workoutImages;

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

        
    } else { // isEqualToString:@"editWorkout"
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
    
    // Gesture to hide keyboard
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    // Load Names of Images
    _workoutImages = [@[@"BarcodeFitnessIcon120.png",
                        @"Monday.png",
                        @"Tuesday.png",
                        @"Wednesday.png",
                        @"Thursday.png",
                        @"Friday.png",
                        @"Saturday.png",
                        @"Sunday.png",
                        @"Everyday.png"] mutableCopy];
    
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

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _workoutImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BFCollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    image = [UIImage imageNamed:_workoutImages[row]];
    
    myCell.imageView.image = image;
    
    return myCell;
}


@end
