//
//  BFWelcomeViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWelcomeViewController.h"
#import "BFChooseViewController.h"

@interface BFWelcomeViewController ()

@end

@implementation BFWelcomeViewController

- (IBAction)chooseWorkout:(UIButton *)sender {
    [self performSegueWithIdentifier:@"chooseWorkout" sender:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    BFChooseViewController *chooseViewController = [segue destinationViewController];
    
}

@end
