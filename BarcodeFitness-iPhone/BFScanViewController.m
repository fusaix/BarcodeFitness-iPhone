//
//  BFScanViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 7/29/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFScanViewController.h"


@interface BFScanViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewPreview;

@end

@implementation BFScanViewController

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

//-(void) setUpCamera
//{
//    _highlightView = [[UIView alloc] init];
//    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
//    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
//    _highlightView.layer.borderWidth = 3;
//    [self.view addSubview:_highlightView];
//    
//    _session = [[AVCaptureSession alloc] init];
//    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    NSError *error = nil;
//    
//    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
//    if (_input) {
//        [_session addInput:_input];
//    } else {
//        NSLog(@"Error: %@", error);
//    }
//    
//    _output = [[AVCaptureMetadataOutput alloc] init];
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [_session addOutput:_output];
//    
//    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
//    
//    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _prevLayer.frame = CGRectMake(75, 150, 200, 200);
//    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    
//}


#pragma mark - IBActions

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
