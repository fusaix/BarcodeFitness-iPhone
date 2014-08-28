//
//  BFWebViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/19/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWebViewController.h"

@interface BFWebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

@implementation BFWebViewController

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
    _webView.delegate = self;
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
    
    //1
    NSString *urlString = @"http://www.crc.gatech.edu/content/556/crc-hours-of-operation";
    
//    //2
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    //3
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    //4
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    //5
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        _errorBOOL = NO;
//        if ([data length] > 0 && error == nil) [_webView loadRequest:request];
//         else if (error != nil) {
//             NSLog(@"Error: %@", error);
//             _errorBOOL = YES;
//         }
//     }];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: urlString] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 3.0];
    [self.webView loadRequest: request];

    
}


- (void)cancelWeb
{
    NSLog(@"didn't finish loading within 3 sec");
    // do anything error
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't load this page :("
                                                    message:@"You must be connected to the internet to load this page."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_timer invalidate];
    [_spinner stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // webView connected
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
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

@end
