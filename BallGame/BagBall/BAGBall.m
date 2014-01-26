//
//  BAGBall.m
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "BAGBall.h"

@import QuartzCore;
@import AVFoundation;

@interface BAGBall ()

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) BAGBallAnimationCompletionBlock installationCompletion;
@property (nonatomic, strong) UIColor *grayColor;

/* Sound Effects */
@property (readwrite) CFURLRef spawnSoundFileRef;
@property (readwrite) CFURLRef dieSoundFileRef;

@property (readonly) SystemSoundID spawnSoundID;
@property (readonly) SystemSoundID dieSoundID;

/* Long press to pop.*/
@property (nonatomic, strong) UILongPressGestureRecognizer *longPop;

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
        _grayColor = [UIColor randomShadeOfGray];
        _borderWidth = arc4random() % 10 + 1;
        _touchToFollow = nil;
        _isGrayScale = NO;
        
        _longPop = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
        
        /* Sound */
        NSURL *sound = [[NSBundle mainBundle] URLForResource:@"spawn" withExtension:@"m4a"];
        
        _spawnSoundFileRef = CFBridgingRetain(sound);
        
        AudioServicesCreateSystemSoundID(_spawnSoundFileRef, &_spawnSoundID);
        
        sound = [[NSBundle mainBundle] URLForResource:@"pop" withExtension:@"m4a"];
        
        _dieSoundFileRef = CFBridgingRetain(sound);
        
        AudioServicesCreateSystemSoundID(_dieSoundFileRef, &_dieSoundID);
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
    self.layer.borderWidth = self.borderWidth;
    [self applyColor];
    
    self.alpha = 0;
    self.transform = CGAffineTransformIdentity;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    AudioServicesPlaySystemSound(_spawnSoundID);
    
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

#pragma mark - Setter

- (void)setIsGrayScale:(BOOL)isGrayScale
{
    _isGrayScale = isGrayScale;
    
    [self applyColor];
}

- (void)applyColor
{
    if ([self isGrayScale]) {
        self.layer.borderColor = self.grayColor.CGColor;
        self.backgroundColor = [self.grayColor colorWithAlphaComponent:0.8];
    }
    else
    {
        self.layer.borderColor = self.color.CGColor;
        self.backgroundColor = [self.color colorWithAlphaComponent:0.8];
    }
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
    [UIView animateWithDuration:0.1f
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

- (void)pop
{
    AudioServicesPlaySystemSound(_dieSoundID);
    [self removeFromSuperviewWithAnimationCompletion:^{
        
    }];
}

#pragma mark - Active Color

- (UIColor *)activeColor
{
    if ([self isGrayScale]) {
        return [self grayColor];
    }
    return [self color];
}
@end
