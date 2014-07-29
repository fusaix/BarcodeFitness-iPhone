//
//  BFWorkoutViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutViewController.h"
#import "BFWorkout.h"


@interface BFWorkoutViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation BFWorkoutViewController
@synthesize workout = _workout;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
