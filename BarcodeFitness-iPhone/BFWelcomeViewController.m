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
// buttons
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *performanceHistoryButton;
@property (strong, nonatomic) IBOutlet UIButton *workoutButton;
// video
@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation BFWelcomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // configure back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // configure background
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"paperBackground"] forBarMetrics: UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.navigationController.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"paperBackground"]];
    
//    // Load images
//    NSArray *imageNames = @[@"CRC1.jpg", @"CRC2.jpg", @"CRC3.jpg", @"CRC4.jpg", @"CRC5.jpg"];
//
//    NSMutableArray *images = [[NSMutableArray alloc] init];
//    for (int i = 0; i < imageNames.count; i++) {
//        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
//    }
//    
//    // Normal Animation
//    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
//    animationImageView.animationImages = images;
//    animationImageView.animationDuration = 10.0;
//    
//    [self.view addSubview:animationImageView];
//    [animationImageView startAnimating];
    
    // register to a notification UIApplicationWillEnterForegroundNotification to force animation to restart
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeButtonImages)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // touch
    [_workoutButton addTarget:self action:@selector(workoutButtonTouched) forControlEvents:UIControlEventTouchDown];
    [_workoutButton addTarget:self action:@selector(workoutButtonTouchedUpOutside) forControlEvents:UIControlEventTouchUpOutside];

}

- (void)viewWillAppear:(BOOL)animated {
    [self animateButtonImages];
    _athleteImage.highlighted = NO;
    _scanButton.highlighted = NO;
    _performanceHistoryButton.highlighted = NO;
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    // Start video
    [self startReading];
}


- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden: NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    // Stop video
    [self stopReading];
}

- (void) fadeButtonImages {
    [_viewPreview setAlpha:0.0];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_athleteImage setAlpha:0.1];
                         [_logoImage setAlpha:0.1];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self animateButtonImages];
                         }
                     }];
}

- (void) animateButtonImages {
    [_athleteImage setAlpha:0.1];
    [_logoImage setAlpha:0.1];
    [_viewPreview setAlpha:0.1];
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                     animations:^(void) {
                         [_athleteImage setAlpha:1.0];
                         [_logoImage setAlpha:1.0];
                         [_viewPreview setAlpha:1.0];
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


#pragma mark - Scanning


- (BOOL)startReading {
    NSError *error;
    
    // get device
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // create input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO; // display self.title = @"Can't scan :(";
    }
    
    // session
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    // output creation and dispatch
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // configure display
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    // run
    [_captureSession startRunning];
    
//    NSLog(@"scanning started");
    
    return YES;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
//    NSLog(@"scanning stopped");
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

- (void) workoutButtonTouched {
//    _scanButton.highlighted = YES;
//    _performanceHistoryButton.highlighted = YES;
    _athleteImage.highlighted = YES;

}

- (void) workoutButtonTouchedUpOutside {
    _athleteImage.highlighted = NO;
//    _scanButton.highlighted = NO;
//    _performanceHistoryButton.highlighted = NO;
}


@end
