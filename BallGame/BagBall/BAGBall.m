//
//  BAGBall.m
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "BAGBall.h"

@import QuartzCore;

@interface BAGBall ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) BAGBallAnimationCompletionBlock installationCompletion;

@end

@implementation BAGBall

+ (BAGBall *)ballWithRadius:(CGFloat)radius
{
    return [[BAGBall alloc] initWithRadius:radius];
}

- (id)initWithRadius:(CGFloat)radius
{
    
    CGRect frame = CGRectMake(0, 0, radius*2, radius*2);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _radius = radius;
        _color = [UIColor randomColor];
        _borderWidth = arc4random() % 10 + 1;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.layer.cornerRadius = _radius;
    self.layer.borderColor = self.color.CGColor;
    self.backgroundColor = [self.color colorWithAlphaComponent:0.8];
    self.layer.borderWidth = self.borderWidth;
    
    self.alpha = 0;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.alpha = 1.0;
                         self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                          animations:^{
                                              self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                              if (self.installationCompletion) {
                                                  self.installationCompletion();
                                              }
                                          }];
                         
                     }];
    
}

#pragma mark - Appear

- (void)addToSuperview:(UIView *)view WithAnimationCompletion:(BAGBallAnimationCompletionBlock)completion
{
    _installationCompletion = completion;
    [view addSubview:self];
}

#pragma mark - Disappear

- (void)removeFromSuperviewWithAnimationCompletion:(BAGBallAnimationCompletionBlock)completion
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGAffineTransform t = CGAffineTransformScale(self.transform, 0, 0);
                         [self setTransform:t];
                         [self setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                         if (completion) {
                             completion();
                         }
                     }];
    
}
@end
