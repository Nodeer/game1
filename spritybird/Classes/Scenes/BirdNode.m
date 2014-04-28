//
//  BirdNode.m
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "BirdNode.h"

#define VERTICAL_SPEED 1
#define VERTICAL_DELTA 5.0

@interface BirdNode ()
@property (strong,nonatomic) SKAction * flap;
@property (strong,nonatomic) SKAction * flapForever;
@end

@implementation BirdNode

static CGFloat deltaPosY = 0;
static bool goingUp = false;

- (id)init
{
    if(self = [super init]){
        
        self = [BirdNode spriteNodeWithColor:[UIColor   colorWithRed:0.0/255.0
                                                                                 green:128.0/255.0
                                                                                  blue:255.0/255.0
                                                                                 alpha:1.0] size:CGSizeMake(NODE_HIGHT, NODE_HIGHT)];
        
//        http://stackoverflow.com/questions/21695305/skspritenode-create-a-round-corner-node
        
//        SKSpriteNode *tile = [SKSpriteNode spriteNodeWithColor:[UIColor   colorWithRed:0.0/255.0
//                                                                                 green:128.0/255.0
//                                                                                  blue:255.0/255.0
//                                                                                 alpha:1.0] size:CGSizeMake(30, 30)];
//        SKCropNode* cropNode = [SKCropNode node];
//        SKShapeNode* mask = [SKShapeNode node];
//        [mask setPath:CGPathCreateWithRoundedRect(CGRectMake(-15, -15, 30, 30), 4, 4, nil)];
//        [mask setFillColor:[SKColor whiteColor]];
//        [cropNode setMaskNode:mask];
//        [cropNode addChild:tile];
        
        //[self addChild:cropNode];
        
        self.textLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        self.textLabel.text = @"2";
        self.textLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.textLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.textLabel];
        
        self.isContact = NO;
    }

    return self;
}

- (void) update:(NSUInteger) currentTime
{
    if (self.isContact) {
//        self.position = CGPointMake(X(self) + FLOOR_SCROLLING_SPEED, Y(self));
        self.zRotation = 0;
        return;
    }
    
    if(!self.physicsBody){
        if(deltaPosY > VERTICAL_DELTA){
            goingUp = false;
        }
        if(deltaPosY < -VERTICAL_DELTA){
            goingUp = true;
        }
        
        float displacement = (goingUp)? VERTICAL_SPEED : -VERTICAL_SPEED;
        self.position = CGPointMake(self.position.x, self.position.y + displacement);
        deltaPosY += displacement;
    }
    
    // Rotate body based on Y velocity (front toward direction)
    self.zRotation = M_PI * self.physicsBody.velocity.dy * 0.0005;
    
}

- (void) startPlaying
{
    deltaPosY = 0;
    [self setPhysicsBody:[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(26, 18)]];
    self.physicsBody.categoryBitMask = birdBitMask;
    self.physicsBody.mass = 0.1;
}

- (void) bounce
{
    if (self.isContact) {
        return;
    }
    [self.physicsBody setVelocity:CGVectorMake(0, 0)];
    [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
}

- (void) setTextNumber:(int) number {
    self.textLabel.text = [NSString stringWithFormat:@"%i",number];
}

- (int) getTextNumber {
    return [self.textLabel.text intValue];
}

- (void)setIsContact:(BOOL *)isContact {
    _isContact = isContact;
    if (isContact) {
//        self.physicsBody.density = 0.01;
    } else {
    }
}
@end
