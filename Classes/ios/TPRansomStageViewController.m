//
//  TPGameCodeBreakerViewController.m
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import "TPRansomStageViewController.h"
#import "TPLetterView.h"

@interface TPRansomStageViewController ()
{
    NSMutableArray *_letters;
    NSMutableArray *_chosenLetters;
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
    _letters = [@[] mutableCopy];
    _chosenLetters = [@[] mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    float radius = 50;
    for (int i=0; i<self.numberOfColumns; i++) {
        for (int j=0; j<self.numberOfRows; j++) {
            int spaceBetweenLetters = 10;
            int x = self.view.bounds.size.width/2 + (radius + spaceBetweenLetters / 2) * (i - self.numberOfColumns / 2.0);
            int y = self.view.bounds.size.height/2 + (radius + spaceBetweenLetters / 2) * (j - self.numberOfRows / 2.0);
            TPLetterView *circle = [[TPLetterView alloc] initWithFrame:CGRectMake(x, y, radius, radius)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            circle.letter = [self genRandStringLength:1];
            [circle addGestureRecognizer:tap];
            [_letters addObject:circle];
        }
    }
    double maxDelay;
    for (int i=0;i<[_letters count]; i++) {
        TPLetterView *circle = _letters[i];
        double delayInSeconds = 0.5 + 0.2*(i%self.numberOfRows);
        maxDelay = delayInSeconds;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [circle buildInBounce];
            [self.view addSubview:circle];
        });
    }
    self.buttonContainer.transform = CGAffineTransformMakeTranslation(0, -300);
    [self.cancelButton addTarget:self action:@selector(clearLetters) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clearLetters
{
    [_chosenLetters removeAllObjects];
    [self refreshChosenLetters];
}

-(void)showButtons
{
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonContainer.transform = CGAffineTransformMakeTranslation(0, -150);
    }];
}

-(void)hideButtons
{
    [UIView animateWithDuration:0.2 animations:^{
        self.buttonContainer.transform = CGAffineTransformMakeTranslation(0, -300);
    }];
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    TPLetterView *letter = (TPLetterView *)sender.view;
    if ([_chosenLetters containsObject:letter]) {
        [_chosenLetters removeObject:letter];
        [UIView animateWithDuration:0.2 animations:^{
            letter.transform = CGAffineTransformIdentity;
        }];
        [self refreshChosenLetters];
    } else {
        [_chosenLetters addObject:letter];
        [self refreshChosenLetters];
    }
}

-(void)refreshChosenLetters
{
    float leftPad = 25;
    float letterSpacing = 5;
    if (_chosenLetters.count > 6) {
        letterSpacing = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        for (int i=0; i<_chosenLetters.count; i++) {
            TPLetterView *letter = _chosenLetters[i];
            CGPoint idealPoint = CGPointMake(leftPad + (letter.bounds.size.width + letterSpacing) * i, 50);
            CGPoint diff = CGPointMake(idealPoint.x - letter.center.x, idealPoint.y - letter.center.y);
            letter.transform = CGAffineTransformMakeTranslation(diff.x, diff.y);
//            float scale = fminf(1.0, 1.0 - (0.2*(_chosenLetters.count-6)));
//            NSLog(@"%f", scale);
//            letter.transform = CGAffineTransformScale(letter.transform, scale, scale);
        }
    }];
    if (!_chosenLetters.count) {
        [self hideButtons];
    } else {
        [self showButtons];
    }
}

-(NSString *) genRandStringLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}


//-(void)touchedCircle:(TPLetterView *)circle
//{
//    if (!circle.userInteractionEnabled)
//        return;
//    int index = (int)[_letters indexOfObject:circle];
//    if ([_chosenIndices containsObject:[NSNumber numberWithInt:index]]) {
//        circle.userInteractionEnabled = NO;
//        [_chosenIndices removeObject:[NSNumber numberWithInt:index]];
//        if (![_chosenIndices count]) {
//            [self showResultGraphicCorrect:YES];
//            [self buildOutAndProceed:YES];
//        }
//    } else {
//        [self showResultGraphicCorrect:NO];
//        [self buildOutAndProceed:NO];
//    }
//}

-(void)buildOutAndProceed:(BOOL)proceed
{
    for (int i=0;i<[_letters count]; i++) {
        TPLetterView *circle = _letters[i];
        [circle buildOutBounce];
    }
//    [_letters removeAllObjects];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.gameVC currentStageOverProceed:proceed];
    });
}

-(void)adjustScoreForCorrect:(BOOL)correct
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
