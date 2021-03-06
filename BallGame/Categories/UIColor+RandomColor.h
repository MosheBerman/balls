//
//  UIColor+RandomColor.h
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (RandomColor)

+ (UIColor *)randomColor;
+ (UIColor *)randomShadeOfGray; //  Can't ever produce white, always at least slighlty darker

+ (UIColor *)averageBetweenColor:(UIColor *)color andColor:(UIColor *)anotherColor;

- (UIColor *)inverseColor;

@end
