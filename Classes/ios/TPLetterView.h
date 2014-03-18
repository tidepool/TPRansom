//
//  TPCircleView.h
//  TidePoolTwo
//
//  Created by Mayank Sanganeria on 1/31/14.
//  Copyright (c) 2014 TidePool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPDesignHelper.h"

@interface TPLetterView : UIImageView

@property (strong, nonatomic) NSString *letter;

-(void)buildInBounce;
-(void)buildOutBounce;

@end
