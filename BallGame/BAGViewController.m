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
@property (nonatomic, strong) NSMutableSet *ballsToAdd;
@property (nonatomic, strong) NSMutableSet *oldBalls;
@property (nonatomic, assign) NSInteger maximumVisibleBalls;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@end

@implementation BAGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _balls = [[NSMutableArray alloc] init];
        _ballsToAdd = [[NSMutableSet alloc] init];
        _oldBalls = [[NSMutableSet alloc] init];
        _maximumVisibleBalls = 10;
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _gravity = [[UIGravityBehavior alloc] initWithItems:@[]];
        [_animator addBehavior:_gravity];
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
        [_animator addBehavior:_collision];
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
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:self.view];
        
        BAGBall *ballBeingTouched = nil;
        
        for (BAGBall *ball in self.balls) {
            if (CGRectContainsPoint(ball.frame, location)) {
                ballBeingTouched = ball;
            }
            
            if (ballBeingTouched)
            {
                break;
            }
        }
        
        if (!ballBeingTouched) {
            [self removeExtraBalls];
            [self newBallAtPoint:location];
        }
        else
        {
            //  Drag ball
            ballBeingTouched.touchToFollow = touch;
            [[self gravity] removeItem:ballBeingTouched];
            [[self collision] removeItem:ballBeingTouched];
        }
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        for (BAGBall *ball in self.balls) {
            if ([ball.touchToFollow isEqual:touch]) {
                [ball setCenter:[touch locationInView:self.view]];
                [[self view] bringSubviewToFront:ball];
                break;
            }
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (BAGBall *ball in self.balls) {
        if ([[[self view] subviews] containsObject:ball]) {
            [[self gravity] addItem:ball];
            [[self collision] addItem:ball];
        }
        ball.touchToFollow = nil;
    }
    
    [self installQueuedBalls];
}

#pragma mark - New Ball

- (void)newBallAtPoint:(CGPoint)point
{
    CGFloat randomRadius = arc4random() % 50 + 15;
    BAGBall *ball = [BAGBall ballWithRadius:randomRadius];
    ball.center = point;
    [[self ballsToAdd] addObject:ball];
}

#pragma mark - Install Queued Balls

- (void)installQueuedBalls
{
    for (BAGBall *ball in [self ballsToAdd])
    {
        [[self balls] addObject:ball];

        __weak BAGBall *weakBall = ball;
        [ball addToSuperview:self.view WithAnimationCompletion:^{
            
            if ([[self.view subviews] containsObject:weakBall]) {
                [_gravity addItem:weakBall];
                [_collision addItem:weakBall];
            }
        }];
    }
    
    [[self ballsToAdd] removeAllObjects];
}

- (void)removeExtraBalls
{
    NSMutableArray *ballsToRemove = [[NSMutableArray alloc] init];
    
    NSInteger extraBalls = self.balls.count - self.maximumVisibleBalls;
    extraBalls = MAX(0, extraBalls);
    
    
    
    for (NSInteger i = 0; i < extraBalls; i++) {
        [ballsToRemove addObject:[self balls][i]];
    }
    
    for (BAGBall *ballToRemove in ballsToRemove) {
        [ballToRemove removeFromSuperviewWithAnimationCompletion:^{
            [[self collision] removeItem:ballToRemove];
            [[self gravity] removeItem:ballToRemove];
            [[self balls] removeObject:ballToRemove];
        }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
