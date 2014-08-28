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


@end

@implementation BFExerciseListViewController
@synthesize exercises = _exercises;
@synthesize exerciseListViewController = _exerciseListViewController;
@synthesize wIndex = _wIndex;

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
    return @"Default exercises";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.exercises.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
    
    // Configure the cell...
    BFExercise * currentExercise;
    currentExercise = [self.exercises objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentExercise.name;
    UIView *orangeView = [[UIView alloc] init];
    orangeView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:148.0/255.0f blue:30.0f/255.0f alpha:1.0f]; //orange BeeHive -> UIColor
    [cell setSelectedBackgroundView:orangeView];
    
    // cell image
    
    // subtitle
    
    
    return cell;
}

#pragma mark - Row selected

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Save
    [self.exerciseListViewController.exercises addObject:[_exercises objectAtIndex:indexPath.row]];
    // Save to persistent data
    [BFWorkoutList addExercise: [_exercises objectAtIndex:indexPath.row] toWorkoutAtIndex: _wIndex];
    // Dismiss
    [self dismissViewControllerAnimated:YES completion:nil];

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



@end
