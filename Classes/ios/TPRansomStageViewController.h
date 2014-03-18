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

@property (nonatomic, assign) int numberOfRows;
@property (nonatomic, assign) int numberOfColumns;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;

@end
