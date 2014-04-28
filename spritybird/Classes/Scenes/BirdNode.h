//
//  BirdNode.h
//  spritybird
//
//  Created by Alexis Creuzot on 16/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#define NODE_HIGHT 50

@interface BirdNode : SKSpriteNode
@property (strong,nonatomic) SKLabelNode *textLabel;
@property (assign,nonatomic) BOOL *isContact;

- (void) update:(NSUInteger) currentTime;
- (void) startPlaying;
- (void) bounce;
- (void) setTextNumber:(int) number;
- (int) getTextNumber;
@end
