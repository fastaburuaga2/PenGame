//
//  SpaceshipScene.m
//  Blyanter
//
//  Created by Francisco Astaburuaga on 3/19/14.
//  Copyright (c) 2014 Francisco Astaburuaga. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
@property BOOL contentCreated;
@end

@implementation GameScene{
    
    SKSpriteNode *pen;
    SKSpriteNode *background;
    SKLabelNode *start;
    SKLabelNode *world;
    SKLabelNode *GameOver;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    NSTimer *timer;
    bool comenzarSpawn;
    bool gameover;
    bool direccion;
    int enemigos;
}

//Se cargo la View, luego cargamos la escena:

- (void)didMoveToView:(SKView *)view
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
    
    //Definimos los elementos:
    
    start = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    start.position =CGPointMake(CGRectGetMidX(self.frame)+150,CGRectGetMidY(self.frame));
    start.fontSize = 30;
    start.fontColor = [SKColor blackColor];
    start.text = @"Tap to Start";
    
    world = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    world.position =CGPointMake(CGRectGetMidX(self.frame)-240,CGRectGetMidY(self.frame)+120);
    world.fontSize = 12;
    world.fontColor = [SKColor blackColor];
    world.text = @"World 1";
    
    background = [[SKSpriteNode alloc] initWithImageNamed:(NSString  *) @"fondo1.jpg" ];
    background.position =CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    
    pen = [[SKSpriteNode alloc] initWithImageNamed:(NSString  *) @"Pen.gif" ];
    pen.xScale = 0.15;
    pen.yScale = 0.15;
    pen.anchorPoint = CGPointMake(1, 0.5);
    pen.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pen.size];
    
    //pen.physicsBody.dynamic = NO;
    
    pen.position = CGPointMake(CGRectGetMidX(self.frame)-160,CGRectGetMidY(self.frame));
    actionMoveUp = [SKAction moveByX:0 y:40 duration:.8];
    actionMoveDown = [SKAction moveByX:0 y:-40 duration:.8];
    
    //Seteamos la gravedad:
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    //Agregamos los nodos pertinentes y el timer:
    
    [self addChild:background];
    [self addChild:start];
    [self addChild:world];
    [self addChild:pen];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(PenMoving) userInfo:nil repeats:YES];
    
    
    
}

-(void)EndGame{
    
    pen.physicsBody.velocity = CGVectorMake(0, 0);
    gameover = true;
    GameOver = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    GameOver.position =CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    GameOver.fontSize = 30;
    GameOver.fontColor = [SKColor redColor];
    GameOver.text = @"Game Over";
    
      SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.5];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *moveSequence = [SKAction sequence:@[fadeAway,remove]];
    [pen runAction: moveSequence];
    
    [self removeAllActions];
    [self addChild:GameOver];
    
    [timer invalidate ];
    
    
}

//Timer:

-(void)PenMoving{
    
    //Condiciones de Muerte:
    
    
    if (pen.position.y > CGRectGetMaxY(self.frame)-15 || pen.position.y < CGRectGetMinY(self.frame) + 15) {
        
        [self EndGame ];
        
    }
    
    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0){
            [node removeFromParent];
        }
        else{
            node.physicsBody.velocity = CGVectorMake(-100, 0);
        }
        
        if (CGRectIntersectsRect(node.frame, pen.frame)) {
            [self EndGame];
        }
        
        if (gameover) {
            node.physicsBody.velocity = CGVectorMake(0, 0);
        }
        
    }];
}


//Controlamos el movimiento del lapiz:



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (gameover) {
        
        [self removeAllChildren];
        [self createSceneContents];
        gameover = false;
        comenzarSpawn = false;
        
    }
    
    else{
        
        if (!comenzarSpawn) {
            
            enemigos = 20;
            SKAction *makeEnemies = [SKAction sequence: @[
                                                          [SKAction performSelector:@selector(addEnemie) onTarget:self],
                                                          [SKAction waitForDuration:2 withRange:1]
                                                          ]];
            [self runAction: [SKAction repeatAction:makeEnemies count:enemigos]];
        }
        comenzarSpawn = true;
        
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self.scene]; //1
        
        if (touchLocation.x > CGRectGetMidX(self.frame)) {
            
            if(direccion){ //2
                
                [pen runAction: [SKAction moveByX:0 y:2 duration:0.01]];
                pen.physicsBody.velocity = CGVectorMake(0, 170);
                //[pen runAction:actionMoveUp]; //4
                
                
                
                [pen removeAllActions];
                [pen runAction: [SKAction rotateToAngle: .3 duration:.6]];
                
                
            }else{
                [pen runAction: [SKAction moveByX:0 y:-2 duration:0.01]];
                pen.physicsBody.velocity = CGVectorMake(0, -170);
                //[pen runAction:actionMoveDown]; //5
                
                [pen removeAllActions];
                [pen runAction: [SKAction rotateToAngle: -.3 duration:.6]];
            }
        }
        
        direccion = !direccion;
        
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.5];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *moveSequence = [SKAction sequence:@[fadeAway,remove]];
        
        [start runAction: moveSequence];
    }
    
}


//Caida de Rocas:


static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addEnemie
{
    SKSpriteNode *enemie = [[SKSpriteNode alloc] initWithImageNamed:@"Arrow.gif"];
    enemie.position = CGPointMake(self.size.width, skRand(20, self.size.height-20));
    enemie.xScale = 0.15;
    enemie.yScale = 0.15;
    
    enemie.name = @"arrow";
    enemie.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemie.size];
    enemie.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:enemie];
}



//Borramos los elementos que se van de la pantalla:

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"arrow" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}




@end
