//
//  UIColor+RandomColor.m
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+ (UIColor *)randomColor
{
    
    CGFloat red = (CGFloat)(arc4random() % 255 + 0)/255.0;
    CGFloat green = (CGFloat)(arc4random() % 255 + 0)/255.0;
    CGFloat blue = (CGFloat)(arc4random() % 255 + 0)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)randomShadeOfGray
{
    
    CGFloat component = (CGFloat)(arc4random() % 255 + 2)/255.0;
    
    return [UIColor colorWithRed:component green:component blue:component alpha:1.0];
}

+ (UIColor *)averageBetweenColor:(UIColor *)color andColor:(UIColor *)anotherColor
{
    CGColorRef firstColor = [color CGColor];
    CGColorRef secondColor = [anotherColor CGColor];
    
    const float* firstComponents = CGColorGetComponents(firstColor);
    const float* secondComponents = CGColorGetComponents(secondColor);
    
    CGFloat red = (firstComponents[0] + secondComponents[0])/2.0f;
    CGFloat green = (firstComponents[1] + secondComponents[1])/2.0f;
    CGFloat blue = (firstComponents[2] + secondComponents[2])/2.0f;
    CGFloat alpha = (firstComponents[3] + secondComponents[3])/2.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)inverseColor
{
    
    CGColorRef firstColor = [self CGColor];
    const float* components = CGColorGetComponents(firstColor);
    
    CGFloat red = 1.0 - components[0];
    CGFloat green = 1.0 - components[1];
    CGFloat blue = 1.0 - components[2];
    CGFloat alpha = 1.0 - components[3];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
