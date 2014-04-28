//
//  ObstacleNode.m
//  flappy2048
//
//  Created by Trong Vu on 4/26/14.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "ObstacleNode.h"

@implementation ObstacleNode

- (id)init
{
    if(self = [super init]) {
        self.textLabel.position = CGPointMake(25,25);
    }
    return self;
}


@end
