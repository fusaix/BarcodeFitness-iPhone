//
//  BFCollectionViewCell.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/4/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFCollectionViewCell.h"

@implementation BFCollectionViewCell

@synthesize rectangleLabel = _rectangleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
//    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1]; // 0.1
    
    // add the rectangle label
    _rectangleLabel = [[UILabel alloc] initWithFrame:self.frame];
    _rectangleLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    _rectangleLabel.layer.borderWidth = 5.0;
    _rectangleLabel.layer.hidden = YES;
    [self addSubview:_rectangleLabel];
        
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
