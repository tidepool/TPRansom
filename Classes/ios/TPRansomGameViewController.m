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
    codebreakerStageVC.numberOfRows = 2 + (level+2) / 4;
    codebreakerStageVC.numberOfColumns = 2 + (level) / 4;

    codebreakerStageVC.numberOfRows = 5;
    codebreakerStageVC.numberOfColumns = 5;

    self.levelLabel.text = [NSString stringWithFormat:@"%i", level];
    self.informationTitleLabel.text = @"CIRCLES:";
    self.informationValueLabel.text = [NSString stringWithFormat:@"%i", 2];
}

-(void)configureResult:(TPResultViewController *)result
{
  NSString *game = @"ransom";
    result.backgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@bg-blur.jpg", game]];
    result.gameNameLabel.text = [game uppercaseString];
    result.totalScoreLabel.text = [NSString stringWithFormat:@"%i", self.score + self.bonusScore];
    result.informationTitleLabel.text = @"CIRCLES";
//    result.informationValueLabel.text = self.ci
    result.bonusScoreLabel.text = [NSString stringWithFormat:@"%i", self.bonusScore];
    result.levelLabel.text = [NSString stringWithFormat:@"%i", self.level];
    result.levelScoreLabel.text = [NSString stringWithFormat:@"%i", self.score];
}

@end
