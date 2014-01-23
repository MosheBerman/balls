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
        _color = [UIColor blackColor];
        _borderWidth = arc4random() % 5 + 1;
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
    self.layer.borderWidth = self.borderWidth;
}

@end
