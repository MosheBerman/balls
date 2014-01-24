//
//  BAGBall.h
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+RandomColor.h"

typedef void(^BAGBallAnimationCompletionBlock)(void);

@interface BAGBall : UIView

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat borderWidth;

+ (BAGBall *)ballWithRadius:(CGFloat)radius;
- (id)initWithRadius:(CGFloat)radius;

- (void)addToSuperview:(UIView *)view WithAnimationCompletion:(BAGBallAnimationCompletionBlock)completion;
- (void)removeFromSuperviewWithAnimationCompletion:(BAGBallAnimationCompletionBlock)completion;


@end
