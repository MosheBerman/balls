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
    
    CGFloat component = (CGFloat)(arc4random() % 255 + 0)/255.0;
    
    return [UIColor colorWithRed:component green:component blue:component alpha:1.0];
}

@end
