//
//  BFMoreViewController.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/19/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFMoreViewController.h"

@interface BFMoreViewController ()

@end

@implementation BFMoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"webSegue" sender:self];
        } else if (indexPath.row == 1) {
            NSString *BeeHiveURL = @"BeeHive-WaitNoMore://"; // URL scheme
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:BeeHiveURL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:BeeHiveURL]];
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.letsbeehive.com"]];
            }
        } else if (indexPath.row == 2) {
            NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/696799653704245"]; // https://graph.facebook.com/yourappspage
            if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
                [[UIApplication sharedApplication] openURL:facebookURL];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/gtrnoc"]];
            }
        } else if (indexPath.row == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id869869380"]];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - IBActions 

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    
}


@end
