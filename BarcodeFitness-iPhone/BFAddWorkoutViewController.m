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
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) int newImageIndex;

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
        BFWorkout *newWorkout = [[BFWorkout alloc] initWithName:self.nameField.text andImage:_newImageIndex];
        [self.workoutListViewController.workoutTemplates addObject:newWorkout];
        // save to workoutTemplatesRepresentation
        [BFWorkoutList addObject:newWorkout];

        
    } else { // isEqualToString:@"editWorkout"
        // set changes to the workout in workoutTemplates
        _workout.name = self.nameField.text;
        _workout.image = [UIImage imageNamed:_workoutImages[_newImageIndex]];
        _workout.imageIndex = [NSNumber numberWithInt:_newImageIndex];
        
        // set changes to the workout in workoutTemplatesRepresentation
        [BFWorkoutList setWorkoutName: self.nameField.text atIndex: _renameRow];
        [BFWorkoutList setWorkoutImage: [NSNumber numberWithInt:_newImageIndex] atIndex: _renameRow];
        
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
    
    // Get today's date for day of week
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    _nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//    int number = (int) _workoutListViewController.workoutTemplates.count; //number of existing workouts
    if ([_segueIdentifier isEqualToString:@"addWorkout"]) {
        self.navigationItem.title = @"Add workout";
        self.nameField.text = [NSString stringWithFormat: @"%@ - ", [dateFormatter stringFromDate:[NSDate date]]];
        self.nameField.textColor = [UIColor grayColor];
    } else {
        self.navigationItem.title = @"Edit workout";
        if ([self.workout.name isEqualToString:@""]) {
            self.nameField.text = [NSString stringWithFormat: @"%@ - ", [dateFormatter stringFromDate:[NSDate date]]];
            self.nameField.textColor = [UIColor grayColor];
        } else {
            self.nameField.text = self.workout.name;
        }
    }
    
    // Gesture to hide keyboard
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    // Load Names of Images
    _workoutImages = [@[@"BarcodeFitnessIconRounded.png",
                        @"Monday_sf.png",
                        @"Tuesday_sf.png",
                        @"Wednesday_sf.png",
                        @"Thursday_sf.png",
                        @"Friday_sf.png",
                        @"Saturday_sf.png",
                        @"Sunday_sf.png",
                        @"Everyday_sf.png",
                        @"Buzz_rounded.png"] mutableCopy];

    // Image
    if ([_segueIdentifier isEqualToString:@"addWorkout"]) {
        // automatically choose the image of the day
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        int weekday = (int)[comps weekday];
        _newImageIndex= weekday - 1;
        if (_newImageIndex == 0) _newImageIndex = 7;
    } else {
        _newImageIndex = [_workout.imageIndex intValue];
    }
    
    // auto center
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:_newImageIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // Keyboard
    [_nameField setReturnKeyType:UIReturnKeyDone];
    
    // collection view background
//    self.collectionView.backgroundColor = [UIColor blackColor];
    
    // configure button colors
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];

}

- (void) hideKeyboard {
    [_nameField resignFirstResponder]; // resignFistResponder on touch outside

}

- (void)textFieldDidBeginEditing:(UITextField *)iTextField {
    if ([_segueIdentifier isEqualToString:@"editWorkout"]) { // if edit mode
        [iTextField selectAll:self]; // Select all field.
    }
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

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _workoutImages.count;
}

-(BFCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    UIImage *image;
    long row = [indexPath row];
    image = [UIImage imageNamed:_workoutImages[row]];
    cell.imageView.image = image;
    
    if (row == _newImageIndex) {
        cell.rectangleLabel.hidden = NO;
    } else {
        cell.rectangleLabel.hidden = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _newImageIndex = (int)indexPath.row;
    [collectionView reloadData];
    // make sound
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
    // hide keyboard
    [self hideKeyboard];
}



@end
