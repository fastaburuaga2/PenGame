//
//  HelloScene.m
//  Blyanter
//
//  Created by Francisco Astaburuaga on 3/19/14.
//  Copyright (c) 2014 Francisco Astaburuaga. All rights reserved.
//

#import "HelloScene.h"
#import "GameScene.h"

@interface HelloScene ()
@property BOOL contentCreated;
@end

@implementation HelloScene
    
- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}
    
//Creamos la escena:

- (void)createSceneContents
{
    self.scaleMode = SKSceneScaleModeAspectFit;
    
}




//Creamos el label Hello World:

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Welcome to Pencil's Story!";
    helloNode.fontSize = 20;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    helloNode.name = @"helloNode";
    return helloNode;
}

//Cuando toca la pantalla, se crea el label, se anima, y luego se pasa a la escena de la nave:

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    [self addChild: [self newHelloNode]];
    SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    if (helloNode != nil)
    {
        
        SKAction *moveUp = [SKAction moveByX: 0 y: 50.0 duration: 0.5];
        SKAction *moveDown = [SKAction moveByX: 0 y: -50.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *moveSequence = [SKAction sequence:@[moveUp,moveDown, zoom, pause,fadeAway,remove]];
        
        [helloNode runAction: moveSequence completion:^{
            SKScene *GameScenes  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:GameScenes transition:doors];
        }];
    }
}

@end
