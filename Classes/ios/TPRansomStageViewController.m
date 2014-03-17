//
//  TPGameCodeBreakerViewController.m
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import "TPRansomStageViewController.h"
#import "TPCircleView.h"

@interface TPRansomStageViewController ()
{
    NSMutableArray *_circles;
    NSMutableSet *_chosenIndices;
}
@end

@implementation TPRansomStageViewController

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
    // Do any additional setup after loading the view from its nib.
    _circles = [@[] mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    float radius = 50;
    for (int i=0; i<self.numberOfCirclesColumns; i++) {
        for (int j=0; j<self.numberOfCirclesRows; j++) {
            int spaceBetweenCircles = 10;
            int x = self.view.bounds.size.width/2 + (radius + spaceBetweenCircles / 2) * (i - self.numberOfCirclesColumns / 2.0);
            int y = self.view.bounds.size.height/2 + (radius + spaceBetweenCircles / 2) * (j - self.numberOfCirclesRows / 2.0);
            TPCircleView *circle = [[TPCircleView alloc] initWithFrame:CGRectMake(x, y, radius, radius)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [circle addGestureRecognizer:tap];
            [_circles addObject:circle];
        }
    }
    double maxDelay;
    for (int i=0;i<[_circles count]; i++) {
        TPCircleView *circle = _circles[i];
        double delayInSeconds = 0.5 + 0.2*(i%self.numberOfCirclesRows);
        maxDelay = delayInSeconds;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [circle buildInBounce];
            [self.view addSubview:circle];
        });
    }
    double delayInSeconds = maxDelay + 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _chosenIndices = [NSMutableSet set];
        for (int i=0;i<self.numberOfCorrectCircles;i++) {
            int index = arc4random()%_circles.count;
            while ([_chosenIndices containsObject:[NSNumber numberWithInt:index]]) {
                index = arc4random()%_circles.count;
            }
            [_chosenIndices addObject:[NSNumber numberWithInt:index]];
        }
        for (NSNumber *index in _chosenIndices) {
            TPCircleView *circle = _circles[[index intValue]];
            [circle flipToShowSelection];
        }
    });
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    TPCircleView *circle = (TPCircleView *)sender.view;
    [self touchedCircle:circle];
}

-(void)touchedCircle:(TPCircleView *)circle
{
    if (!circle.userInteractionEnabled)
        return;
    int index = (int)[_circles indexOfObject:circle];
    if ([_chosenIndices containsObject:[NSNumber numberWithInt:index]]) {
        circle.selected = !circle.selected;
        circle.userInteractionEnabled = NO;
        [_chosenIndices removeObject:[NSNumber numberWithInt:index]];
        if (![_chosenIndices count]) {
            [self showResultGraphicCorrect:YES];
            [self buildOutAndProceed:YES];
        }
    } else {
        [self showResultGraphicCorrect:NO];
        [self buildOutAndProceed:NO];
    }
}

-(void)buildOutAndProceed:(BOOL)proceed
{
    for (int i=0;i<[_circles count]; i++) {
        TPCircleView *circle = _circles[i];
        [circle buildOutBounce];
    }
//    [_circles removeAllObjects];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.gameVC currentStageOverProceed:proceed];
    });
}

-(void)adjustScoreForCorrect:(BOOL)correct
{
    if (correct) {
        self.gameVC.score += 100 * (self.numberOfCorrectCircles);
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (TPCircleView *circle in _circles) {
        CGPoint locationPoint = [[touches anyObject] locationInView:circle];
        BOOL pointInsideView = [circle pointInside:locationPoint withEvent:event];
        if (pointInsideView) {
            [self touchedCircle:circle];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
