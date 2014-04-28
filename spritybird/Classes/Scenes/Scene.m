//
//  BouncingScene.m
//  Bouncing
//
//  Created by Seung Kyun Nam on 13. 7. 24..
//  Copyright (c) 2013년 Seung Kyun Nam. All rights reserved.
//

#import "Scene.h"
#import "SKScrollingNode.h"
#import "BirdNode.h"
#import "Score.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ObstacleNode.h"

@implementation Scene{
    SKScrollingNode * floor;
    SKScrollingNode * back;
    SKLabelNode * scoreLabel;
    BirdNode * bird;
    
    int nbObstacles;
    int nbObstacleNodes;
    BOOL isContacting;
    CGPoint pointContact;
    NSMutableArray * obstacles;
}

static bool wasted = NO;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
//        [self startGame];
    }
    return self;
}

- (id)initWithSize:(CGSize)size withObstacleType:(NSInteger)obstacleType {
    if (self = [super initWithSize:size]) {
        self.obstacleType = obstacleType;
        self.physicsWorld.contactDelegate = self;
        [self startGame];
    }
    return self;
}


- (void) startGame
{
    // Reinit
    wasted = NO;
    isContacting = NO;
    
    [self removeAllChildren];
    
    [self createBackground];
    [self createFloor];
    [self createScore];
    [self createObstacles];
    [self createBird];
    
    // Floor needs to be in front of tubes
    floor.zPosition = bird.zPosition + 1;
    
    if([self.delegate respondsToSelector:@selector(eventStart)]){
        [self.delegate eventStart];
    }
}

#pragma mark - Creations

- (void) createBackground
{
    back = [SKScrollingNode scrollingNodeWithImageNamed:@"back" inContainerWidth:WIDTH(self)];
    [back setScrollingSpeed:BACK_SCROLLING_SPEED];
    [back setAnchorPoint:CGPointZero];
    [back setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
    back.physicsBody.categoryBitMask = backBitMask;
    back.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:back];
}

- (void) createScore
{
    self.score = 0;
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Bold"];
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 500;
    scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    scoreLabel.alpha = 0.2;
    [self addChild:scoreLabel];
}


- (void)createFloor
{
    floor = [SKScrollingNode scrollingNodeWithImageNamed:@"floor" inContainerWidth:WIDTH(self)];
    [floor setScrollingSpeed:FLOOR_SCROLLING_SPEED];
    [floor setAnchorPoint:CGPointZero];
    [floor setName:@"floor"];
    [floor setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:floor.frame]];
    floor.physicsBody.categoryBitMask = floorBitMask;
    floor.physicsBody.contactTestBitMask = birdBitMask;
    [self addChild:floor];
}

- (void)createBird
{
    bird = [BirdNode new];
    [bird setPosition:CGPointMake(100, CGRectGetMidY(self.frame))];
    [bird setName:@"bird"];
    [self addChild:bird];
}

- (void) createObstacles
{
    // Calculate how many obstacles we need, the less the better
    nbObstacles = ceil(WIDTH(self)/(OBSTACLE_INTERVAL_SPACE));
    
    nbObstacleNodes = ceil((HEIGHT(self) - HEIGHT(floor))/(NODE_HIGHT));
    
    CGFloat lastBlockPos = 0;
    obstacles = @[].mutableCopy;
    for(int i=0;i<nbObstacles;i++){
        
        ObstacleNode *obstacleNode;
        for (int j=0;j< nbObstacleNodes;j++) {
            
            obstacleNode = [ObstacleNode new];
            [obstacleNode setAnchorPoint:CGPointZero];
            [self addChild:obstacleNode];
            [obstacles addObject:obstacleNode];
            
            // Give some time to the player before first obstacle
            if(0 == i){
                [self place:obstacleNode atX:WIDTH(self)+FIRST_OBSTACLE_PADDING index:j];
            }else{
                [self place:obstacleNode atX:lastBlockPos + WIDTH(obstacleNode) +OBSTACLE_INTERVAL_SPACE index:j];
            }
        }
        lastBlockPos = obstacleNode.position.x;
    }
    
}

#pragma mark - Interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(wasted){
        [self startGame];
    }else{
        if (!bird.physicsBody) {
            [bird startPlaying];
            if([self.delegate respondsToSelector:@selector(eventPlay)]){
                [self.delegate eventPlay];
            }
        }
        [bird bounce];
    }
}

#pragma mark - Update & Core logic


- (void)update:(NSTimeInterval)currentTime
{
    if(wasted){
        return;
    }
    
    // ScrollingNodes
    [back update:currentTime];
    [floor update:currentTime];
    
    // Other
    [bird update:currentTime];
    [self updateObstacles:currentTime];
    [self updateScore:currentTime];
}


- (void) updateObstacles:(NSTimeInterval)currentTime
{
    if(!bird.physicsBody){
        return;
    }
    
    for(int i=0;i<nbObstacles;i++){
        
        for(int j=0;j<nbObstacleNodes;j++){

            // Get obstacle
            ObstacleNode * obstacleNode = (ObstacleNode *) obstacles[i*nbObstacleNodes+j];
            
            // Check if obstacle has exited screen, and place them upfront again
            if (X(obstacleNode) < -WIDTH(obstacleNode)){
                int mostRightColumn = (i+(nbObstacles-1))%nbObstacles;
                int mostRightIndex = mostRightColumn*nbObstacleNodes + j;
                SKSpriteNode * mostRightPipe = (SKSpriteNode *) obstacles[mostRightIndex];
                [self place:obstacleNode atX:X(mostRightPipe)+WIDTH(obstacleNode)+OBSTACLE_INTERVAL_SPACE index:j];
            }
            
            if (obstacleNode.isContact) {
                //obstacleNode.position = CGPointMake(X(obstacleNode) + FLOOR_SCROLLING_SPEED, Y(obstacleNode));
                
                if (bird.position.x < pointContact.x + FLOOR_SCROLLING_SPEED) {
                    bird.position = CGPointMake(pointContact.x + FLOOR_SCROLLING_SPEED, pointContact.y);
                } else {
                    bird.position = CGPointMake(X(bird) + FLOOR_SCROLLING_SPEED, Y(bird));
                }
                
                // pass
                if (bird.position.x > obstacleNode.position.x + NODE_HIGHT * 2) {
                    obstacleNode.isContact = NO;
                    isContacting = NO;
                    bird.isContact = NO;
//                    [bird setTextNumber:[bird getTextNumber]*2];
                }
            }
            

            // Move according to the scrolling speed
            obstacleNode.position = CGPointMake(X(obstacleNode) - FLOOR_SCROLLING_SPEED, Y(obstacleNode));
            
            
        }
    }
}

- (void) place:(SKSpriteNode *) obstacleNode atX:(float) xPos index:(int) index
{
    // Maths
    float yPos = HEIGHT(floor) + NODE_HIGHT * index;
    obstacleNode.position = CGPointMake(xPos,yPos);
    obstacleNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,0, WIDTH(obstacleNode) , HEIGHT(obstacleNode))];
    obstacleNode.physicsBody.categoryBitMask = blockBitMask;
    obstacleNode.physicsBody.contactTestBitMask = birdBitMask;
}


- (void) updateScore:(NSTimeInterval) currentTime
{
    for(int i=0;i<nbObstacles;i++){
        
        SKSpriteNode * topPipe = (SKSpriteNode *) obstacles[i];
        
        // Score, adapt font size
        if(X(topPipe) + WIDTH(topPipe)/2 > bird.position.x &&
           X(topPipe) + WIDTH(topPipe)/2 < bird.position.x + FLOOR_SCROLLING_SPEED){
            self.score += 1;
            
            // Check revise
            if ([Score isGainReviseScore:self.score]) {
                // revise the bird -> change color
//                [bird birdRevised];
            }
            
            scoreLabel.text = [NSString stringWithFormat:@"%lu",(long)self.score];
            if(self.score>=10){
                scoreLabel.fontSize = 340;
                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 120);
                
            }
            if(self.score>=100){
                scoreLabel.fontSize = 240;
                scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), 150);
                
            }
            
            // Play Sound
            [self playSoundWithPath:SOUND_JUMP];
        }
    }
}

-(void) playSoundWithPath:(NSString*)name {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    SystemSoundID soundID;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
//    AudioServicesPlaySystemSound (soundID);
}

#pragma mark - Physic

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(wasted){ return; }
    
    SKSpriteNode *firstNode, *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    BirdNode *iBird;
    ObstacleNode *iObstacle;
    
    BOOL isGameOver = YES;
    if ((contact.bodyA.categoryBitMask == birdBitMask)
        && (contact.bodyB.categoryBitMask == blockBitMask)) {
        iBird = (BirdNode*) contact.bodyA.node;
        iObstacle = (ObstacleNode*) contact.bodyB.node;
        
        if ([iBird getTextNumber] == [iObstacle getTextNumber]) {
            isGameOver = NO;
        }
    } else if ((contact.bodyA.categoryBitMask == blockBitMask)
              && (contact.bodyB.categoryBitMask == birdBitMask)) {
        iBird = (BirdNode*) contact.bodyB.node;
        iObstacle = (ObstacleNode*) contact.bodyA.node;
        if ([iBird getTextNumber] == [iObstacle getTextNumber]) {
            isGameOver = NO;
        }
    }
    
    if ( isGameOver) {
    
        wasted = true;
        [Score registerScore:self.score];
        [Score registerReviseScore:self.score];
        
        if([self.delegate respondsToSelector:@selector(eventWasted)]){
            [self.delegate eventWasted];
    
            // Play Sound
            [self playSoundWithPath:SOUND_HIT];
        }
    } else {
        
        // let the Bird go through
        
//        CGPoint anchor = CGPointMake(100, 100);
//        CGVector av =CGVectorMake(0.0, 5.0);
//        SKPhysicsJointSliding* fixedJoint = [SKPhysicsJointSliding jointWithBodyA:iBird.physicsBody
//                                                                        bodyB:iObstacle.physicsBody
//                                                                       anchor:anchor axis:av];
//        [self.scene.physicsWorld addJoint:fixedJoint];
        if (isContacting) {
            
        } else {
            isContacting = YES;
            
            // Convert to Center point
            pointContact = CGPointMake(iObstacle.position.x + NODE_HIGHT/2, iObstacle.position.y + NODE_HIGHT/2);
            
            iObstacle.isContact = YES;
            iBird.isContact = YES;
            iBird.position = CGPointMake(pointContact.x + FLOOR_SCROLLING_SPEED, pointContact.y);
        }
        
//        [iBird setTextNumber:[iBird getTextNumber]*2];
    }
}
@end
