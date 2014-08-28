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


@interface BFScanViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) NSDictionary* parsedExerciseData;
@property (nonatomic) BOOL success;

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
    
    // configure button colors
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
//    self.tabBarController.tabBar.tintColor = [UIColor orangeColor];

}

- (void)viewWillAppear:(BOOL)animated {
    // Start Scanning
    if ([self startReading]) {
        self.navigationItem.title = @"Scanning...";
    } else {
        self.title = @"Can't scan :(";
    }
    _success = NO;
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
    
//    NSLog(@"scanning started");
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString * detectionString = [metadataObj stringValue];
            NSLog(@"Hey! The data is: %@",[metadataObj stringValue]);
            
            // Fake
            // **************
            [_captureSession stopRunning];

            // Sucess !!!
            _success = YES;
            
            // Save
            BFExercise *newExercise = [[BFExercise alloc] initWithName:[metadataObj stringValue]];
            [self.exerciseListViewController.exercises addObject:newExercise];
            // Save to persistent data
            [BFWorkoutList addExercise: newExercise toWorkoutAtIndex: _wIndex];
//            NSLog(@"row: %d", _wIndex);
            
            // play success sound and vibrate !!!
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            // stop and dismiss NB: [_captureSession stopRunning]; already done.
            [self performSelectorOnMainThread:@selector(dismissAndStopReading) withObject:nil waitUntilDone:YES];
            // **************
        
            
            // When scanned, we should verify if the link is part of the list
            // if not : play failure sound and continue scanning
            
            
            
//            if (detectionString != nil) {
//                // Stop further capture, as soon as you get the first one
//                [_captureSession stopRunning];
//                
//                // GETTING the data using the QR code
//                NSString* url_data=@"http://dev.m.gatech.edu/d/msandt3/api/barcodefitness/search?q=";
//                
//                url_data=[url_data stringByAppendingString:detectionString];
//                url_data=[url_data stringByAppendingString:@"&type=exercise"];
//                
//                NSURL* url_fetch= [[NSURL alloc]initWithString:url_data];
//                
//                // Prepare the request object
//                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url_fetch
//                                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                        timeoutInterval:30];
//                // Prepare the variables for the JSON response
//                NSData *urlData;
//                NSURLResponse *response;
//                NSError *error;
//                
//                // Make synchronous request
//                urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//                if (error) {
//                    NSLog(@"Could not make synchronous request.");
//                    NSLog(@"%@", [error localizedDescription]);
//                    // play fail sound
//                    if (_audioPlayer) {
//                        [_audioPlayer play];
//                    }
//                    // show fail sign and wait 2s
//                    
//                    // run again
//                    [_captureSession startRunning];
//                }
//                else{
//                    // Parse data
//                    self.parsedExerciseData = [NSJSONSerialization JSONObjectWithData:urlData options:0 error:&error];
//                    if (error) {
//                        NSLog(@"Could not parse data.");
//                        NSLog(@"%@", [error localizedDescription]);
//                        // play fail sound
//                        if (_audioPlayer) {
//                            [_audioPlayer play];
//                        }
//                        // show fail sign and wait 2s
//                        
//                        // run again
//                        [_captureSession startRunning];
//                    }
//                    else{
////                        _exercise.name = [self.parsedExerciseData valueForKey:@"name"];
//                        
//                        
//                        
//                        // save to exercises
//                        BFExercise *newExercise = [[BFExercise alloc] initWithName:[self.parsedExerciseData valueForKey:@"name"]];
//                        [self.exerciseListViewController.exercises addObject:newExercise];
//                        
//                        
//                        NSLog(@"Perfect! The name is: %@",_exercise.name);
//            
//                        
//                        // play success sound and vibrate !!!
//                        if (_audioPlayer) {
//                            [_audioPlayer play];
//                        }
//                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
//                        // stop and dismiss NB: [_captureSession stopRunning]; already done. 
//                        [self performSelectorInBackground:@selector(stopReadingAndDismiss) withObject:nil];
//                    }
//             
//             
//                }
//
//        
//
//            } // if (detectionString != nil)
            
            
            
        } // if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
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
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"PumpShotgun2x" ofType:@"mp3"];
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
