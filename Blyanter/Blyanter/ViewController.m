//
//  ViewController.m
//  Blyanter
//
//  Created by Francisco Astaburuaga on 3/18/14.
//  Copyright (c) 2014 Francisco Astaburuaga. All rights reserved.
//

#import "ViewController.h"
#import "HelloScene.h"
#import "GameScene.h"

@implementation ViewController




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    
    [skView sizeThatFits:self.view.bounds.size];
    
    
    // Create and configure the scene.
    SKScene * scene = [GameScene sceneWithSize:CGSizeMake(570, 320)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    
    // Present the scene.
    [skView presentScene:scene];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
