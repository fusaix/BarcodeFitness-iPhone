//
//  BFWorkoutNoteCell.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/29/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFWorkoutNoteCell.h"
#import "BFWorkoutList.h"
#import "BFWorkout.h"


@implementation BFWorkoutNoteCell
@synthesize workout = _workout;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;

    self.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"darkPaperBackground"]];
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TextField methods

-(void)textViewDidEndEditing:(UITextView *)textView {
    // make sound to fix low sound bug
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
    // Save to persistent data
    [BFWorkoutList setWorkoutNote:textView.text atIndex:_wIndex];
    // refresh workout data
    _workout.note = textView.text;
    // placeholder restitution
    if ([textView.text isEqualToString: @""]) {
        textView.text = @"Your notes...";
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
//    NSLog(@"%@",textView.text );

    // make sound
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
    // @"Your notes..." place holder handeler
    if ([textView.text isEqualToString: @"Your notes..."]) {
        textView.text = @"";
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
