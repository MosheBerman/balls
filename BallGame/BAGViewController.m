//
//  BAGViewController.m
//  BallGame
//
//  Created by Moshe Berman on 1/23/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "BAGViewController.h"

#import "BAGBall.h"

#import <tgmath.h>

@import CoreMotion;

@interface BAGViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) NSMutableSet *ballsToAdd;
@property (nonatomic, strong) NSMutableSet *oldBalls;
@property (nonatomic, assign) NSInteger maximumVisibleBalls;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@property (strong, nonatomic) IBOutlet UISegmentedControl *colorToggle;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) CMAccelerometerData *data;
@property (nonatomic, assign) CGPoint originalCenter;

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
        _collision.collisionDelegate = self;
        _motionManager = [[CMMotionManager alloc] init];
        _originalCenter = CGPointZero;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  By default, grayscale UI.
    [[self view] setTintColor:[UIColor grayColor]];

    [self reposition];
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
    [ball setIsGrayScale:([[self colorToggle] selectedSegmentIndex] == 0)];
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

#pragma mark - Remove Extra Balls

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


#pragma mark - Color Toggle

- (IBAction)didToggleColor:(id)sender
{
    
    BOOL isGray = [self isGrayscale];
    
    if (isGray) {
        [[self view] setTintColor:[UIColor grayColor]];
    }
    else
    {
        [[self view] setTintColor:[[[self view] backgroundColor] inverseColor]];
    }
    
    for (BAGBall *ball in [self balls]) {
        [ball setIsGrayScale:isGray];
    }
    
    
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    /* If two balls collide... */
    if ([item1 isKindOfClass:[BAGBall class]] && [item2 isKindOfClass:[BAGBall class]])
    {
        
        BAGBall *firstBall = (BAGBall *)item1;
        BAGBall *secondBall = (BAGBall *)item2;
        
        UIColor *firstColor = [firstBall activeColor];
        UIColor *secondColor = [secondBall activeColor];
        
        UIColor *averageColor = [UIColor averageBetweenColor:firstColor andColor:secondColor];
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             [[self view] setBackgroundColor:averageColor];
                             [[self view] setTintColor:[averageColor inverseColor]];
                             
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    /* If  a ball collides with a boundry or UI elemeent. */
    else if ([item1 isKindOfClass:[BAGBall class]] || [item2 isKindOfClass:[BAGBall class]])
    {
        
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2
{
    
}

#pragma mark - Grayscale Vs Color

- (BOOL)isGrayscale
{
    return [[self colorToggle] selectedSegmentIndex] == 0;
}

#pragma mark - Accelerometer Based Gravity

- (void)reposition
{
    if (CGPointEqualToPoint(_originalCenter, CGPointZero))
    {
        _originalCenter = self.view.center;
    }
    
    static CGFloat lastX = 0.0f;
    static CGFloat lastY = 0.0f;
    
    __block __weak BAGViewController *weakSelf = self;
    
    BOOL available = [[self motionManager] isAccelerometerAvailable];
    
    if (!available) {
        NSLog(@"No gyro.");
    }
    
    [[self motionManager] startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        weakSelf.data = accelerometerData;
        
        CGPoint center = self.view.center;
        
        center.x += self.data.acceleration.x;
        center.y -= self.data.acceleration.y;
        
        lastX = self.data.acceleration.x;
        lastY = self.data.acceleration.y;
        
        CGFloat factor = [self nudgeFactor];
        
        center.x = _originalCenter.x + (lastX * factor);
        center.y = _originalCenter.y + (lastY * factor);
        
        CGFloat angle = atan(center.x/center.y);
        
        NSLog(@"%.2f", angle);
        
        [[self gravity] setAngle:angle magnitude:1.0];

    }];
}

- (CGFloat)nudgeFactor
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 50.0f : 20.0f;
}




@end
