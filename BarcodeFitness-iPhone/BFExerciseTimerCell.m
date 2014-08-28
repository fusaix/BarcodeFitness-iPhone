//
//  BFExerciseTimerCell.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/20/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseTimerCell.h"
#import "BFWorkoutViewController.h"


@implementation BFExerciseTimerCell {
    UILabel *_rectangleLabel;
    UITextField *_theTextField;
    UIPickerView *_pickerView;
    NSMutableArray *_minArray;
    NSMutableArray *_secArray;
    NSArray *_modeArray;
    NSArray *_okArray;
    
}

@synthesize restTimer = _restTimer;
@synthesize theOtherTextLabel = _theOtherTextLabel;
@synthesize exerciseListViewController = _exerciseListViewController; // for pies and timer
@synthesize timeCount = _timeCount;


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
    
    // add the text field and pickerview
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    _theTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 44)]; // full width = 320
    _theTextField.delegate = self;
    _theTextField.tintColor = [UIColor clearColor];
    _theTextField.inputView.userInteractionEnabled = NO;
    _theTextField.textColor = [UIColor clearColor];
    _theTextField.layer.borderColor = [UIColor blackColor].CGColor;
    _theTextField.layer.borderWidth = 1.0;
//    _theTextField.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];

    _theTextField.inputView = _pickerView;
    
    [self addSubview:_theTextField];
    
    
    // add the rectangle label
    _rectangleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    _rectangleLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    _rectangleLabel.layer.borderWidth = 3.0;
    _rectangleLabel.layer.hidden = YES;
    [self addSubview:_rectangleLabel];
    
    
    // add the other text label
    _theOtherTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 160, 44)];
    _theOtherTextLabel.backgroundColor = [UIColor clearColor];
    _theOtherTextLabel.textColor = [UIColor whiteColor]; 
    [self addSubview:_theOtherTextLabel];
    
    
    // init picker arrays
    _minArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        NSString *min = [NSString stringWithFormat:@"%d",i];
        [_minArray addObject: min];
    }
    
    _secArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i=i+5) {
        NSString *sec = [NSString stringWithFormat:@"0%d",i];
        [_secArray addObject: sec];
    }
    for (int i = 10; i < 60; i=i+5) {
        NSString *sec = [NSString stringWithFormat:@"%d",i];
        [_secArray addObject: sec];
    }
    
    _modeArray = [NSArray arrayWithObjects: @"Auto", @"Manu", @"Off", nil];
    
    _okArray = [NSArray arrayWithObjects: @"OK", @" - ", nil];
    
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
    
    // Timer initialisation
    if (!_restTimer) {
        _restTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimerLabels) userInfo:nil repeats:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Time Updater

- (void) updateTimerLabels {
    if ([BFWorkoutViewController resting]) {
        _timeCount = [[NSDate date] timeIntervalSinceDate:_exerciseListViewController.timerBeginTime];
        if ([BFWorkoutViewController restTime] == [BFWorkoutViewController currentRestTime]) {
            self.detailTextLabel.text = [BFWorkoutViewController timeFormatted2: [BFWorkoutViewController restTime]];
        } else {
            self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (currently: %@)", [BFWorkoutViewController timeFormatted2: [BFWorkoutViewController restTime]], [BFWorkoutViewController timeFormatted2: [BFWorkoutViewController currentRestTime]]];
        }
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        _timeCount = 0;
        [BFWorkoutViewController setCurrentRestTime:[BFWorkoutViewController restTime]]; // tranfert restTime
        self.detailTextLabel.text = [BFWorkoutViewController timeFormatted2: [BFWorkoutViewController currentRestTime]];
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    if (_timeCount > [BFWorkoutViewController currentRestTime]) {
        self.textLabel.textColor = [UIColor redColor];
    }
    
    self.textLabel.text = [BFWorkoutViewController timeFormatted2:_timeCount];
    
    // the other side
    NSString * accessory = [BFWorkoutViewController resting] ? @"accessoryStop" : @"accessoryRest";
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessory]];
    NSString * lableText = [BFWorkoutViewController resting] ? @"Reset timer" : @"Begin rest";
    self.theOtherTextLabel.text = lableText;
}


#pragma mark - TextField methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _rectangleLabel.layer.hidden = YES;
    // make sound to fix low sound bug
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    // label visible and blink
    _rectangleLabel.layer.hidden = NO;
    [_rectangleLabel setAlpha:0.0];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat)
                     animations:^(void) {
                         [_rectangleLabel setAlpha:1.0];
                     }
                     completion:nil];
    
    // position picker view
    [_pickerView selectRow:([BFWorkoutViewController restTime]/60)%60 inComponent:0 animated:YES];
    [_pickerView reloadComponent:0];
    [_pickerView selectRow:([BFWorkoutViewController restTime]%60)/5 inComponent:1 animated:YES];
    [_pickerView reloadComponent:1];
    [_pickerView selectRow:1 inComponent:2 animated:NO];
    [_pickerView reloadComponent:2];
    [_pickerView selectRow:1 inComponent:3 animated:NO];
    [_pickerView reloadComponent:3];
    
    // make sound
    AudioServicesPlaySystemSound(1057); // see http://iphonedevwiki.net/index.php/AudioServices
}



#pragma mark - PickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //set number of rows
    switch(component) {
        case 0:
            return [_minArray count];
            break;
        case 1:
            return [_secArray count];
            break;
        case 2:
            return [_modeArray count];
            break;
        case 3:
            return [_okArray count];
            break;
        default:
            return 0;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // display values
    switch(component) {
        case 0:
            return [NSString stringWithFormat: @"%@ min",[_minArray objectAtIndex:row]];
            break;
        case 1:
            return [NSString stringWithFormat: @"%@ s",[_secArray objectAtIndex:row]];
            break;
        case 2:
            return [NSString stringWithFormat: @"%@",[_modeArray objectAtIndex:row]];
            break;
        case 3:
            return [_okArray objectAtIndex:row];
            break;
        default:
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int min;
    int sec;
    
    NSString * newmin;
    NSString * newsec;
    NSString * ok;
//    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSNumber * myNumber;
    
    switch(component) {
        case 0:
            newmin = [_minArray objectAtIndex:row];
            sec = [BFWorkoutViewController restTime] % 60;
            // update restTime
            self.textLabel.text = [NSString stringWithFormat:@"%@:%02d", newmin, sec];
            [BFWorkoutViewController setRestTime:[newmin intValue] * 60 + sec];
            // update in persistent data
//            myNumber = [f numberFromString:newmin];
//            [BFWorkoutList setmin:myNumber atIndex:_sIndex toExerciseAtIndex:_eIndex inWorkoutAtIndex:_wIndex];
            break;
        case 1:
            min = ([BFWorkoutViewController restTime] / 60) % 60;
            newsec = [_secArray objectAtIndex:row];
            // update restTime
            self.textLabel.text = [NSString stringWithFormat:@"%02d:%@", min, newsec];
            [BFWorkoutViewController setRestTime: min * 60 + [newsec intValue]];
            // update in persistent data
//            myNumber = [f numberFromString:newsec];
//            [BFWorkoutList setsec: myNumber atIndex:_sIndex toExerciseAtIndex:_eIndex inWorkoutAtIndex:_wIndex];
            break;
        case 2:
            
            // update in persistent data
//            myNumber = [f numberFromString:newsec];
//            [BFWorkoutList setsec: myNumber atIndex:_sIndex toExerciseAtIndex:_eIndex inWorkoutAtIndex:_wIndex];
            break;
        case 3:
            ok = [_okArray objectAtIndex:row];
            // if OK, resing fisrt responder
            if ([ok isEqualToString:@"OK"]) {
                [_theTextField resignFirstResponder];
            }
            break;
    }
 
}

 
 
@end