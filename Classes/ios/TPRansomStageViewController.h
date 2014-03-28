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
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet id<UIApplicationDelegate> appDelegate;
@end
