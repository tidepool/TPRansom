//
//  TPGameCodeBreakerViewController.h
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPStageViewController.h"

@interface TPRansomStageViewController : TPStageViewController

@property (nonatomic, assign) int numberOfCirclesRows;
@property (nonatomic, assign) int numberOfCirclesColumns;
@property (nonatomic, assign) int numberOfCorrectCircles;

@end
