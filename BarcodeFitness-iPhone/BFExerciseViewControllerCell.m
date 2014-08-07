//
//  BFExerciseViewControllerCell.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/6/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFExerciseViewControllerCell.h"
//#import "BFEditContentLabel.h"
#import "BFSelectedFrameLabel.h"

@implementation BFExerciseViewControllerCell{
    BFSelectedFrameLabel *_rectangleLabel;
    UITextField *_theTextField;
    UIPickerView *_pickerView;

}

//@synthesize text = _text;
@synthesize setNumber = _setNumber;


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
//    _theTextField.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    _theTextField.inputView.userInteractionEnabled = NO;
    _theTextField.textColor = [UIColor clearColor];
    
    _theTextField.inputView = _pickerView;
    
    [self addSubview:_theTextField];
    

    // add gesture recognizers to cell
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startEditingCell:)];
//        longPress.delegate = self;
//        [cell addGestureRecognizer:longPress];
    
    
    // add the rectangle label 
    _rectangleLabel = [[BFSelectedFrameLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _rectangleLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    _rectangleLabel.layer.borderWidth = 3.0;
    _rectangleLabel.layer.hidden = YES;
    [self addSubview:_rectangleLabel];
    
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


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//}

#pragma mark - TextField methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    _rectangleLabel.layer.hidden = YES;

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
    
}


#pragma mark - PickerView methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"OK";
}


@end
