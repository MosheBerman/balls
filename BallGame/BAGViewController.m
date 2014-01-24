//
//  BAGViewController.m
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "BAGViewController.h"

#import "BAGBall.h"

@interface BAGViewController ()

@property (nonatomic, strong) NSMutableArray *balls;

@end

@implementation BAGViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _balls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        
        CGPoint location = [touch locationInView:self.view];
        
        if ([[self balls] count] == 0)
        {
            [self newBallAtPoint:location];
        }
        
        
        [self newBallAtPoint:location];
        
        
    }
    
    
}

#pragma mark - New Ball

- (void)newBallAtPoint:(CGPoint)point
{
    
    CGFloat randomRadius = arc4random() % 50 + 15;
    BAGBall *ball = [BAGBall ballWithRadius:randomRadius];
    ball.center = point;
    [[self balls] addObject:ball];
    [[self view] addSubview:ball];
    
}

@end
