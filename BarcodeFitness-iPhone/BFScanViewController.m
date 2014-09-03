//
//  BFScanViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/29/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFScanViewController.h"
#import "BFWorkoutViewController.h"
#import "BFWorkoutList.h"
#import "BFExercise.h"
#import "BFExerciseList.h"


@interface BFScanViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (strong, nonatomic) IBOutlet UIImageView *failSignImage;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) NSDictionary* parsedExerciseData;
@property (nonatomic) BOOL success;
@property (nonatomic) BOOL failure;
@property (nonatomic, strong) NSArray* exercises;


@end


@implementation BFScanViewController
@synthesize exerciseListViewController = _exerciseListViewController;
@synthesize wIndex = _wIndex;
//@synthesize exercise = _exercise;


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
    _captureSession = nil;
    
    // Load sound
    [self loadBeepSound];
    
    // data table
    if (!_exercises) {
        _exercises = [[NSArray alloc] initWithArray:[BFExerciseList getAllExercises]];
        
    }
    
    // Image updater
    [_failSignImage setAlpha:0.0];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(imageUpdater) userInfo:nil repeats:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    // Start Scanning
    if ([self startReading]) {
        self.navigationItem.title = @"Scanning...";
    } else {
        self.title = @"Can't scan :(";
    }
    _success = NO;
    _failure = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!_success) { // Sucess scenario is handled separatly
        // Stop scanning
        [self stopReading];
    }
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
    
    // make sound
    AudioServicesPlaySystemSound(1117); // see http://iphonedevwiki.net/index.php/AudioServices
    
//    NSLog(@"scanning started");
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString * detectionString = [metadataObj stringValue];
//            NSLog(@"Hey! The data is: %@",[metadataObj stringValue]);
            
            // When scanned, we should verify if the link is part of the list
            // if not : play failure sound and continue scanning
            
            if (detectionString != nil) {
                // Stop further capture, as soon as you get the first one
                [_captureSession stopRunning];
                
                // Verify
                int i = 0;
                for(BFExercise * exercise in _exercises) {
//                    NSLog(@"%@",exercise.qrCode);
                    if ([detectionString isEqualToString: exercise.qrCode]) {
                        _success = YES; // Sucess !!!
                        break;
                    } else {
                        _success = NO;
                        i++;
                    }
                }
                if(_success){
                    // Save
//                    BFExercise *newExercise = [[BFExercise alloc] initWithName:[metadataObj stringValue] andCompagny:@"Louis"];
                    [self.exerciseListViewController.exercises addObject:_exercises[i]];
                    // Save to persistent data
                    [BFWorkoutList addExercise: _exercises[i] toWorkoutAtIndex: _wIndex];
                    //            NSLog(@"row: %d", _wIndex);
                    
                    // play success sound and vibrate !!!
                    if (_audioPlayer) {
                        [_audioPlayer play];
                    }
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                    // stop and dismiss NB: [_captureSession stopRunning]; already done.
                    [self performSelectorOnMainThread:@selector(dismissAndStopReading) withObject:nil waitUntilDone:YES];
                } else {
                    // failure
                    _failure = YES;
                    // run again
                    [_captureSession startRunning];
                }
            }
        }
    }
}


// timer action
- (void) imageUpdater {
    if (_failure){
        _failure = NO;
        // make sound
        AudioServicesPlaySystemSound(1053); // see http://iphonedevwiki.net/index.php/AudioServices
        // display fail sign
        [_failSignImage setAlpha:1.0];
        [UIView animateWithDuration:2.0
                              delay:0.0
                            options:(UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction)
                         animations:^(void) {
                             [_failSignImage setAlpha:0.0];
                         }
                         completion:nil];
    }
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
//    NSLog(@"scanning stopped");
}

-(void)dismissAndStopReading{
    [self dismissViewControllerAnimated:YES completion: ^{
        _captureSession = nil;
        [_videoPreviewLayer removeFromSuperlayer];
//        NSLog(@"scanning stopped 2.0");
    }];
}


#pragma mark - Sound

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"PumpToLoad" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}


#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
