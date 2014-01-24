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

@property (nonatomic, strong) NSMutableSet *balls;
@property (nonatomic, strong) NSMutableSet *uninstalledBalls;
@property (nonatomic, assign) NSInteger maximumVisibleBalls;

@end

@implementation BAGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _balls = [[NSMutableSet alloc] init];
        _uninstalledBalls = [[NSMutableSet alloc] init];
        _maximumVisibleBalls = 50;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView:self.view];
        [self newBallAtPoint:location];
    }
    
    [self performSelectorOnMainThread:@selector(installQueuedBalls) withObject:Nil waitUntilDone:NO];
}

#pragma mark - New Ball

- (void)newBallAtPoint:(CGPoint)point
{
    
    CGFloat randomRadius = arc4random() % 50 + 15;
    BAGBall *ball = [BAGBall ballWithRadius:randomRadius];
    ball.center = point;
    [[self uninstalledBalls] addObject:ball];
}

#pragma mark - Install Queued Balls

- (void)installQueuedBalls
{
    for (BAGBall *ball in [self uninstalledBalls]) {
        
        BAGBall *ballToRemove = [[self balls] anyObject];
        
        [[self balls] addObject:ball];

        [ball addToSuperview:self.view WithAnimationCompletion:^{
            
            if ([[self balls] count] > self.maximumVisibleBalls) {

                [ballToRemove removeFromSuperviewWithAnimationCompletion:^{
                    [[self balls] removeObject:ballToRemove];
                }];
                
            }
        }];
    }
    
    [[self uninstalledBalls] removeAllObjects];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
