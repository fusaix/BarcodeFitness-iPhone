//
//  BFExerciseViewControllerCell.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/6/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseViewControllerCell.h"
#import "BFWorkoutList.h"
#import "BFSet.h"
#import "BFExerciseViewController.h"


@implementation BFExerciseViewControllerCell{
    UILabel *_rectangleLabel;
    UITextField *_theTextField;
    UIPickerView *_pickerView;
    NSMutableArray *_repsArray;
    NSMutableArray *_weightArray;
    NSArray *_okArray;
    
}

@synthesize sIndex = _sIndex;
@synthesize eIndex = _eIndex;
@synthesize wIndex = _wIndex;
@synthesize set = _set;


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
    
    _theTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, 180, 43)];
    _theTextField.delegate = self;
    _theTextField.tintColor = [UIColor clearColor];
    _theTextField.inputView.userInteractionEnabled = NO;
    _theTextField.textColor = [UIColor clearColor];
    
    _theTextField.inputView = _pickerView;
    
    [self addSubview:_theTextField];
    

    // add gesture recognizers to cell
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditingCell:)];
//        longPress.delegate = self;
//        [cell addGestureRecognizer:longPress];
    
    
    // add the rectangle label 
    _rectangleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _rectangleLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    _rectangleLabel.layer.borderWidth = 3.0;
    _rectangleLabel.layer.hidden = YES;
    [self addSubview:_rectangleLabel];
    
    
    
    // init picker arrays
    _repsArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 101; i++) {
        NSString *reps = [NSString stringWithFormat:@"%d",i];
        [_repsArray addObject: reps];
    }
    
    _weightArray = [[NSMutableArray alloc]init];
    NSString *weight;
    float floati;
    for (int i = 2; i < 1001; i++) {
        floati = i;
        if (i%2 == 0) {
            weight = [NSString stringWithFormat:@"%.f",floati/2];
        } else {
            weight = [NSString stringWithFormat:@"%.1f",floati/2];
        }
        
        [_weightArray addObject: weight];
    }

    _okArray = [NSArray arrayWithObjects: @"OK", @" - ", nil];
    
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


- (void)layoutSubviews {
    [super layoutSubviews];
    
//    NSLog(@"%f", self.textLabel.frame.size.width);
    
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x,self.textLabel.frame.origin.y,170 ,self.textLabel.frame.size.height);
}

#pragma mark - TextField methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _rectangleLabel.layer.hidden = YES;
//    _theTextField.backgroundColor =[UIColor clearColor];

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
                         // text field gray
//                         _theTextField.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
                     }
                     completion:nil];
    
    // position picker view
    [_pickerView selectRow:[_set.reps intValue]-1 inComponent:0 animated:YES];
    [_pickerView reloadComponent:0];
    [_pickerView selectRow:([_set.weight floatValue]-1)*2 inComponent:1 animated:YES];
    [_pickerView reloadComponent:1];
    [_pickerView selectRow:1 inComponent:2 animated:NO];
    [_pickerView reloadComponent:2];
    
    // make sound
    AudioServicesPlaySystemSound(1105); // see http://iphonedevwiki.net/index.php/AudioServices 
    
    // scroll to visible
//    [ wordsTableView scrollRectToVisible:textFieldRect animated:YES];

    
}



#pragma mark - PickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //set number of rows
    switch(component) {
        case 0:
            return [_repsArray count];
            break;
        case 1:
            return [_weightArray count];
            break;
        case 2:
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
            return [NSString stringWithFormat: @"%@ x",[_repsArray objectAtIndex:row]];
            break;
        case 1:
            return [NSString stringWithFormat: @"%@ lb",[_weightArray objectAtIndex:row]];
            break;
        case 2:
            return [_okArray objectAtIndex:row];
            break;
        default:
            return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSLog(@"Row %d selected in component %d", row, component);
    
    NSString * reps;
    NSString * weight;
    
    NSString * newReps;
    NSString * newWeight;
    NSString * ok;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber;
    
    switch(component) {
        case 0:
            newReps = [_repsArray objectAtIndex:row];
            weight = [_set.weight stringValue];
            // update reps
            self.textLabel.text = [NSString stringWithFormat:@"Set %@:  %@ x %@ lb", _set.setNumber, newReps, weight];
            _set.reps = [NSNumber numberWithInt:[newReps intValue]];
            // update in persistent data
            myNumber = [f numberFromString:newReps];
            [BFWorkoutList setReps:myNumber atIndex:_sIndex toExerciseAtIndex:_eIndex inWorkoutAtIndex:_wIndex];
            break;
        case 1:
            reps = [_set.reps stringValue];
            newWeight = [_weightArray objectAtIndex:row];
            // update weight
            self.textLabel.text = [NSString stringWithFormat:@"Set %@:  %@ x %@ lb", _set.setNumber, reps, newWeight];
            _set.weight = [NSNumber numberWithFloat:[newWeight floatValue]];
            // update in persistent data
            myNumber = [f numberFromString:newWeight];
            [BFWorkoutList setWeight: myNumber atIndex:_sIndex toExerciseAtIndex:_eIndex inWorkoutAtIndex:_wIndex];
            break;
        case 2:
            ok = [_okArray objectAtIndex:row];
            // if OK, resing fisrt responder
            if ([ok isEqualToString:@"OK"]) {
                [_theTextField resignFirstResponder];
            }
            break;
    }
    
    
    


}

@end
