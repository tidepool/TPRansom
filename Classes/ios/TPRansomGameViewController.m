//
//  TPRansomGameViewController.m
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 2/4/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import "TPRansomGameViewController.h"
#import "TPRansomStageViewController.h"
#import "TPRansomResultViewController.h"

@interface TPRansomGameViewController ()
@end

@implementation TPRansomGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
    self.StageClass = [TPRansomStageViewController class];
    self.ResultClass = [TPResultViewController class];
    [super commonInit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureStage:(TPStageViewController *)stage forLevel:(int)level
{
    TPRansomStageViewController *codebreakerStageVC = (TPRansomStageViewController *)stage;
    codebreakerStageVC.numberOfCirclesRows = 2 + (level+2) / 4;
    codebreakerStageVC.numberOfCirclesColumns = 2 + (level) / 4;
    codebreakerStageVC.numberOfCorrectCircles = level + 1;
    
    self.levelLabel.text = [NSString stringWithFormat:@"%i", level];
    self.informationTitleLabel.text = @"CIRCLES:";
    self.informationValueLabel.text = [NSString stringWithFormat:@"%i", codebreakerStageVC.numberOfCorrectCircles];
}

-(void)configureResult:(TPResultViewController *)result
{
    result.backgroundImageView.image = [UIImage imageNamed:@"codebreakerbg-blur.jpg"];
    result.totalScoreLabel.text = [NSString stringWithFormat:@"%i", self.score + self.bonusScore];
    result.informationTitleLabel.text = @"CIRCLES";
//    result.informationValueLabel.text = self.ci
    result.bonusScoreLabel.text = [NSString stringWithFormat:@"%i", self.bonusScore];
    result.levelLabel.text = [NSString stringWithFormat:@"%i", self.level];
    result.levelScoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
}

@end