//
//  BFSelectedFrameLabel.m
//  BarcodeFitness-iPhone
//
//  Created by Louis CHEN on 8/7/14.
//  Copyright (c) 2014 FrienchFriesApps. All rights reserved.
//

#import "BFSelectedFrameLabel.h"

@implementation BFSelectedFrameLabel {
    bool _selected;
    CALayer* _rectangleLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        _rectangleLayer = [CALayer layer];
//        _rectangleLayer.backgroundColor = [[UIColor clearColor] CGColor];
//        _rectangleLayer.hidden = NO;
//        
//        _rectangleLayer.borderColor = [UIColor redColor].CGColor;
//        _rectangleLayer.borderWidth = 1.0;
//        [self.layer addSublayer:_rectangleLayer];
        
    }
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
