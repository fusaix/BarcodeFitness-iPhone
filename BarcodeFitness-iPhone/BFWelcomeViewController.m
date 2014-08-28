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
// Images
@property (strong, nonatomic) IBOutlet UIImageView *athleteImage;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIImageView *performanceHistoryImage;
@property (strong, nonatomic) IBOutlet UIImageView *scanImage;
@property (strong, nonatomic) IBOutlet UIImageView *workoutImage;

// buttons
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *performanceHistoryButton;
@property (strong, nonatomic) IBOutlet UIButton *workoutButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIButton *logoButton;

@end

@implementation BFWelcomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Configure back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // Configure background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"metalBackground"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Fonte"] forBarMetrics: UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    // title color 
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Configure button colors
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor]; 
    
    // disable swipe back
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Register to a notification UIApplicationWillEnterForegroundNotification to force animation to restart
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeButtonImages)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // Touch
    [_workoutButton addTarget:self action:@selector(workoutButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_workoutButton addTarget:self action:@selector(workoutButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_workoutButton addTarget:self action:@selector(workoutButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpInside];
    [_logoButton addTarget:self action:@selector(logoButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_logoButton addTarget:self action:@selector(logoButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_logoButton addTarget:self action:@selector(logoButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpInside];
    [_scanButton addTarget:self action:@selector(fadeLabelImages2) forControlEvents:UIControlEventTouchDown];
    [_performanceHistoryButton addTarget:self action:@selector(fadeLabelImages3) forControlEvents:UIControlEventTouchDown];
    // add gesture recognizers to title
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(whiteStatusBar)];
    longPress.delegate = self;
    [self.navigationController.navigationBar addGestureRecognizer:longPress];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [self animateButtonImages];
    _athleteImage.highlighted = NO;
    _scanButton.highlighted = NO;
    _performanceHistoryButton.highlighted = NO;
    _logoButton.highlighted = NO;
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void) whiteStatusBar {
    // Status bar white
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [NSTimer scheduledTimerWithTimeInterval:4.0
                                     target:self
                                   selector:@selector(blackStatusBar)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) blackStatusBar {
    // Status bar black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden: NO animated:YES];
//}

- (void) fadeButtonImages {
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_athleteImage setAlpha:0.2];
                         [_workoutImage setAlpha:0.1];
                         [_performanceHistoryImage setAlpha:0.1];
                         [_scanImage setAlpha:0.1];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self animateButtonImages];
                         }
                     }];
}

- (void) animateButtonImages {
    [_athleteImage setAlpha:0.2];
    [_workoutImage setAlpha:0.1];
    [_performanceHistoryImage setAlpha:0.1];
    [_scanImage setAlpha:0.1];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_athleteImage setAlpha:1.0];
                         [_workoutImage setAlpha:1.0];
                         [_performanceHistoryImage setAlpha:1.0];
                         [_scanImage setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
//                         if (finished) {
                             [self fadeLabelImages];
//                         }
                     }];

}

- (void) fadeLabelImages {
    [_workoutImage setAlpha:1.0];
    [_performanceHistoryImage setAlpha:1.0];
    [_scanImage setAlpha:1.0];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_workoutImage setAlpha:0.0];
                         [_performanceHistoryImage setAlpha:0.0];
                         [_scanImage setAlpha:0.0];
                     }
                     completion:nil];
}

- (void) fadeLabelImages1 {
    [_workoutImage setAlpha:1.0];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_workoutImage setAlpha:0.0];
                     }
                     completion:nil];
}

- (void) fadeLabelImages2 {
    [_scanImage setAlpha:1.0];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_scanImage setAlpha:0.0];
                     }
                     completion:nil];
}

- (void) fadeLabelImages3 {
    [_performanceHistoryImage setAlpha:1.0];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_performanceHistoryImage setAlpha:0.0];
                     }
                     completion:nil];
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


#pragma mark - IBActions and touch methods


- (IBAction)chooseWorkout:(UIButton *)sender {
//    _athleteImage.highlighted = YES;
    [self performSegueWithIdentifier:@"chooseWorkout" sender:self];
}


- (IBAction)performanceHistory:(UIButton *)sender {
    
    
}

- (IBAction)scanButtonPressed:(UIButton *)sender {
    
    
}

- (IBAction)logoButtonPressed:(id)sender {
    // go to more
    [self performSegueWithIdentifier:@"moreSegue" sender:self];

    
}

- (IBAction)shareButtonPressed:(UIButton *)sender {
    
}

- (IBAction)rateButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id869869380"]];

}


- (IBAction)moreButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"moreSegue" sender:self];
    
}


- (void) workoutButtonTouched {
    _athleteImage.highlighted = YES;
    [self fadeLabelImages1];
    
}

- (void) workoutButtonTouchedUpOutside {
    _athleteImage.highlighted = NO;

}

- (void) logoButtonTouched {
    _logoImage.highlighted = YES;
    
    
}

- (void) logoButtonTouchedUpOutside {
    _logoImage.highlighted = NO;
    
}


@end
