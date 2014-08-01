//
//  BFWorkoutViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutViewController.h"
#import "BFScanViewController.h"
#import "BFWorkout.h"
#import "BFExercise.h"


@interface BFWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int renameRow;


@end

@implementation BFWorkoutViewController
@synthesize workout = _workout;
@synthesize exercises = _exercises;



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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Init the NSMutableArray _exercises
    // we get _exercises from the stored representation, translation is performed by ... class
    if (!_exercises) {
        _exercises = [[NSMutableArray alloc] init];
    }
    
    
    // Configure navigation bar
    self.title = _workout.name;
    // configure back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Rest" style:UIBarButtonItemStyleBordered target:nil action:nil];

    
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
    return @"Choose an exercise to start";
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
    cell.detailTextLabel.text = currentExercise.description;
    
    NSLog(@"%@", currentExercise.name);
    NSLog(@"1- %@", _exercises);
    
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

#pragma mark - Secondary swipe button

-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Rename";
}

-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.renameRow = (int) indexPath.row;
    [self performSegueWithIdentifier:@"editExercise" sender:tableView];
    
}

#pragma mark - Navigation

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"startExercise" sender:tableView];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addExercise"]){
        
        UITabBarController *tabBarController = (UITabBarController *)[segue destinationViewController];
        UINavigationController *navigationController = [[tabBarController viewControllers] objectAtIndex:0]; // Scan in 1st position
        BFScanViewController * scanViewController = [[navigationController viewControllers] objectAtIndex:0]; // IMPORTANT cast and childViewController method. (BFScanViewController *)
        scanViewController.exerciseListViewController = self;
        scanViewController.segueIdentifier = @"addExercise";
        
    } else if ([segue.identifier isEqualToString:@"editExercise"]) { // BFAddWorkoutViewController is also used for editing an workout (rename or change image
        UITabBarController * tabCon = (UITabBarController *)[segue destinationViewController];
        BFScanViewController * scanViewController = (BFScanViewController *)tabCon.childViewControllers.firstObject; // IMPORTANT cast and childViewController method.
        scanViewController.exercise = [_exercises objectAtIndex:self.renameRow]; // self.tableView.indexPathForSelectedRow.row does not apply
        scanViewController.segueIdentifier = @"editExercise";
        
    } else if ([segue.identifier isEqualToString:@"startExercise"]) {
        NSIndexPath *indexPath = [sender indexPathForSelectedRow];
        BFExercise *exercise = nil;
        exercise = [_exercises objectAtIndex:indexPath.row];
        BFScanViewController *destViewController = segue.destinationViewController;
        destViewController.exercise = exercise;
    }
    
}



#pragma mark - IBActions

- (IBAction)addWorkout:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"addExercise" sender:self];
    

}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    self.tableView.editing = !self.tableView.editing; // not a tableViewController so use the "self.tableView.editing" in stead of "self.editing"
    if (self.tableView.editing) {
        sender.tintColor = [UIColor redColor];
    } else {
        sender.tintColor = [self.navigationController.navigationBar tintColor];
    }
}



@end
