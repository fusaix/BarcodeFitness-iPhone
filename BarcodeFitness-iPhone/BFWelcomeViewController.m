//
//  BFWelcomeViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/21/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWelcomeViewController.h"
#import "BFChooseViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface BFWelcomeViewController ()
// Images
@property (strong, nonatomic) IBOutlet UIImageView *athleteImage;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIImageView *performanceHistoryImage;
@property (strong, nonatomic) IBOutlet UIImageView *scanImage;

// Views
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (strong, nonatomic) IBOutlet UIView *toolView;
@property (strong, nonatomic) IBOutlet UIView *arrowView;

// Labels
@property (strong, nonatomic) IBOutlet UILabel *selectorLabel;
@property (nonatomic) int activeButtom;

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
    _titleView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Fonte"]];
    _toolView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Fonte"]];
    
    // title color 
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Configure button colors
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    _shareButton.tintColor = [UIColor orangeColor];
    _rateButton.tintColor = [UIColor orangeColor];
    _moreButton.tintColor = [UIColor orangeColor];
    
    // disable swipe back
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Register to a notification UIApplicationWillEnterForegroundNotification to force animation to restart
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animateButtonImages)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    _activeButtom = 0;
    
    // Touch
    [_workoutButton addTarget:self action:@selector(workoutButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_workoutButton addTarget:self action:@selector(workoutButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_workoutButton addTarget:self action:@selector(workoutButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpInside];
    [_logoButton addTarget:self action:@selector(logoButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_logoButton addTarget:self action:@selector(logoButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_scanButton addTarget:self action:@selector(scanButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_scanButton addTarget:self action:@selector(scanButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_performanceHistoryButton addTarget:self action:@selector(performanceHistoryButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_performanceHistoryButton addTarget:self action:@selector(performanceHistoryButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    // add gesture recognizers to title
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(whiteStatusBar)];
    longPress.delegate = self;
    [self.navigationController.navigationBar addGestureRecognizer:longPress];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    _athleteImage.highlighted = NO;
    _scanButton.highlighted = NO;
    _performanceHistoryButton.highlighted = NO;
    _logoImage.highlighted = NO;
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    // Status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

-  (void) viewDidAppear:(BOOL)animated {
    _activeButtom = 0;
    [self fadeButtonImages];
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


- (void) fadeButtonImages {
    [_athleteImage setAlpha:1.0];
    [_scanImage setAlpha:1.0];
    [_performanceHistoryImage setAlpha:1.0];
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_selectorLabel setAlpha:0.0];
                         [_athleteImage setAlpha:0.5];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self animateButtonImages];
                         }
                     }];
}

- (void) animateButtonImages {
    [_selectorLabel setAlpha:0.0];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         switch (_activeButtom) {
                             case 0:
                                 _athleteImage.highlighted = YES;
                                 _selectorLabel.text = @"Start workout";
                                 break;
                             case 1:
                                 _scanImage.highlighted = YES;
                                 _selectorLabel.text = @"Scan";
                                 break;
                             case 2:
                                 _performanceHistoryImage.highlighted = YES;
                                 _selectorLabel.text = @"Performance history";
                                 break;
                             default:
                                 break;
                         }
                         [_selectorLabel setAlpha:1.0];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self animateLabelImages];
                         }
                     }];
}

- (void) animateLabelImages {
    _athleteImage.highlighted = NO;
    _performanceHistoryImage.highlighted = NO;
    _scanImage.highlighted = NO;
    [_athleteImage setAlpha:1.0];
    [_scanImage setAlpha:1.0];
    [_performanceHistoryImage setAlpha:1.0];


    [UIView animateWithDuration:2.0
                          delay:2.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         int y;
                         switch (_activeButtom) {
                             case 0:
                                 _selectorLabel.text = @"Start workout";
                                 y = 60;
                                 _activeButtom = 1;
                                 [_scanImage setAlpha:0.5];
                                 break;
                             case 1:
                                 _selectorLabel.text = @"Scan";
                                 y = 230;
                                 _activeButtom = 2;
                                 [_performanceHistoryImage setAlpha:0.5];
                                 break;
                             case 2:
                                 _selectorLabel.text = @"Performance history";
                                 y = 145;
                                 _activeButtom = 0;
                                 [_athleteImage setAlpha:0.5];
                                 break;
                             default:
                                 break;
                         }
                         
                         // move arrow
                         CGRect frame = _arrowView.frame;
                         frame.origin.y = 465;
                         frame.origin.x = y;
                         _arrowView.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self animateButtonImages];
                         }
                     }];

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming soon:"
                                                    message:@"You will be able to share this app and your performance on social media. Go to: \"More/Our Facebook page\" and tell us how you would like it to be! "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)rateButtonPressed:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id869869380"]];

}


- (IBAction)moreButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"moreSegue" sender:self];
    
}


- (void) workoutButtonTouched {
    _athleteImage.highlighted = YES;
//    [self fadeLabelImages1];
    
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

- (void) scanButtonTouched {
    _scanImage.highlighted = YES;
}

- (void) scanButtonTouchedUpOutside {
    _scanImage.highlighted = NO;
}

- (void) performanceHistoryButtonTouched {
    _performanceHistoryImage.highlighted = YES;
}

- (void) performanceHistoryButtonTouchedUpOutside {
    _performanceHistoryImage.highlighted = NO;
}


@end
