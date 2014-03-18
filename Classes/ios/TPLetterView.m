//
//  TPCircleView.m
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import "TPLetterView.h"
#import "CGHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation TPLetterView
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
}

-(void)setLetter:(NSString *)letter
{
    _letter = letter;
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"letters/%@1.png", _letter]];
}

-(void)buildInBounce
{
    float time = 0.2;
    self.transform = CGAffineTransformMakeScale(1, 1);
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    [animation setFromValue:[NSNumber numberWithFloat:0]];
    [animation setToValue:[NSNumber numberWithFloat:1]];
    [animation setDuration:time];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :0.5 :0.9 :1.5]];
    [self.layer addAnimation:animation forKey:nil];
    animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [animation setFromValue:[NSNumber numberWithFloat:0]];
    [animation setToValue:[NSNumber numberWithFloat:1]];
    [animation setDuration:time];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :0.5 :0.9 :1.5]];
    [self.layer addAnimation:animation forKey:nil];
    
}

-(void)buildOutBounce
{
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform t = CGAffineTransformIdentity;
        t = CGAffineTransformScale(t, 0.2, 0.2);
        self.transform = t;
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
